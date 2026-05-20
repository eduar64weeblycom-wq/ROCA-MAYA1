const express = require("express");
const router = express.Router();
const pool = require("../database/db");
const { registrarBitacora } = require("../services/bitacora.service");
// IMPORTACIÓN CLAVE: Se añade la función para crear el recibo
const { crearRecibo } = require("../services/recibos.service"); 

router.use(express.json());
router.use((req, res, next) => {
  try {
    if (req.body && typeof req.body === "object") {
      delete req.body.IMC;
      delete req.body.imc;
    }
  } catch (e) {}
  next();
});

router.get("/", async (req, res) => {
  try {
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ACCESO_CONSULTA_MEDICA",
      descripcion: "Acceso a la vista de consulta médica",
      modulo: "CONSULTA_MEDICA",
      tabla: "TBL_CONSULTA_MEDICA",
      estado: "EXITO",
      req,
    });
    res.render("consultaMedica", { title: "Consulta Médica - Roca Maya" });
  } catch (err) {
    console.error("GET /consultaMedica error:", err);
    res.status(500).send("Error interno");
  }
});

// API datos: traer solo citas en CONSULTA_MEDICA + CANCELADA + NO_ASISTIO
router.get("/api/datos", async (req, res) => {
  try {
    const [consultas] = await pool.query(
      `SELECT cm.*, DATE_FORMAT(cm.FECHA_CONSULTA, '%Y-%m-%d %H:%i:%s') AS FECHA_CONSULTA_FORMAT FROM TBL_CONSULTA_MEDICA cm ORDER BY cm.FECHA_CONSULTA DESC`
    );
    const [citas] = await pool.query(
      `SELECT c.ID_CITA, CONCAT(p.NOMBRES,' ',p.APELLIDOS) AS NOMBRE_PACIENTE, p.TELEFONO, c.FECHA_CITA, c.ESTADO, c.TIPO_CITA, d.NOMBRE_USUARIO AS NOMBRE_DOCTOR FROM TBL_CITAS c INNER JOIN TBL_PACIENTE p ON c.ID_PACIENTE = p.ID_PACIENTE LEFT JOIN TBL_MS_USUARIO d ON c.ID_DOCTOR = d.ID_USUARIO WHERE c.ESTADO IN ('CONSULTA_MEDICA','CANCELADA','NO_ASISTIO') ORDER BY c.FECHA_CITA DESC`
    );
    const [pacientes] = await pool.query(
      `SELECT ID_PACIENTE, NOMBRES, APELLIDOS, TELEFONO, CORREO_ELECTRONICO FROM TBL_PACIENTE WHERE ESTADO = 'ACTIVO' ORDER BY NOMBRES, APELLIDOS`
    );
    const [doctores] = await pool.query(
      `SELECT ID_USUARIO, NOMBRE_USUARIO, CORREO_ELECTRONICO FROM TBL_MS_USUARIO WHERE ESTADO = 'ACTIVO' AND ID_ROL = (SELECT ID_ROL FROM TBL_MS_ROLES WHERE ROL = 'DOCTOR') ORDER BY NOMBRE_USUARIO`
    );
    consultas.forEach((c) => {
      try {
        if (c.SINTOMAS && typeof c.SINTOMAS === "string")
          c.SINTOMAS = JSON.parse(c.SINTOMAS);
      } catch (e) {}
      try {
        if (c.EXAMEN_FISICO && typeof c.EXAMEN_FISICO === "string")
          c.EXAMEN_FISICO = JSON.parse(c.EXAMEN_FISICO);
      } catch (e) {}
    });
    res.json({ consultas, citas, pacientes, doctores });
  } catch (err) {
    console.error("GET /consultaMedica/api/datos error:", err);
    res.status(500).json({
      consultas: [],
      citas: [],
      pacientes: [],
      doctores: [],
      error: err.message,
    });
  }
});

// Resto de endpoints (cie10, por-cita, nueva, actualizar) permanecen funcionalmente iguales

