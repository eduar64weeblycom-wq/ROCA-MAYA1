const express = require('express');
const router = express.Router();
const db = require('../database/db');

// 🔹 Mostrar la vista de historial médico con los pacientes activos
router.get("/", async (req, res) => {
  try {
    const [pacientes] = await db.query(`
      SELECT ID_PACIENTE, NOMBRES, APELLIDOS
      FROM TBL_PACIENTE
      WHERE ESTADO = 'ACTIVO'
      ORDER BY NOMBRES
    `);

    // Renderiza la vista enviando las variables necesarias
    res.render("historial-medico", {
      pacientes: pacientes || [], // Asegurar que siempre sea un array
      pacienteSeleccionado: null,
      historial: null
    });
  } catch (err) {
    console.error("❌ Error al obtener pacientes:", err);
    res.render("historial-medico", {
      pacientes: [], // Array vacío en caso de error
      pacienteSeleccionado: null,
      historial: null
    });
  }
});

// 🔹 API: Obtener pacientes activos (para AJAX)
router.get("/pacientes", async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT ID_PACIENTE, NOMBRES, APELLIDOS 
      FROM TBL_PACIENTE 
      WHERE ESTADO = 'ACTIVO'
      ORDER BY NOMBRES
    `);
    res.json(rows || []);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al obtener pacientes" });
  }
});

// 🔹 Obtener historial médico + datos del paciente
router.get("/:pacienteId", async (req, res) => {
  const { pacienteId } = req.params;
  try {
    const [pacienteRows] = await db.query(`
      SELECT * FROM TBL_PACIENTE WHERE ID_PACIENTE = ?
    `, [pacienteId]);

    if (pacienteRows.length === 0) {
      return res.status(404).json({ error: "Paciente no encontrado" });
    }

    const [historialRows] = await db.query(`
      SELECT * FROM TBL_HISTORIAL_MEDICO WHERE ID_PACIENTE = ?
    `, [pacienteId]);

    res.json({
      paciente: pacienteRows[0],
      historial: historialRows[0] || null
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al obtener historial" });
  }
});

// 🔹 Crear o actualizar historial médico (guardar)
router.post("/:pacienteId", async (req, res) => {
  const { pacienteId } = req.params;
  const datos = req.body;

  try {
    const [existe] = await db.query(
      "SELECT * FROM TBL_HISTORIAL_MEDICO WHERE ID_PACIENTE = ?",
      [pacienteId]
    );

    if (existe.length > 0) {
      // Actualizar historial existente
      await db.query(`
        UPDATE TBL_HISTORIAL_MEDICO SET
          ALERGIAS = ?,
          ENFERMEDADES_CRONICAS = ?,
          CIRUGIAS_PREVIAS = ?,
          MEDICAMENTOS_ACTUALES = ?,
          ANTECEDENTES_FAMILIARES = ?,
          HABITOS = ?,
          VACUNAS = ?,
          NOTAS_IMPORTANTES = ?,
          USUARIO_MODIFICACION = ?
        WHERE ID_PACIENTE = ?
      `, [
        JSON.stringify(datos.ALERGIAS || []),
        JSON.stringify(datos.ENFERMEDADES_CRONICAS || []),
        JSON.stringify(datos.CIRUGIAS_PREVIAS || []),
        JSON.stringify(datos.MEDICAMENTOS_ACTUALES || []),
        JSON.stringify(datos.ANTECEDENTES_FAMILIARES || []),
        JSON.stringify(datos.HABITOS || []),
        JSON.stringify(datos.VACUNAS || []),
        datos.NOTAS_IMPORTANTES || '',
        datos.USUARIO_MODIFICACION || 'admin',
        pacienteId
      ]);

      res.json({ message: "Historial actualizado correctamente" });
    } else {
      // Crear nuevo historial
      await db.query(`
        INSERT INTO TBL_HISTORIAL_MEDICO 
        (ID_PACIENTE, ALERGIAS, ENFERMEDADES_CRONICAS, CIRUGIAS_PREVIAS, MEDICAMENTOS_ACTUALES, 
         ANTECEDENTES_FAMILIARES, HABITOS, VACUNAS, NOTAS_IMPORTANTES, USUARIO_CREACION)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        pacienteId,
        JSON.stringify(datos.ALERGIAS || []),
        JSON.stringify(datos.ENFERMEDADES_CRONICAS || []),
        JSON.stringify(datos.CIRUGIAS_PREVIAS || []),
        JSON.stringify(datos.MEDICAMENTOS_ACTUALES || []),
        JSON.stringify(datos.ANTECEDENTES_FAMILIARES || []),
        JSON.stringify(datos.HABITOS || []),
        JSON.stringify(datos.VACUNAS || []),
        datos.NOTAS_IMPORTANTES || '',
        datos.USUARIO_CREACION || 'admin'
      ]);

      res.json({ message: "Historial creado correctamente" });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Error al guardar historial" });
  }
});

module.exports = router;