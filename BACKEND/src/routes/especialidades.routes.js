// fileName: especialidades.routes.js
const express = require("express");
const router = express.Router();
const pool = require("../database/db"); 
const { registrarBitacora } = require("../services/bitacora.service"); 

// Helper para obtener el usuario actual
function getUsuario(req) {
  return req.user?.USUARIO || "SISTEMA";
}

// ======================================================
// RUTA VISTA PRINCIPAL
// ======================================================
router.get("/", async (req, res) => {
  try {
    await registrarBitacora({
      usuario: getUsuario(req),
      accion: "ACCESO_ESPECIALIDADES",
      descripcion: "Acceso a la vista de especialidades",
      modulo: "ESPECIALIDADES",
      tabla: "TBL_ESPECIALIDADES",
      estado: "EXITO",
      req,
    });

    res.render("especialidades", { title: "Especialidades Médicas" });
  } catch (err) {
    console.error("GET /especialidades error:", err);
    res.status(500).send("Error interno del servidor.");
  }
});

// ======================================================
// API: OBTENER TODAS LAS ESPECIALIDADES
// ======================================================
router.get("/api/datos", async (req, res) => {
  try {
    const [especialidades] = await pool.query(`
      SELECT 
        ID_ESPECIALIDAD,
        NOMBRE_ESPECIALIDAD,
        DESCRIPCION,
        COALESCE(COLOR_HEXADECIMAL, '#3498DB') AS COLOR_HEXADECIMAL,
        COALESCE(ICONO, 'fas fa-stethoscope') AS ICONO,
        ESTADO
      FROM TBL_ESPECIALIDADES
      ORDER BY ESTADO DESC, NOMBRE_ESPECIALIDAD ASC
    `);

    res.json({ especialidades });
  } catch (err) {
    console.error("Error GET /especialidades/api/datos:", err);
    res.status(500).json({ error: "Error al obtener datos." });
  }
});

// ======================================================
// API: CREAR ESPECIALIDAD
// ======================================================
router.post("/nueva", async (req, res) => {
  const { nombre, descripcion, color, icono } = req.body;
  const usuario = getUsuario(req);

  try {
    if (!nombre)
      return res.status(400).json({ success: false, message: "El nombre es obligatorio" });

    const [result] = await pool.query(
      `INSERT INTO TBL_ESPECIALIDADES 
       (NOMBRE_ESPECIALIDAD, DESCRIPCION, COLOR_HEXADECIMAL, ICONO, USUARIO_CREACION)
       VALUES (?, ?, ?, ?, ?)`,
      [nombre, descripcion || null, color || null, icono || null, usuario]
    );

    await registrarBitacora({
      usuario,
      accion: "CREACION_ESPECIALIDAD",
      descripcion: `Creada especialidad ID ${result.insertId}: ${nombre}`,
      modulo: "ESPECIALIDADES",
      idRegistro: result.insertId,
      tabla: "TBL_ESPECIALIDADES",
      estado: "EXITO",
      req,
    });

    res.json({ success: true, message: "Especialidad creada correctamente" });
  } catch (err) {
    console.error("POST /especialidades/nueva error:", err);

    if (err.code === "ER_DUP_ENTRY") {
      return res.status(409).json({
        success: false,
        message: `Ya existe una especialidad con el nombre '${nombre}'.`,
      });
    }

    registrarBitacora({
      usuario,
      accion: "ERROR_CREACION_ESPECIALIDAD",
      descripcion: err.message,
      modulo: "ESPECIALIDADES",
      tabla: "TBL_ESPECIALIDADES",
      estado: "ERROR",
      detalleError: err.message,
      req,
    }).catch(console.error);

    res.status(500).json({ success: false, message: "Error interno creando especialidad." });
  }
});

// ======================================================
// API: ACTUALIZAR ESPECIALIDAD
// ======================================================
router.put("/actualizar/:id", async (req, res) => {
  const { id } = req.params;
  const { nombre, descripcion, color, icono, estado } = req.body;
  const usuario = getUsuario(req);

  try {
    if (!nombre || !estado)
      return res.status(400).json({ success: false, message: "Nombre y estado son obligatorios" });

    const [result] = await pool.query(
      `UPDATE TBL_ESPECIALIDADES 
       SET NOMBRE_ESPECIALIDAD=?, DESCRIPCION=?, COLOR_HEXADECIMAL=?, ICONO=?, 
           ESTADO=?, USUARIO_MODIFICACION=?
       WHERE ID_ESPECIALIDAD=?`,
      [nombre, descripcion || null, color || null, icono || null, estado, usuario, id]
    );

    if (result.affectedRows === 0)
      return res.status(404).json({ success: false, message: "Especialidad no encontrada" });

    await registrarBitacora({
      usuario,
      accion: "ACTUALIZACION_ESPECIALIDAD",
      descripcion: `Actualizada especialidad ID ${id}: ${nombre}`,
      modulo: "ESPECIALIDADES",
      idRegistro: id,
      tabla: "TBL_ESPECIALIDADES",
      estado: "EXITO",
      req,
    });

    res.json({ success: true, message: "Especialidad actualizada correctamente" });
  } catch (err) {
    console.error("PUT /especialidades/actualizar/:id error:", err);

    if (err.code === "ER_DUP_ENTRY") {
      return res.status(409).json({
        success: false,
        message: `Ya existe otra especialidad con el nombre '${nombre}'.`,
      });
    }

    registrarBitacora({
      usuario,
      accion: "ERROR_ACTUALIZACION_ESPECIALIDAD",
      descripcion: err.message,
      modulo: "ESPECIALIDADES",
      tabla: "TBL_ESPECIALIDADES",
      estado: "ERROR",
      detalleError: err.message,
      req,
    }).catch(console.error);

    res.status(500).json({ success: false, message: "Error interno actualizando especialidad." });
  }
});

