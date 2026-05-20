const express = require("express");
const router = express.Router();
const pool = require("../database/db");

const logError = (error, context) => {
  console.error(`Error en ${context}:`, error);
};

// GET /pacientes -> Vista (mantengo tu implementación original)
router.get("/", async (req, res) => {
  try {
    const [pacientes] = await pool.query(`
      SELECT 
        ID_PACIENTE,
        NOMBRES,
        APELLIDOS,
        FECHA_NACIMIENTO,
        GENERO,
        DIRECCION,
        TELEFONO,
        CORREO_ELECTRONICO,
        TIPO_DOCUMENTO_IDENTIDAD,
        NUMERO_DOCUMENTO_IDENTIDAD,
        RTN_PACIENTE,
        ESTADO_CIVIL,
        OCUPACION,
        NOMBRE_CONTACTO_EMERGENCIA,
        TELEFONO_CONTACTO_EMERGENCIA,
        PARENTESCO_CONTACTO_EMERGENCIA,
        ESTADO,
        FECHA_REGISTRO,
        FECHA_ACTUALIZACION,
        USUARIO_CREACION,
        USUARIO_MODIFICACION
      FROM TBL_PACIENTE
      WHERE ESTADO = 'ACTIVO'
      ORDER BY FECHA_REGISTRO DESC
    `);

    res.render("pacientes", {
      title: "Gestión de Pacientes",
      pacientes,
      usuario: req.user || { nombre: "Usuario" },
    });
  } catch (error) {
    logError(error, "GET /");
    res.status(500).render("error", {
      message: "Error al cargar los pacientes",
      error: process.env.NODE_ENV === "development" ? error : {},
    });
  }
});