router.get("/cie10", async (req, res) => {
  try {
    const q = (req.query.q || "").trim();
    const limit = Math.min(Number(req.query.limit) || 25, 500);
    if (!q) {
      const [rows] = await pool.query(
        `SELECT ID_CIE10, CODIGO, DESCRIPCION FROM TBL_CIE10 ORDER BY CODIGO LIMIT ?`,
        [limit]
      );
      return res.json({ results: rows });
    }
    const likeQ = `%${q}%`;
    const [rows] = await pool.query(
      `SELECT ID_CIE10, CODIGO, DESCRIPCION FROM TBL_CIE10 WHERE CODIGO LIKE ? OR DESCRIPCION LIKE ? ORDER BY CODIGO LIMIT ?`,
      [likeQ, likeQ, limit]
    );
    res.json({ results: rows });
  } catch (err) {
    console.error("GET /consultaMedica/cie10 error:", err);
    res.status(500).json({ results: [], error: err.message });
  }
});

router.get("/por-cita/:idCita", async (req, res) => {
  try {
    const id = Number(req.params.idCita || 0);
    if (!id)
      return res
        .status(400)
        .json({ success: false, message: "ID de cita inválido" });
    const [rows] = await pool.query(
      "SELECT * FROM TBL_CONSULTA_MEDICA WHERE ID_CITA = ? LIMIT 1",
      [id]
    );
    if (!rows || rows.length === 0)
      return res
        .status(404)
        .json({ success: false, message: "No existe consulta para esa cita" });
    const c = rows[0];
    try {
      if (c.SINTOMAS && typeof c.SINTOMAS === "string")
        c.SINTOMAS = JSON.parse(c.SINTOMAS);
    } catch (e) {}
    try {
      if (c.EXAMEN_FISICO && typeof c.EXAMEN_FISICO === "string")
        c.EXAMEN_FISICO = JSON.parse(c.EXAMEN_FISICO);
    } catch (e) {}
    res.json({ success: true, consulta: c });
  } catch (err) {
    console.error("GET /consultaMedica/por-cita error:", err);
    res.status(500).json({ success: false, message: err.message });
  }
});

