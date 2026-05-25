const express = require("express");
const router = express.Router();
const pool = require("../database/db");

// =====================================================================
// 1. LISTAR USUARIOS
// =====================================================================
router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT ID_USUARIO, USUARIO, NOMBRE_USUARIO, ESTADO, ACTIVO_2FA
      FROM TBL_MS_USUARIO
      ORDER BY ID_USUARIO DESC
      LIMIT 20
    `);

    res.render("users", { users: rows });
  } catch (error) {
    console.error("Error al obtener usuarios:", error);
    res.status(500).send("Error en el servidor");
  }
});

// =====================================================================
// 2. ACTUALIZAR USUARIO vía AJAX + BITÁCORA
// =====================================================================
router.post("/api/update", async (req, res) => {
  const { id, usuario, nombre_usuario, estado, activo_2fa, usuarioAccion } = req.body;

  if (!id || !usuarioAccion) {
    return res.status(400).json({ 
      ok: false, 
      msg: "Datos incompletos: ID y usuarioAccion son requeridos" 
    });
  }

  try {
    const [prev] = await pool.query(`SELECT * FROM TBL_MS_USUARIO WHERE ID_USUARIO = ?`, [id]);
    if (prev.length === 0) {
      return res.status(404).json({ ok: false, msg: "Usuario no encontrado" });
    }

    const anterior = prev[0];

    // Actualizar usuario
    await pool.query(`
      UPDATE TBL_MS_USUARIO
      SET USUARIO = ?, NOMBRE_USUARIO = ?, ESTADO = ?, ACTIVO_2FA = ?
      WHERE ID_USUARIO = ?
    `, [usuario, nombre_usuario, estado, activo_2fa, id]);


    try {
      const cambios = [];

      if (anterior.USUARIO !== usuario) {
        cambios.push(`USUARIO: '${anterior.USUARIO}' → '${usuario}'`);
      }
      
      if (anterior.NOMBRE_USUARIO !== nombre_usuario) {
        cambios.push(`NOMBRE: '${anterior.NOMBRE_USUARIO}' → '${nombre_usuario}'`);
      }
      
      if (anterior.ESTADO !== estado) {
        cambios.push(`ESTADO: '${anterior.ESTADO}' → '${estado}'`);
      }
      
      if (parseInt(anterior.ACTIVO_2FA) !== parseInt(activo_2fa)) {
        cambios.push(`2FA: '${anterior.ACTIVO_2FA}' → '${activo_2fa}'`);
      }

      if (cambios.length > 0) {
        const descripcion = `Modificación de usuario: ${cambios.join("; ")}`;
        
        await pool.query(`
          INSERT INTO TBL_MS_BITACORA (
            ID_USUARIO, ACCION, DESCRIPCION, MODULO, ID_REGISTRO_AFECTADO, 
            TABLA_AFECTADA, USUARIO_CREACION
          ) VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [
          id, 
          'ACTUALIZACION', 
          descripcion, 
          'USUARIOS', 
          id, 
          'TBL_MS_USUARIO', 
          usuarioAccion
        ]);
      }
    } catch (bitacoraError) {
      console.warn("No se pudo registrar en bitácora, pero el usuario fue actualizado:", bitacoraError.message);
    }

    res.json({ 
      ok: true, 
      msg: "Usuario actualizado correctamente"
    });

  } catch (error) {
    console.error("Error en actualización:", error);
    res.status(500).json({ ok: false, msg: "Error en el servidor: " + error.message });
  }
});

