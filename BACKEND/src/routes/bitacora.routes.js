const express = require("express");
const router = express.Router();
const pool = require("../database/db");

// GET /bitacora - Página principal de bitácora
router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT b.FECHA_HORA, u.USUARIO, b.ACCION, b.DESCRIPCION, b.MODULO
      FROM TBL_MS_BITACORA b
      LEFT JOIN TBL_MS_USUARIO u ON b.ID_USUARIO = u.ID_USUARIO
      ORDER BY b.FECHA_HORA DESC LIMIT 50
    `);
    res.render("bitacora", { registros: rows });
  } catch (error) {
    console.error("Error al cargar bitácora:", error);
    res.status(500).send("Error al cargar la bitácora");
  }
});

// Las rutas de parámetros deben estar en su propio archivo
// pero para probar, las ponemos aquí temporalmente

// GET /bitacora/parametros - Página de parámetros
router.get("/parametros", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT ID_PARAMETRO, PARAMETRO, VALOR, DESCRIPCION
      FROM TBL_MS_PARAMETROS
      ORDER BY ID_PARAMETRO
    `);

    console.log("Parámetros encontrados:", rows.length);
    console.log("Primer parámetro:", rows[0]); // Debug
    
    res.render("parametros", { parametros: rows });
  } catch (error) {
    console.error("Error al cargar parámetros:", error);
    res.status(500).send("Error al cargar los parámetros");
  }
});

// POST /bitacora/parametros/guardar
router.post("/parametros/guardar", async (req, res) => {
  try {
    const { parametros } = req.body;

    if (!parametros || !Array.isArray(parametros)) {
      return res.json({ ok: false, mensaje: "Datos inválidos" });
    }

    const promises = parametros.map(p => {
      return pool.query(
        "UPDATE TBL_MS_PARAMETROS SET VALOR = ?, FECHA_MODIFICACION = NOW() WHERE ID_PARAMETRO = ?",
        [p.valor, p.id]
      );
    });

    await Promise.all(promises);
    res.json({ ok: true, mensaje: "Todos los parámetros guardados correctamente" });
    
  } catch (err) {
    console.error("Error guardar parámetros:", err);
    res.json({ ok: false, mensaje: "Error al guardar los parámetros" });
  }
});

// POST /bitacora/parametros/update
router.post("/parametros/update", async (req, res) => {
  try {
    const { id, valor, usuario } = req.body;

    await pool.query(
      `UPDATE TBL_MS_PARAMETROS 
       SET VALOR = ?, FECHA_MODIFICACION = NOW(), USUARIO_MODIFICACION = ? 
       WHERE ID_PARAMETRO = ?`,
      [valor, usuario || 'system', id]
    );

    res.json({ ok: true });
  } catch (error) {
    console.error("Error actualizar parámetro:", error);
    res.json({ ok: false, mensaje: "Error al actualizar el parámetro" });
  }
});

module.exports = router;