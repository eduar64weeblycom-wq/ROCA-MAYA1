const express = require("express");
const router = express.Router();
const db = require('../database/db');

// Ruta del dashboard principal después del login
router.get("/", (req, res) => {
    res.render("dashboard", {
        title: "Dashboard Principal",
        user: req.user || { username: "Usuario" }
    });
});

// Ruta de bienvenida (a la que redirige tu auth.routes.js)
router.get("/dashboard", (req, res) => {
    res.render("dashboard", {
        title: "Bienvenido",
        user: req.user || { username: "Usuario" }
    });
});

// Obtener estadísticas del dashboard
router.get('/stats', async (req, res) => {
  try {
    console.log('Solicitando estadísticas del dashboard...');

    // Consulta para pacientes activos
    const pacientesQuery = `
      SELECT COUNT(*) as total 
      FROM TBL_PACIENTE 
      WHERE ESTADO = 'ACTIVO'
    `;

    // Consulta para citas de hoy
    const citasQuery = `
      SELECT COUNT(*) as total 
      FROM TBL_CITAS 
      WHERE DATE(FECHA_CITA) = CURDATE() 
      AND ESTADO IN ('PROGRAMADA','CONFIRMADA','PRECLINICA')
    `;

    // Consulta para consultas de hoy
    const consultasQuery = `
      SELECT COUNT(*) as total 
      FROM TBL_CONSULTA_MEDICA 
      WHERE DATE(FECHA_CONSULTA) = CURDATE()
    `;

    // Consulta para medicamentos activos
    const medicamentosQuery = `
      SELECT COUNT(*) as total 
      FROM TBL_INVENTARIO_MEDICAMENTO 
      WHERE ESTADO = 'ACTIVO' 
      AND STOCK_ACTUAL > 0 
      AND FECHA_VENCIMIENTO > CURDATE()
    `;

    // Ejecutar todas las consultas en paralelo
    const [
      pacientesResult,
      citasResult,
      consultasResult,
      medicamentosResult
    ] = await Promise.all([
      db.query(pacientesQuery),
      db.query(citasQuery),
      db.query(consultasQuery),
      db.query(medicamentosQuery)
    ]);

    console.log('Resultados de consultas:', {
      pacientes: pacientesResult,
      citas: citasResult,
      consultas: consultasResult,
      medicamentos: medicamentosResult
    });

    const stats = {
      pacientesActivos: pacientesResult[0][0]?.total || 0,
      citasHoy: citasResult[0][0]?.total || 0,
      consultasHoy: consultasResult[0][0]?.total || 0,
      medicamentosActivos: medicamentosResult[0][0]?.total || 0
    };

    console.log('Estadísticas procesadas:', stats);
    
    res.json(stats);
  } catch (error) {
    console.error('Error fetching dashboard stats:', error);
    res.status(500).json({ 
      error: 'Error al cargar las estadísticas',
      detalles: error.message 
    });
  }
});

// Función auxiliar para extraer el total de diferentes formatos de respuesta
function extractTotal(result) {
  if (!result) return 0;
  
  // Si es un array con resultados
  if (Array.isArray(result)) {
    // Si el primer elemento es un array (mysql2/promise)
    if (Array.isArray(result[0]) && result[0].length > 0) {
      return result[0][0].total || 0;
    }
    // Si el primer elemento es un objeto (mysql tradicional)
    else if (result.length > 0 && typeof result[0] === 'object') {
      return result[0].total || 0;
    }
  }
  // Si es un objeto directamente
  else if (typeof result === 'object' && result.total !== undefined) {
    return result.total;
  }
  
  return 0;
}

module.exports = router;