// =====================================================================
// 3. ELIMINAR USUARIO PERMANENTEMENTE
// =====================================================================
router.post("/api/delete", async (req, res) => {
  const { id, usuarioAccion } = req.body;

  if (!id) {
    return res.status(400).json({ 
      ok: false, 
      msg: "Datos incompletos: ID es requerido" 
    });
  }

  let usuarioEliminado = null;
  let nombreUsuario = "";

  try {
    const [usuario] = await pool.query(`SELECT * FROM TBL_MS_USUARIO WHERE ID_USUARIO = ?`, [id]);
    if (usuario.length === 0) {
      return res.status(404).json({ ok: false, msg: "Usuario no encontrado" });
    }

    usuarioEliminado = usuario[0];
    nombreUsuario = usuarioEliminado.USUARIO;

    try {
      await pool.query(`
        INSERT INTO TBL_MS_BITACORA (
          ID_USUARIO, ACCION, DESCRIPCION, MODULO, ID_REGISTRO_AFECTADO, 
          TABLA_AFECTADA, USUARIO_CREACION
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      `, [
        id, 
        'ELIMINACION', 
        `Eliminación permanente del usuario: ${nombreUsuario}`, 
        'USUARIOS', 
        id, 
        'TBL_MS_USUARIO', 
        usuarioAccion || 'Sistema'
      ]);
      
      
    } catch (bitacoraError) {
      console.warn("No se pudo registrar en bitácora:", bitacoraError.message);
      
    }


    const [result] = await pool.query(`DELETE FROM TBL_MS_USUARIO WHERE ID_USUARIO = ?`, [id]);
    

    if (result.affectedRows === 0) {
      return res.status(500).json({ 
        ok: false, 
        msg: "No se pudo eliminar el usuario" 
      });
    }

    res.json({ 
      ok: true, 
      msg: `Usuario "${nombreUsuario}" eliminado correctamente`
    });

  } catch (error) {
    console.error("ERROR AL ELIMINAR USUARIO:", error);
    
    let mensajeError = "Error en el servidor al eliminar usuario";
    
    if (error.code === 'ER_ROW_IS_REFERENCED_2' || error.code === 'ER_ROW_IS_REFERENCED') {
      mensajeError = "No se puede eliminar el usuario porque tiene registros relacionados en otras tablas";
    } else if (error.code === 'ER_NO_REFERENCED_ROW_2') {
      mensajeError = "Error de integridad referencial";
    } else if (error.message.includes('foreign key constraint')) {
      mensajeError = "No se puede eliminar el usuario porque está siendo referenciado en otras tablas";
    }
    
    res.status(500).json({ 
      ok: false, 
      msg: mensajeError + ": " + error.message 
    });
  }
});

// =====================================================================
// 4. CAMBIAR ESTADO DE USUARIO (ACTIVAR/DESACTIVAR)
// =====================================================================
router.post("/api/cambiar-estado", async (req, res) => {
  const { id, estado, usuarioAccion } = req.body;

  if (!id || !estado) {
    return res.status(400).json({ 
      ok: false, 
      msg: "Datos incompletos" 
    });
  }

  try {
    const [prev] = await pool.query(`SELECT * FROM TBL_MS_USUARIO WHERE ID_USUARIO = ?`, [id]);
    if (prev.length === 0) {
      return res.status(404).json({ ok: false, msg: "Usuario no encontrado" });
    }

    const anterior = prev[0];
    await pool.query(`UPDATE TBL_MS_USUARIO SET ESTADO = ? WHERE ID_USUARIO = ?`, [estado, id]);

    try {
      await pool.query(`
        INSERT INTO TBL_MS_BITACORA (
          ID_USUARIO, ACCION, DESCRIPCION, MODULO, ID_REGISTRO_AFECTADO, 
          TABLA_AFECTADA, USUARIO_CREACION
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
      `, [
        id, 
        'CAMBIO_ESTADO', 
        `Cambió estado del usuario de '${anterior.ESTADO}' a '${estado}'`, 
        'USUARIOS', 
        id, 
        'TBL_MS_USUARIO', 
        usuarioAccion || 'Sistema'
      ]);
    } catch (bitacoraError) {
      console.warn("No se pudo registrar en bitácora:", bitacoraError.message);
    }

    res.json({ 
      ok: true, 
      msg: `Usuario ${estado === 'ACTIVO' ? 'activado' : 'desactivado'} correctamente`
    });

  } catch (error) {
    console.error("Error al cambiar estado:", error);
    res.status(500).json({ ok: false, msg: "Error en el servidor" });
  }
});

module.exports = router;
