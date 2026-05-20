const express = require("express");
const router = express.Router();
const pool = require("../database/db");
const { registrarBitacora } = require("../services/bitacora.service");

router.get("/", async (req, res) => {
  try {
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ACCESO_CITAS",
      descripcion: "Acceso a la vista de citas",
      modulo: "CITAS",
      tabla: "TBL_CITAS",
      estado: "EXITO",
      req,
    });
    res.render("citas", { title: "Citas Médicas - Roca Maya" });
  } catch (err) {
    console.error("GET /citas error:", err);
    res.status(500).send("Error interno");
  }
});

router.get("/api/datos", async (req, res) => {
  try {
    // Citas: mostrar Programada, Confirmada, Finalizada, Cancelada, No_Asistio
    const [citas] = await pool.query(`
      SELECT 
        c.ID_CITA,
        CONCAT(p.NOMBRES,' ',p.APELLIDOS) AS NOMBRE_PACIENTE,
        p.TELEFONO AS TELEFONO_PACIENTE,
        p.CORREO_ELECTRONICO AS CORREO_PACIENTE,
        d.ID_USUARIO AS ID_DOCTOR,
        d.NOMBRE_USUARIO AS NOMBRE_DOCTOR,
        d.CORREO_ELECTRONICO AS CORREO_DOCTOR,
        COALESCE(e.NOMBRE_ESPECIALIDAD,'Medicina General') AS ESPECIALIDAD,
        c.FECHA_CITA,
        DATE_FORMAT(c.FECHA_CITA, '%H:%i') AS HORA_CITA,
        c.ESTADO,
        COALESCE(c.TIPO_CITA,'PRIMERA_VEZ') AS TIPO_CITA,
        COALESCE(c.PRIORIDAD,'NORMAL') AS PRIORIDAD,
        COALESCE(c.MOTIVO_CONSULTA,'') AS MOTIVO_CONSULTA,
        c.DURACION_ESTIMADA_MIN,
        c.FECHA_FIN_ESTIMADA,
        c.CANAL_REGISTRO
      FROM TBL_CITAS c
      INNER JOIN TBL_PACIENTE p ON c.ID_PACIENTE = p.ID_PACIENTE
      INNER JOIN TBL_MS_USUARIO d ON c.ID_DOCTOR = d.ID_USUARIO
      LEFT JOIN TBL_DOCTOR_ESPECIALIDAD de ON d.ID_USUARIO = de.ID_DOCTOR
      LEFT JOIN TBL_ESPECIALIDADES e ON de.ID_ESPECIALIDAD = e.ID_ESPECIALIDAD
      WHERE c.ESTADO IN ('PROGRAMADA','CONFIRMADA','FINALIZADA','CANCELADA','NO_ASISTIO')
      ORDER BY 
        FIELD(c.ESTADO,'CONFIRMADA','PROGRAMADA','FINALIZADA','NO_ASISTIO','CANCELADA'),
        c.FECHA_CITA DESC
    `);

    const [doctores] = await pool.query(`
      SELECT 
        u.ID_USUARIO AS ID_DOCTOR,
        u.NOMBRE_USUARIO AS NOMBRE,
        COALESCE(e.NOMBRE_ESPECIALIDAD,'Medicina General') AS ESPECIALIDAD,
        u.CORREO_ELECTRONICO
      FROM TBL_MS_USUARIO u
      LEFT JOIN TBL_DOCTOR_ESPECIALIDAD de ON u.ID_USUARIO = de.ID_DOCTOR
      LEFT JOIN TBL_ESPECIALIDADES e ON de.ID_ESPECIALIDAD = e.ID_ESPECIALIDAD
      WHERE u.ESTADO = 'ACTIVO' AND u.ID_ROL = (SELECT ID_ROL FROM TBL_MS_ROLES WHERE ROL = 'DOCTOR')
    `);

    const [pacientes] = await pool.query(`
      SELECT ID_PACIENTE, NOMBRES, APELLIDOS, TELEFONO, CORREO_ELECTRONICO
      FROM TBL_PACIENTE
      WHERE ESTADO = 'ACTIVO'
      ORDER BY NOMBRES, APELLIDOS
    `);

    const tipos = ["PRIMERA_VEZ", "CONTROL", "EMERGENCIA", "PROCEDIMIENTO"];
    const prioridades = ["NORMAL", "URGENTE", "ALTA"];
    const canales = ["PRESENCIAL", "TELEFONO", "WEB", "MOVIL", "API"];
    const duraciones = [15, 20, 30, 45, 60];

    res.json({
      citas,
      doctores,
      pacientes,
      metadata: { tipos, prioridades, canales, duraciones },
    });
  } catch (err) {
    console.error("Error GET /citas/api/datos:", err);
    res.status(500).json({
      citas: [],
      doctores: [],
      pacientes: [],
      metadata: {},
      error: err.message,
    });
  }
});