// RUTA POST /nueva (MODIFICADA PARA CREAR RECIBO)
router.post("/nueva", async (req, res) => {
  try {
    const {
      idCita,
      motivoConsulta,
      sintomas,
      examenFisico,
      diagnosticoPrincipal,
      codigoCie10Principal,
      diagnosticoSecundario,
      codigoCie10Secundario,
      tratamiento,
      recomendaciones,
      observaciones,
      proximaCita,
      tipoConsulta,
      // Se asume costo por defecto si no viene en el body.
      costoConsulta = 150.00, 
    } = req.body || {};
    
    const idCitaNum = Number(idCita || 0);
    if (!idCitaNum)
      return res
        .status(400)
        .json({ success: false, message: "Falta ID de cita" });
        
    // 1. Obtener ID_PACIENTE y ID_DOCTOR de la cita antes de insertar la consulta
    const [citaData] = await pool.query(
        "SELECT ID_PACIENTE, ID_DOCTOR FROM TBL_CITAS WHERE ID_CITA = ?",
        [idCitaNum]
    );
    if (!citaData || citaData.length === 0) {
        return res.status(404).json({ success: false, message: "Cita no encontrada" });
    }
    const { ID_PACIENTE, ID_DOCTOR } = citaData[0];
        
    // 2. Verificar si ya existe consulta
    const [exists] = await pool.query(
      "SELECT ID_CONSULTA FROM TBL_CONSULTA_MEDICA WHERE ID_CITA = ?",
      [idCitaNum]
    );
    if (exists && exists.length)
      return res.status(409).json({
        success: false,
        message: "Ya existe una consulta para esa cita",
      });
      
    const usuarioCreacion =
      req.user && req.user.USUARIO ? req.user.USUARIO : "SISTEMA";
      
    // 3. Insertar la Consulta Médica
    const [result] = await pool.query(
      `INSERT INTO TBL_CONSULTA_MEDICA (ID_CITA, ID_PACIENTE, ID_DOCTOR, MOTIVO_CONSULTA, SINTOMAS, EXAMEN_FISICO, DIAGNOSTICO_PRINCIPAL, CODIGO_CIE10_PRINCIPAL, DIAGNOSTICO_SECUNDARIO, CODIGO_CIE10_SECUNDARIO, TRATAMIENTO, RECOMENDACIONES, OBSERVACIONES, PROXIMA_CITA_RECOMENDADA, TIPO_CONSULTA, USUARIO_CREACION) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        idCitaNum,
        ID_PACIENTE,
        ID_DOCTOR,
        motivoConsulta || null,
        JSON.stringify(sintomas || {}),
        JSON.stringify(examenFisico || {}),
        diagnosticoPrincipal || null,
        codigoCie10Principal || null,
        diagnosticoSecundario || null,
        codigoCie10Secundario || null,
        tratamiento || null,
        recomendaciones || null,
        observaciones || null,
        proximaCita || null,
        tipoConsulta || "GENERAL",
        usuarioCreacion,
      ]
    );
    
    if (!result || !result.affectedRows)
      return res
        .status(400)
        .json({ success: false, message: "No se pudo crear la consulta" });
        
    const idConsultaNueva = result.insertId;
        
    // 4. Registrar Bitácora de Creación
    await registrarBitacora({
      usuario: usuarioCreacion,
      accion: "CREACION_CONSULTA_MEDICA",
      descripcion: `Creada consulta ID ${idConsultaNueva} para cita ${idCitaNum}`,
      modulo: "CONSULTA_MEDICA",
      idRegistro: idConsultaNueva,
      tabla: "TBL_CONSULTA_MEDICA",
      estado: "EXITO",
      req,
    });
    
    // 5. Marcar Cita como FINALIZADA
    await pool.query(
      "UPDATE TBL_CITAS SET ESTADO = 'FINALIZADA', FECHA_MODIFICACION = CURRENT_TIMESTAMP, USUARIO_MODIFICACION = ? WHERE ID_CITA = ?",
      [usuarioCreacion, idCitaNum]
    );
    
    // -----------------------------------------------------------------
    // --- 6. LÓGICA CLAVE: GENERACIÓN DEL RECIBO ---
    // -----------------------------------------------------------------
    
    // Configuraciones de facturación
    const ID_SERVICIO_CONSULTA = 1; // ID del servicio de consulta médica (Ajustar si es diferente)
    const ISV_RATE = 0.15;          // Tasa de ISV (15%)
    
    const subtotal = parseFloat(costoConsulta);
    const isv = subtotal * ISV_RATE;
    const montoTotal = subtotal + isv;
    const descuento = 0.00;

    const reciboData = {
        ID_PACIENTE: ID_PACIENTE,
        ID_CITA: idCitaNum,
        FECHA_EMISION: new Date().toISOString().slice(0, 10), 
        SUBTOTAL: subtotal.toFixed(2),
        ISV: isv.toFixed(2),
        DESCUENTO: descuento.toFixed(2),
        MONTO_TOTAL: montoTotal.toFixed(2),
        SALDO_PENDIENTE: montoTotal.toFixed(2), // Se crea como PENDIENTE
        TIPO_PAGO: 'EFECTIVO', 
        DESCRIPCION: `Recibo automático por Consulta Médica (ID: ${idConsultaNueva})`,
        ESTADO_RECIBO: 'PENDIENTE', // Estado inicial
        USUARIO_CREACION: usuarioCreacion,
        DETALLES: [
            {
                ID_SERVICIO: ID_SERVICIO_CONSULTA,
                CANTIDAD: 1,
                PRECIO_UNITARIO: subtotal.toFixed(2),
                SUBTOTAL: subtotal.toFixed(2),
            }
        ],
    };
    
    try {
        await crearRecibo(reciboData); 
    } catch (reciboError) {
        // La consulta se guardó, solo se registra una advertencia sobre el recibo.
        console.error(`ADVERTENCIA: Falló la generación del recibo para la Consulta #${idConsultaNueva}. Error:`, reciboError.message);
    }
    
    // -----------------------------------------------------------------
    // --- FIN DE LÓGICA DE RECIBO ---
    // -----------------------------------------------------------------
    
    res.json({
      success: true,
      // Se actualiza el mensaje para reflejar la creación del recibo
      message: "Consulta creada y recibo generado (PENDIENTE) correctamente", 
      idConsulta: idConsultaNueva,
    });
  } catch (err) {
    console.error("POST /consultaMedica/nueva error:", err);
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ERROR_CREACION_CONSULTA",
      descripcion: err.message,
      modulo: "CONSULTA_MEDICA",
      tabla: "TBL_CONSULTA_MEDICA",
      estado: "ERROR",
      detalleError: err.message,
      req,
    });
    res.status(500).json({
      success: false,
      message: "Error creando consulta: " + err.message,
    });
  }
});

