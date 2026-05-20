const express = require("express");
const router = express.Router();
const pool = require("../database/db");
const { registrarBitacora } = require("../services/bitacora.service");

router.use(express.json());
router.use((req, res, next) => {
  try {
    if (req.body && typeof req.body === "object") {
      delete req.body.IMC;
      delete req.body.imc;
    }
  } catch (e) {
    console.warn("preclinica.routes sanitizar body fallo:", e);
  }
  next();
});

function tieneInfoMinima(pre) {
  const peso = Number(pre?.PESO ?? pre?.peso ?? 0);
  const talla = Number(pre?.TALLA ?? pre?.talla ?? 0);
  return peso > 0 && talla > 0;
}

router.get("/", async (req, res) => {
  try {
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ACCESO_PRECLINICA",
      descripcion: "Acceso a la vista de preclínica",
      modulo: "PRECLINICA",
      tabla: "TBL_PRECLINICA",
      estado: "EXITO",
      req,
    });
    res.render("preclinica", { title: "Preclínica - Roca Maya" });
  } catch (err) {
    console.error("GET /preclinica error:", err);
    res.status(500).send("Error interno");
  }
});

// API: devolver solo citas en PRECLINICA o CANCELADA o NO_ASISTIO
router.get("/api/datos", async (req, res) => {
  try {
    const [citas] = await pool.query(`
      SELECT c.ID_CITA,
             CONCAT(p.NOMBRES,' ',p.APELLIDOS) AS NOMBRE_PACIENTE,
             p.TELEFONO, p.CORREO_ELECTRONICO,
             u.NOMBRE_USUARIO AS NOMBRE_DOCTOR,
             c.FECHA_CITA, c.ESTADO
      FROM TBL_CITAS c
      INNER JOIN TBL_PACIENTE p ON c.ID_PACIENTE = p.ID_PACIENTE
      LEFT JOIN TBL_MS_USUARIO u ON c.ID_DOCTOR = u.ID_USUARIO
      WHERE c.ESTADO IN ('PRECLINICA', 'CANCELADA', 'NO_ASISTIO')
      ORDER BY c.FECHA_CITA DESC
    `);

    const [preclinicas] = await pool.query(`
      SELECT ID_PRECLINICA, ID_CITA, PESO, TALLA, TEMPERATURA, ESTADO_GENERAL, FECHA_REGISTRO, OBSERVACIONES,
             PRESION_SISTOLICA, PRESION_DIASTOLICA, FRECUENCIA_CARDIACA, FRECUENCIA_RESPIRATORIA, SATURACION_OXIGENO, GLUCOSA, PERIMETRO_ABDOMINAL, SIGNOS_VITALES_JSON
      FROM TBL_PRECLINICA
    `);

    res.json({ citas, preclinicas });
  } catch (err) {
    console.error("GET /preclinica/api/datos error:", err);
    res.status(500).json({ citas: [], preclinicas: [], error: err.message });
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
      `SELECT * FROM TBL_PRECLINICA WHERE ID_CITA = ? LIMIT 1`,
      [id]
    );
    if (!rows || rows.length === 0)
      return res.status(404).json({
        success: false,
        message: "No existe preclínica para esa cita",
      });

    const p = rows[0];
    try {
      if (p.SIGNOS_VITALES_JSON && typeof p.SIGNOS_VITALES_JSON === "string")
        p.SIGNOS_VITALES_JSON = JSON.parse(p.SIGNOS_VITALES_JSON);
    } catch (e) {}
    res.json({ success: true, preclinica: p });
  } catch (err) {
    console.error("GET /preclinica/por-cita error:", err);
    res.status(500).json({ success: false, message: err.message });
  }
});