// ======================================================
// API: CAMBIAR ESTADO (ACTIVA / INACTIVA)
// ======================================================
router.post("/cambiar-estado", async (req, res) => {
  const { idEspecialidad, nuevoEstado } = req.body;
  const usuario = getUsuario(req);

  try {
    if (!idEspecialidad || !nuevoEstado)
      return res.status(400).json({ success: false, message: "Parámetros requeridos" });

    const id = Number(idEspecialidad);
    if (isNaN(id) || id <= 0)
      return res.status(400).json({ success: false, message: "ID inválido" });

    if (!["ACTIVA", "INACTIVA"].includes(nuevoEstado))
      return res.status(400).json({ success: false, message: "Estado inválido" });

    const [result] = await pool.query(
      `UPDATE TBL_ESPECIALIDADES 
       SET ESTADO=?, USUARIO_MODIFICACION=?
       WHERE ID_ESPECIALIDAD=?`,
      [nuevoEstado, usuario, id]
    );

    if (result.affectedRows === 0)
      return res.status(404).json({ success: false, message: "Especialidad no encontrada" });

    await registrarBitacora({
      usuario,
      accion: "CAMBIO_ESTADO_ESPECIALIDAD",
      descripcion: `Especialidad ${id} -> ${nuevoEstado}`,
      modulo: "ESPECIALIDADES",
      idRegistro: id,
      tabla: "TBL_ESPECIALIDADES",
      estado: "EXITO",
      req,
    });

    res.json({ success: true, message: `Especialidad cambiada a ${nuevoEstado} correctamente` });
  } catch (err) {
    console.error("POST /especialidades/cambiar-estado error:", err);

    registrarBitacora({
      usuario,
      accion: "ERROR_CAMBIO_ESTADO_ESPECIALIDAD",
      descripcion: err.message,
      modulo: "ESPECIALIDADES",
      tabla: "TBL_ESPECIALIDADES",
      estado: "ERROR",
      detalleError: err.message,
      req,
    }).catch(console.error);

    res.status(500).json({ success: false, message: "Error interno del servidor al cambiar estado." });
  }
    // ✅ NUEVO: BOTÓN ELIMINAR DEFINITIVO
  botones.push(
    `<button class="btn-accion danger" data-action="eliminar" data-id="${id}" title="Eliminar">
        <i class="fas fa-trash"></i>
     </button>`
  );

  return `<div class="acciones">${botones.join("")}</div>`;

});

// ======================================================
// API: ELIMINAR ESPECIALIDAD (DELETE REAL)
// ======================================================
router.delete("/eliminar/:id", async (req, res) => {
  const { id } = req.params;
  const usuario = getUsuario(req);

  try {
    const [result] = await pool.query(
      `DELETE FROM TBL_ESPECIALIDADES WHERE ID_ESPECIALIDAD = ?`,
      [id]
    );

    if (result.affectedRows === 0)
      return res.status(404).json({ success: false, message: "Especialidad no encontrada" });

    await registrarBitacora({
      usuario,
      accion: "ELIMINACION_ESPECIALIDAD",
      descripcion: `Eliminada especialidad ID ${id}`,
      modulo: "ESPECIALIDADES",
      idRegistro: id,
      tabla: "TBL_ESPECIALIDADES",
      estado: "EXITO",
      req,
    });

    res.json({ success: true, message: "Especialidad eliminada correctamente" });
  } catch (err) {
    console.error("DELETE /especialidades/eliminar/:id error:", err);

    registrarBitacora({
      usuario,
      accion: "ERROR_ELIMINACION_ESPECIALIDAD",
      descripcion: err.message,
      modulo: "ESPECIALIDADES",
      tabla: "TBL_ESPECIALIDADES",
      estado: "ERROR",
      detalleError: err.message,
      req,
    }).catch(console.error);

    res.status(500).json({ success: false, message: "Error interno eliminando especialidad." });
  }
});
router.delete("/eliminar/:id", async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query(
      "DELETE FROM TBL_ESPECIALIDADES WHERE ID_ESPECIALIDAD = ?",
      [id]
    );

    res.json({ success: true, message: "Especialidad eliminada exitosamente" });

  } catch (error) {
    console.error("Error eliminando especialidad:", error);
    res.status(500).json({
      success: false,
      message: "Error al eliminar la especialidad"
    });
  }
});


module.exports = router;