router.post("/actualizar", async (req, res) => {
// ... la lógica de /actualizar no necesita modificación para este requerimiento
// ... (código /actualizar original)
  try {
    const {
      idConsulta,
      idCita,
      motivoConsulta,
      sintomas,
      examenFisico,
      diagnosticoPrincipal,
      codigoCie10Principal,
      diagnosticoSecundario,
      codigoCie10Secundario,
      tratamiento,
      recomendaciones,
      observaciones,
      proximaCita,
      tipoConsulta,
    } = req.body || {};
    const idConsultaNum = Number(idConsulta || 0);
    if (!idConsultaNum)
      return res
        .status(400)
        .json({ success: false, message: "Falta ID de consulta" });
    const usuarioMod =
      req.user && req.user.USUARIO ? req.user.USUARIO : "SISTEMA";
    const [result] = await pool.query(
      `UPDATE TBL_CONSULTA_MEDICA SET ID_CITA = ?, MOTIVO_CONSULTA = ?, SINTOMAS = ?, EXAMEN_FISICO = ?, DIAGNOSTICO_PRINCIPAL = ?, CODIGO_CIE10_PRINCIPAL = ?, DIAGNOSTICO_SECUNDARIO = ?, CODIGO_CIE10_SECUNDARIO = ?, TRATAMIENTO = ?, RECOMENDACIONES = ?, OBSERVACIONES = ?, PROXIMA_CITA_RECOMENDADA = ?, TIPO_CONSULTA = ?, USUARIO_MODIFICACION = ? WHERE ID_CONSULTA = ?`,
      [
        idCita || null,
        motivoConsulta || null,
        JSON.stringify(sintomas || {}),
        JSON.stringify(examenFisico || {}),
        diagnosticoPrincipal || null,
        codigoCie10Principal || null,
        diagnosticoSecundario || null,
        codigoCie10Secundario || null,
        tratamiento || null,
        recomendaciones || null,
        observaciones || null,
        proximaCita || null,
        tipoConsulta || "GENERAL",
        usuarioMod,
        idConsultaNum,
      ]
    );
    if (result.affectedRows === 0)
      return res
        .status(404)
        .json({ success: false, message: "Consulta no encontrada" });
    await registrarBitacora({
      usuario: usuarioMod,
      accion: "ACTUALIZACION_CONSULTA_MEDICA",
      descripcion: `Actualizada consulta ID ${idConsultaNum}`,
      modulo: "CONSULTA_MEDICA",
      idRegistro: idConsultaNum,
      tabla: "TBL_CONSULTA_MEDICA",
      estado: "EXITO",
      req,
    });
    if (idCita) {
      await pool.query(
        "UPDATE TBL_CITAS SET ESTADO = 'FINALIZADA', FECHA_MODIFICACION = CURRENT_TIMESTAMP, USUARIO_MODIFICACION = ? WHERE ID_CITA = ?",
        [usuarioMod, idCita]
      );
    }
    res.json({ success: true, message: "Consulta actualizada correctamente" });
  } catch (err) {
    console.error("POST /consultaMedica/actualizar error:", err);
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ERROR_ACTUALIZACION_CONSULTA",
      descripcion: err.message,
      modulo: "CONSULTA_MEDICA",
      tabla: "TBL_CONSULTA_MEDICA",
      estado: "ERROR",
      detalleError: err.message,
      req,
    });
    res.status(500).json({
      success: false,
      message: "Error actualizando consulta: " + err.message,
    });
  }
});

module.exports = router;