router.post("/nueva", async (req, res) => {
  try {
    const {
      idCita,
      temperatura,
      presionSistolica,
      presionDiastolica,
      frecuenciaCardiaca,
      frecuenciaRespiratoria,
      saturacionOxigeno,
      peso,
      talla,
      glucosa,
      perimetroAbdominal,
      observaciones,
      estadoGeneral,
      signosVitalesJson,
    } = req.body;
    const idCitaNum = Number(idCita || 0);
    if (!idCitaNum)
      return res
        .status(400)
        .json({ success: false, message: "Falta ID de cita" });

    const [exists] = await pool.query(
      `SELECT ID_PRECLINICA FROM TBL_PRECLINICA WHERE ID_CITA = ?`,
      [idCitaNum]
    );
    if (exists && exists.length > 0)
      return res.status(409).json({
        success: false,
        message: "Ya existe una preclínica asociada a esa cita",
      });

    const usuarioCreacion =
      req.user && req.user.USUARIO ? req.user.USUARIO : "SISTEMA";
    const signosJsonStr =
      typeof signosVitalesJson === "string"
        ? signosVitalesJson
        : JSON.stringify(signosVitalesJson || {});

    const [result] = await pool.query(
      `INSERT INTO TBL_PRECLINICA (
         ID_CITA, ID_USUARIO_ENFERMERIA, TEMPERATURA, PRESION_SISTOLICA, PRESION_DIASTOLICA,
         FRECUENCIA_CARDIACA, FRECUENCIA_RESPIRATORIA, SATURACION_OXIGENO,
         PESO, TALLA, GLUCOSA, PERIMETRO_ABDOMINAL, OBSERVACIONES, ESTADO_GENERAL, SIGNOS_VITALES_JSON, USUARIO_CREACION
       ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        idCitaNum,
        req.user && req.user.ID_USUARIO ? req.user.ID_USUARIO : 1,
        temperatura || null,
        presionSistolica || null,
        presionDiastolica || null,
        frecuenciaCardiaca || null,
        frecuenciaRespiratoria || null,
        saturacionOxigeno || null,
        peso || null,
        talla || null,
        glucosa || null,
        perimetroAbdominal || null,
        observaciones || null,
        estadoGeneral || "BUENO",
        signosJsonStr,
        usuarioCreacion,
      ]
    );

    if (!result || !result.affectedRows)
      return res
        .status(400)
        .json({ success: false, message: "No se pudo crear la preclínica" });
    const idPre = result.insertId;

    await registrarBitacora({
      usuario: usuarioCreacion,
      accion: "CREACION_PRECLINICA",
      descripcion: `Creada preclínica ID ${idPre} para cita ${idCitaNum}`,
      modulo: "PRECLINICA",
      idRegistro: idPre,
      tabla: "TBL_PRECLINICA",
      estado: "EXITO",
      req,
    });

    // Si tiene peso+talla actualizar cita a CONSULTA_MEDICA (flujo normal)
    if (tieneInfoMinima({ PESO: peso, TALLA: talla })) {
      await pool.query(
        `UPDATE TBL_CITAS SET ESTADO='CONSULTA_MEDICA', FECHA_MODIFICACION=CURRENT_TIMESTAMP, USUARIO_MODIFICACION=? WHERE ID_CITA = ?`,
        [usuarioCreacion, idCitaNum]
      );
      await registrarBitacora({
        usuario: usuarioCreacion,
        accion: "CAMBIO_ESTADO_CITA_POR_PRECLINICA",
        descripcion: `Cita ${idCitaNum} -> CONSULTA_MEDICA tras crear preclínica ${idPre}`,
        modulo: "CITAS",
        idRegistro: idCitaNum,
        tabla: "TBL_CITAS",
        estado: "EXITO",
        req,
      });
    }

    res.json({
      success: true,
      message: "Preclínica creada correctamente",
      idPreclinica: idPre,
      nota_estado_actualizado: (tieneInfoMinima({ PESO: peso, TALLA: talla }) ? 'CONSULTA_MEDICA' : 'PRECLINICA')
    });
  } catch (err) {
    console.error("POST /preclinica/nueva error:", err);
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ERROR_CREACION_PRECLINICA",
      descripcion: err.message,
      modulo: "PRECLINICA",
      tabla: "TBL_PRECLINICA",
      estado: "ERROR",
      detalleError: err.message,
      req,
    });
    res.status(500).json({
      success: false,
      message: "Error creando preclínica: " + err.message,
    });
  }
});

router.post("/actualizar", async (req, res) => {
  try {
    const {
      idPreclinica,
      idCita,
      temperatura,
      presionSistolica,
      presionDiastolica,
      frecuenciaCardiaca,
      frecuenciaRespiratoria,
      saturacionOxigeno,
      peso,
      talla,
      glucosa,
      perimetroAbdominal,
      observaciones,
      estadoGeneral,
      signosVitalesJson,
    } = req.body;

    const idPre = Number(idPreclinica || 0);
    if (!idPre)
      return res
        .status(400)
        .json({ success: false, message: "Falta ID preclínica" });

    const usuarioMod =
      req.user && req.user.USUARIO ? req.user.USUARIO : "SISTEMA";
    const signosJsonStr =
      typeof signosVitalesJson === "string"
        ? signosVitalesJson
        : JSON.stringify(signosVitalesJson || {});

    const [result] = await pool.query(
      `UPDATE TBL_PRECLINICA SET TEMPERATURA=?, PRESION_SISTOLICA=?, PRESION_DIASTOLICA=?, FRECUENCIA_CARDIACA=?, FRECUENCIA_RESPIRATORIA=?, SATURACION_OXIGENO=?, PESO=?, TALLA=?, GLUCOSA=?, PERIMETRO_ABDOMINAL=?, OBSERVACIONES=?, ESTADO_GENERAL=?, SIGNOS_VITALES_JSON=?, USUARIO_MODIFICACION=? WHERE ID_PRECLINICA = ?`,
      [
        temperatura || null,
        presionSistolica || null,
        presionDiastolica || null,
        frecuenciaCardiaca || null,
        frecuenciaRespiratoria || null,
        saturacionOxigeno || null,
        peso || null,
        talla || null,
        glucosa || null,
        perimetroAbdominal || null,
        observaciones || null,
        estadoGeneral || "BUENO",
        signosJsonStr,
        usuarioMod,
        idPre,
      ]
    );

    if (result.affectedRows === 0)
      return res
        .status(404)
        .json({ success: false, message: "Preclínica no encontrada" });

    if (idCita && Number(peso || 0) > 0 && Number(talla || 0) > 0) {
      await pool.query(
        `UPDATE TBL_CITAS SET ESTADO='CONSULTA_MEDICA', FECHA_MODIFICACION=CURRENT_TIMESTAMP, USUARIO_MODIFICACION=? WHERE ID_CITA = ?`,
        [usuarioMod, idCita]
      );
      await registrarBitacora({
        usuario: usuarioMod,
        accion: "CAMBIO_ESTADO_CITA_POR_PRECLINICA_UPDATE",
        descripcion: `Cita ${idCita} -> CONSULTA_MEDICA tras actualizar preclínica ${idPre}`,
        modulo: "CITAS",
        idRegistro: idCita,
        tabla: "TBL_CITAS",
        estado: "EXITO",
        req,
      });
    }

    await registrarBitacora({
      usuario: usuarioMod,
      accion: "ACTUALIZACION_PRECLINICA",
      descripcion: `Actualizada preclínica ID ${idPre}`,
      modulo: "PRECLINICA",
      idRegistro: idPre,
      tabla: "TBL_PRECLINICA",
      estado: "EXITO",
      req,
    });

    res.json({
      success: true,
      message: "Preclínica actualizada correctamente",
    });
  } catch (err) {
    console.error("POST /preclinica/actualizar error:", err);
    await registrarBitacora({
      usuario: req.user ? req.user.USUARIO : "SISTEMA",
      accion: "ERROR_ACTUALIZACION_PRECLINICA",
      descripcion: err.message,
      modulo: "PRECLINICA",
      tabla: "TBL_PRECLINICA",
      estado: "ERROR",
      detalleError: err.message,
      req,
    });
    res.status(500).json({
      success: false,
      message: "Error actualizando preclínica: " + err.message,
    });
  }
});

// pasar-a-consulta (valida peso/talla) sigue igual
router.post("/pasar-a-consulta", async (req, res) => {
  try {
    const { idCita } = req.body;
    const id = Number(idCita || 0);
    if (!id)
      return res
        .status(400)
        .json({ success: false, message: "ID de cita inválido" });

    const [rows] = await pool.query(
      `SELECT PESO, TALLA FROM TBL_PRECLINICA WHERE ID_CITA = ? LIMIT 1`,
      [id]
    );
    if (!rows || rows.length === 0)
      return res.status(404).json({
        success: false,
        message: "No existe preclínica para esta cita",
      });

    const rec = rows[0];
    const peso = Number(rec.PESO || 0);
    const talla = Number(rec.TALLA || 0);
    if (!(peso > 0 && talla > 0)) {
      return res.status(400).json({
        success: false,
        message:
          "La preclínica no contiene la información mínima (peso/talla). Complete la preclínica antes de pasar a consulta.",
      });
    }

    const usuario = req.user && req.user.USUARIO ? req.user.USUARIO : "SISTEMA";
    await pool.query(
      `UPDATE TBL_CITAS SET ESTADO='CONSULTA_MEDICA', FECHA_MODIFICACION=CURRENT_TIMESTAMP, USUARIO_MODIFICACION = ? WHERE ID_CITA = ?`,
      [usuario, id]
    );
    await registrarBitacora({
      usuario,
      accion: "PASAR_PRECLINICA_A_CONSULTA",
      descripcion: `Cita ${id} pasada a CONSULTA_MEDICA (verificada preclínica con peso/talla)`,
      modulo: "CITAS",
      idRegistro: id,
      tabla: "TBL_CITAS",
      estado: "EXITO",
      req,
    });

    res.json({ success: true, message: "Cita pasada a CONSULTA_MEDICA" });
  } catch (err) {
    console.error("POST /preclinica/pasar-a-consulta error:", err);
    res.status(500).json({ success: false, message: "Error: " + err.message });
  }
});

module.exports = router;