// GET /pacientes/api/:id -> detalle (igual)
router.get("/api/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      `
      SELECT 
        ID_PACIENTE,
        NOMBRES,
        APELLIDOS,
        FECHA_NACIMIENTO,
        GENERO,
        DIRECCION,
        TELEFONO,
        CORREO_ELECTRONICO,
        TIPO_DOCUMENTO_IDENTIDAD,
        NUMERO_DOCUMENTO_IDENTIDAD,
        RTN_PACIENTE,
        ESTADO_CIVIL,
        OCUPACION,
        NOMBRE_CONTACTO_EMERGENCIA,
        TELEFONO_CONTACTO_EMERGENCIA,
        PARENTESCO_CONTACTO_EMERGENCIA,
        ESTADO,
        FECHA_REGISTRO,
        FECHA_ACTUALIZACION,
        USUARIO_CREACION,
        USUARIO_MODIFICACION
      FROM TBL_PACIENTE
      WHERE ID_PACIENTE = ?
    `,
      [id]
    );

    if (rows.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "Paciente no encontrado" });
    }

    res.json({ success: true, data: rows[0] });
  } catch (error) {
    logError(error, "GET /api/:id");
    res.status(500).json({
      success: false,
      message: "Error al obtener paciente",
    });
  }
});

// POST /pacientes/api -> Crear pero con verificación previa de documento
router.post("/api", async (req, res) => {
  try {
    const {
      NOMBRES,
      APELLIDOS,
      FECHA_NACIMIENTO,
      GENERO,
      DIRECCION,
      TELEFONO,
      CORREO_ELECTRONICO,
      TIPO_DOCUMENTO_IDENTIDAD,
      NUMERO_DOCUMENTO_IDENTIDAD,
      RTN_PACIENTE,
      ESTADO_CIVIL,
      OCUPACION,
      NOMBRE_CONTACTO_EMERGENCIA,
      TELEFONO_CONTACTO_EMERGENCIA,
      PARENTESCO_CONTACTO_EMERGENCIA,
      ESTADO = "ACTIVO",
    } = req.body;

    // Validación mínima
    if (!NOMBRES || !APELLIDOS || !NUMERO_DOCUMENTO_IDENTIDAD) {
      return res.status(400).json({
        success: false,
        message: "Nombres, apellidos y documento son obligatorios",
      });
    }

    // 1) Comprobar si ya existe paciente activo con ese documento
    const [existe] = await pool.query(
      `SELECT ID_PACIENTE FROM TBL_PACIENTE WHERE NUMERO_DOCUMENTO_IDENTIDAD = ? AND ESTADO = 'ACTIVO'`,
      [NUMERO_DOCUMENTO_IDENTIDAD]
    );

    if (existe.length > 0) {
      // Devolver código 409 (Conflict) con payload estructurado para cliente
      return res.status(409).json({
        success: false,
        code: "DUPLICATE_DOCUMENT",
        message: "Ya existe un paciente activo con este número de documento",
        existingId: existe[0].ID_PACIENTE,
      });
    }

    // 2) Insertar paciente (normal)
    const [result] = await pool.query(
      `
      INSERT INTO TBL_PACIENTE (
        NOMBRES, APELLIDOS, FECHA_NACIMIENTO, GENERO,
        DIRECCION, TELEFONO, CORREO_ELECTRONICO,
        TIPO_DOCUMENTO_IDENTIDAD, NUMERO_DOCUMENTO_IDENTIDAD,
        RTN_PACIENTE, ESTADO_CIVIL, OCUPACION,
        NOMBRE_CONTACTO_EMERGENCIA, TELEFONO_CONTACTO_EMERGENCIA,
        PARENTESCO_CONTACTO_EMERGENCIA, ESTADO, USUARIO_CREACION
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `,
      [
        NOMBRES,
        APELLIDOS,
        FECHA_NACIMIENTO || null,
        GENERO || "OTRO",
        DIRECCION || null,
        TELEFONO || null,
        CORREO_ELECTRONICO || null,
        TIPO_DOCUMENTO_IDENTIDAD || "DNI",
        NUMERO_DOCUMENTO_IDENTIDAD,
        RTN_PACIENTE || null,
        ESTADO_CIVIL || null,
        OCUPACION || null,
        NOMBRE_CONTACTO_EMERGENCIA || null,
        TELEFONO_CONTACTO_EMERGENCIA || null,
        PARENTESCO_CONTACTO_EMERGENCIA || null,
        ESTADO,
        req.user?.nombre || "ADMIN",
      ]
    );

    res.json({
      success: true,
      message: "Paciente creado correctamente",
      data: { ID_PACIENTE: result.insertId },
    });
  } catch (error) {
    logError(error, "POST /api");
    // Manejo de race condition: duplicate key thrown por BD aun con verificación previa
    if (error && error.code === "ER_DUP_ENTRY") {
      // Intentamos extraer el valor o informar genérico (sin cambiar BD)
      return res.status(409).json({
        success: false,
        code: "DUPLICATE_DOCUMENT",
        message: "Ya existe un paciente con ese número de documento (error DB)",
        existingId: null,
        detail: error.message,
      });
    }
    res.status(500).json({
      success: false,
      message: "Error al crear paciente: " + error.message,
    });
  }
});

// PUT /pacientes/api/:id -> Actualizar con verificación de duplicados (otro paciente)
router.put("/api/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const {
      NOMBRES,
      APELLIDOS,
      FECHA_NACIMIENTO,
      GENERO,
      DIRECCION,
      TELEFONO,
      CORREO_ELECTRONICO,
      TIPO_DOCUMENTO_IDENTIDAD,
      NUMERO_DOCUMENTO_IDENTIDAD,
      RTN_PACIENTE,
      ESTADO_CIVIL,
      OCUPACION,
      NOMBRE_CONTACTO_EMERGENCIA,
      TELEFONO_CONTACTO_EMERGENCIA,
      PARENTESCO_CONTACTO_EMERGENCIA,
      ESTADO,
    } = req.body;

    if (!NOMBRES || !APELLIDOS || !NUMERO_DOCUMENTO_IDENTIDAD) {
      return res.status(400).json({
        success: false,
        message: "Nombres, apellidos y documento son obligatorios",
      });
    }

    // Comprobar si otro paciente activo tiene el mismo documento
    const [existe] = await pool.query(
      `SELECT ID_PACIENTE FROM TBL_PACIENTE WHERE NUMERO_DOCUMENTO_IDENTIDAD = ? AND ID_PACIENTE != ? AND ESTADO = 'ACTIVO'`,
      [NUMERO_DOCUMENTO_IDENTIDAD, id]
    );

    if (existe.length > 0) {
      return res.status(409).json({
        success: false,
        code: "DUPLICATE_DOCUMENT",
        message: "Ya existe otro paciente activo con este número de documento",
        existingId: existe[0].ID_PACIENTE,
      });
    }

    const [result] = await pool.query(
      `
      UPDATE TBL_PACIENTE SET
        NOMBRES = ?, APELLIDOS = ?, FECHA_NACIMIENTO = ?, GENERO = ?,
        DIRECCION = ?, TELEFONO = ?, CORREO_ELECTRONICO = ?,
        TIPO_DOCUMENTO_IDENTIDAD = ?, NUMERO_DOCUMENTO_IDENTIDAD = ?,
        RTN_PACIENTE = ?, ESTADO_CIVIL = ?, OCUPACION = ?,
        NOMBRE_CONTACTO_EMERGENCIA = ?, TELEFONO_CONTACTO_EMERGENCIA = ?,
        PARENTESCO_CONTACTO_EMERGENCIA = ?, ESTADO = ?,
        FECHA_ACTUALIZACION = NOW(), USUARIO_MODIFICACION = ?
      WHERE ID_PACIENTE = ?
    `,
      [
        NOMBRES,
        APELLIDOS,
        FECHA_NACIMIENTO || null,
        GENERO || "OTRO",
        DIRECCION || null,
        TELEFONO || null,
        CORREO_ELECTRONICO || null,
        TIPO_DOCUMENTO_IDENTIDAD || "DNI",
        NUMERO_DOCUMENTO_IDENTIDAD,
        RTN_PACIENTE || null,
        ESTADO_CIVIL || null,
        OCUPACION || null,
        NOMBRE_CONTACTO_EMERGENCIA || null,
        TELEFONO_CONTACTO_EMERGENCIA || null,
        PARENTESCO_CONTACTO_EMERGENCIA || null,
        ESTADO,
        req.user?.nombre || "ADMIN",
        id,
      ]
    );

    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ success: false, message: "Paciente no encontrado" });
    }

    res.json({ success: true, message: "Paciente actualizado correctamente" });
  } catch (error) {
    logError(error, "PUT /api/:id");
    if (error && error.code === "ER_DUP_ENTRY") {
      return res.status(409).json({
        success: false,
        code: "DUPLICATE_DOCUMENT",
        message:
          "Ya existe otro paciente con ese número de documento (error DB)",
        existingId: null,
        detail: error.message,
      });
    }
    res.status(500).json({
      success: false,
      message: "Error al actualizar paciente: " + error.message,
    });
  }
});

// DELETE /pacientes/api/:id -> Inactivar
router.delete("/api/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await pool.query(
      `
      UPDATE TBL_PACIENTE SET
        ESTADO = 'INACTIVO',
        FECHA_ACTUALIZACION = NOW(),
        USUARIO_MODIFICACION = ?
      WHERE ID_PACIENTE = ?
    `,
      [req.user?.nombre || "ADMIN", id]
    );

    if (result.affectedRows === 0) {
      return res
        .status(404)
        .json({ success: false, message: "Paciente no encontrado" });
    }

    res.json({ success: true, message: "Paciente eliminado correctamente" });
  } catch (error) {
    logError(error, "DELETE /api/:id");
    res.status(500).json({
      success: false,
      message: "Error al eliminar paciente",
    });
  }
});

module.exports = router;