// CREAR CITA (sin cambios funcionales)
router.post("/nueva", async (req, res) => {
  try {
    const {
      paciente,
      doctor,
      fechaCita,
      tipoCita,
      prioridad,
      motivo,
      duracion,
      canal,
    } = req.body;

    if (!paciente || !doctor || !fechaCita) {
      return res
        .status(400)
        .json({ success: false, message: "Faltan campos obligatorios" });
    }

    const fecha = new Date(fechaCita);
    if (isNaN(fecha.getTime()))
      return res
        .status(400)
        .json({ success: false, message: "Fecha inválida" });
    if (fecha < new Date())
      return res.status(400).json({
        success: false,
        message: "No se puede programar en el pasado",
      });

    const durMin = Number(duracion) || Number(req.body.duracion) || 30;
    const fechaFin = new Date(fecha.getTime() + durMin * 60000);
    const pad = (n) => String(n).padStart(2, "0");
    const mysqlFecha = `${fecha.getFullYear()}-${pad(
      fecha.getMonth() + 1
    )}-${pad(fecha.getDate())} ${pad(fecha.getHours())}:${pad(
      fecha.getMinutes()
    )}:${pad(fecha.getSeconds())}`;
    const mysqlFin = `${fechaFin.getFullYear()}-${pad(
      fechaFin.getMonth() + 1
    )}-${pad(fechaFin.getDate())} ${pad(fechaFin.getHours())}:${pad(
      fechaFin.getMinutes()
    )}:${pad(fechaFin.getSeconds())}`;

    const [dupRows] = await pool.query(
      `SELECT ID_CITA FROM TBL_CITAS WHERE ID_PACIENTE = ? AND ID_DOCTOR = ? AND FECHA_CITA = ? AND ESTADO != 'CANCELADA' LIMIT 1`,
      [paciente, doctor, mysqlFecha]
    );
    if (dupRows && dupRows.length > 0) {
      return res.status(409).json({
        success: false,
        code: "DUPLICATE_CITA",
        message:
          "Ya existe una cita para ese paciente y doctor en la misma fecha y hora.",
        existingId: dupRows[0].ID_CITA,
      });
    }

    const idUsuarioCreador =
      req.user && req.user.ID_USUARIO ? req.user.ID_USUARIO : 1;
    const usuarioCreacionStr =
      req.user && req.user.USUARIO ? req.user.USUARIO : "SISTEMA";

    const [result] = await pool.query(
      `INSERT INTO TBL_CITAS (ID_PACIENTE, ID_DOCTOR, FECHA_CITA, FECHA_FIN_ESTIMADA, DURACION_ESTIMADA_MIN, MOTIVO_CONSULTA, ESTADO, TIPO_CITA, PRIORIDAD, CANAL_REGISTRO, ID_USUARIOCREADOR, USUARIO_CREACION)
       VALUES (?, ?, ?, ?, ?, ?, 'PROGRAMADA', ?, ?, ?, ?, ?)`,
      [
        paciente,
        doctor,
        mysqlFecha,
        mysqlFin,
        durMin,
        motivo || null,
        tipoCita || "PRIMERA_VEZ",
        prioridad || "NORMAL",
        canal || "PRESENCIAL",
        idUsuarioCreador,
        usuarioCreacionStr,
      ]
    );

    await registrarBitacora({
      usuario: usuarioCreacionStr,
      accion: "CREACION_CITA",
      descripcion: `Creada cita ID ${result.insertId} paciente ${paciente} doctor ${doctor}`,
      modulo: "CITAS",
      idRegistro: result.insertId,
      tabla: "TBL_CITAS",
      estado: "EXITO",
      req,
    });

    try {
      const emitter = req.app.get("emitter");
      if (emitter && typeof emitter.emit === "function") {
        emitter.emit("cita:creada", {
          idCita: result.insertId,
          pacienteId: paciente,
          doctorId: doctor,
          fecha,
          durMin,
          canal,
          motivo,
          usuario: usuarioCreacionStr,
        });
      }
    } catch (emitErr) {
      console.warn("Emitter no disponible:", emitErr);
    }

    res.json({
      success: true,
      message: "Cita creada correctamente",
      idCita: result.insertId,
    });
  } catch (err) {
    console.error("POST /citas/nueva error:", err);
    if (err && err.code === "ER_DUP_ENTRY") {
      return res.status(409).json({
        success: false,
        code: "DUPLICATE_CITA",
        message: "Cita duplicada (DB).",
      });
    }
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ERROR_CREACION_CITA",
      descripcion: err.message,
      modulo: "CITAS",
      tabla: "TBL_CITAS",
      estado: "ERROR",
      detalleError: err.message,
      req,
    });
    res.status(500).json({
      success: false,
      message: "Error creando la cita: " + err.message,
    });
  }
});

async function handleCambiarEstado(req, res) {
  try {
    const { idCita, nuevoEstado } = req.body;
    if (!idCita || !nuevoEstado)
      return res
        .status(400)
        .json({ success: false, message: "Parámetros requeridos" });

    const usuario = req.user ? req.user.USUARIO : "SISTEMA";
    const [result] = await pool.query(
      `UPDATE TBL_CITAS SET ESTADO = ?, FECHA_MODIFICACION = CURRENT_TIMESTAMP, USUARIO_MODIFICACION = ? WHERE ID_CITA = ?`,
      [nuevoEstado, usuario, idCita]
    );
    if (result.affectedRows === 0)
      return res
        .status(404)
        .json({ success: false, message: "Cita no encontrada" });

    await registrarBitacora({
      usuario,
      accion: "CAMBIO_ESTADO_CITA",
      descripcion: `Cita ${idCita} -> ${nuevoEstado}`,
      modulo: "CITAS",
      idRegistro: idCita,
      tabla: "TBL_CITAS",
      estado: "EXITO",
      req,
    });

    res.json({ success: true, message: "Estado actualizado" });
  } catch (err) {
    console.error("POST /citas/cambiar-estado error:", err);
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ERROR_CAMBIO_ESTADO_CITA",
      descripcion: err.message,
      modulo: "CITAS",
      tabla: "TBL_CITAS",
      estado: "ERROR",
      detalleError: err.message,
      req,
    });
    res.status(500).json({
      success: false,
      message: "Error cambiando estado: " + err.message,
    });
  }
}

router.post("/cambiar-estado", handleCambiarEstado);
router.post("/estado", handleCambiarEstado); // alias (frontend antiguo)

module.exports = router;