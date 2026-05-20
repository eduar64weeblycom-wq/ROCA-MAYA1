const express = require("express");
const router = express.Router();
// Se necesita el middleware para simular PUT/DELETE en formularios HTML
const methodOverride = require('method-override');

const {
  obtenerRecibos,
  crearRecibo,
  obtenerReciboPorId,
  obtenerDatosPaciente, 
  actualizarEstadoRecibo, 
  obtenerDatosCita,
  // Importar nueva función
  obtenerServicios, 
} = require("../services/recibos.service"); 

// Usar method-override para simular PUT/DELETE (Debe instalar esta dependencia: npm install method-override)
router.use(methodOverride('_method'));


router.get("/", async (req, res, next) => {
  try {
    const filters = {
        // CAMBIO 1: El estado por defecto ahora es "" (vacío) para traer TODOS los recibos (Historial)
        estado: req.query.estado || "", 
        numero: req.query.numero || "",
        success: req.query.success,
        error: req.query.error
    };
    
    const recibos = await obtenerRecibos(filters);
    
    res.render("recibos", { 
      recibos,
      // CAMBIO 1: Título actualizado a "Historial de Recibos"
      titulo: "Historial de Recibos", 
      filters: filters,
      success: filters.success, 
      error: filters.error,
    });
  } catch (err) {
    next(err);
  }
});


// RUTA GET /nuevo (MODIFICADA para obtener servicios)
router.get("/nuevo", async (req, res, next) => { 
  try {
    const servicios = await obtenerServicios(); 

    res.render("recibo_nuevo", { 
        titulo: "Crear Nuevo Recibo",
        error: req.query.error || null,
        // Pasar servicios al template
        servicios: servicios, 
    }); 
  } catch (err) {
    next(err);
  }
});

// RUTA POST / (Crear Recibo y sus Detalles)
router.post("/", async (req, res, next) => {
  try {
    const { 
        ID_CITA, 
        ID_PACIENTE, 
        SUBTOTAL, 
        DESCUENTO, 
        ISV, 
        MONTO_TOTAL,
        ESTADO_RECIBO_ACTION, // 'PENDIENTE' o 'PAGADA'
        DETALLES_JSON // Array de servicios seleccionados
    } = req.body;
    
    // Validaciones básicas
    if (!ID_PACIENTE) {
        throw new Error("El ID de Paciente es obligatorio.");
    }
    const montoTotal = parseFloat(MONTO_TOTAL) || 0;
    if (montoTotal <= 0) {
        throw new Error("El Monto Total debe ser mayor a cero.");
    }
    
    // Parsear detalles
    const detalles = JSON.parse(DETALLES_JSON);
    if (!detalles || detalles.length === 0) {
        throw new Error("Debe agregar al menos un servicio al recibo.");
    }

    const data = {
        ID_CITA: ID_CITA && ID_CITA.trim() !== '' ? ID_CITA : null, 
        ID_PACIENTE: ID_PACIENTE,
        SUBTOTAL: parseFloat(SUBTOTAL),
        DESCUENTO: parseFloat(DESCUENTO),
        ISV: parseFloat(ISV),
        MONTO_TOTAL: montoTotal,
        SALDO_PENDIENTE: ESTADO_RECIBO_ACTION === 'PAGADA' ? 0.00 : montoTotal,
        ESTADO_RECIBO: ESTADO_RECIBO_ACTION,
        DETALLES: detalles,
    };

    const newRecibo = await crearRecibo(data);

    const successMessage = encodeURIComponent(`Recibo #${newRecibo.NUMERO_RECIBO || newRecibo.ID_RECIBO} creado exitosamente y marcado como ${data.ESTADO_RECIBO}.`);

    res.redirect(`/recibos/${newRecibo.ID_RECIBO}?success=${successMessage}`);
  } catch (err) {
    console.error("Error al crear recibo:", err);
    const errorMessage = encodeURIComponent(err.message.replace('ERROR: ', ''));
    // Volver a /nuevo y pasar la cita para que no se pierda el contexto
    res.redirect(`/recibos/nuevo?error=${errorMessage}&ID_CITA=${req.body.ID_CITA || ''}`);
  }
});


router.get("/:id", async (req, res, next) => {
  try {
    const recibo = await obtenerReciboPorId(req.params.id); 
    if (!recibo) {
      res.status(404).render("error", { titulo: "Error 404", message: "Recibo no encontrado." });
      return;
    }

    res.render("recibo_detalle", { 
      recibo,
      titulo: `Detalle Recibo #${recibo.NUMERO_RECIBO}`,
      success: req.query.success, 
      error: req.query.error,
    });
  } catch (err) {
    next(err);
  }
});

// RUTA PARA ACTUALIZAR ESTADO (Pagar, Anular)
router.put("/status/:id", async (req, res, next) => {
    const idRecibo = req.params.id;
    const { newStatus, montoTotalToRestore, original_query } = req.body; 

    try {
        await actualizarEstadoRecibo(idRecibo, newStatus, montoTotalToRestore);

        const statusText = newStatus === 'PAGADA' ? 'PAGADO' : newStatus;
        const successMessage = encodeURIComponent(`Recibo ID ${idRecibo} actualizado a estado ${statusText} exitosamente.`);
        
        // CAMBIO 2: Si viene de la lista, redirige a /recibos (historial), no solo a PENDIENTE
        const redirectUrl = original_query === 'list' 
            ? `/recibos?success=${successMessage}` 
            : `/recibos/${idRecibo}?success=${successMessage}`; 

        res.redirect(redirectUrl);

    } catch (err) {
        console.error(`Error al cambiar el estado del recibo ${idRecibo}:`, err.message);
        
        const errorMessage = encodeURIComponent(err.message.replace('ERROR: ', ''));
        
        // CAMBIO 2: Redirige a /recibos (historial) en caso de error en la lista
        const redirectUrl = original_query === 'list' 
            ? `/recibos?error=${errorMessage}` 
            : `/recibos/${idRecibo}?error=${errorMessage}`;
            
        res.redirect(redirectUrl);
    }
});


// Rutas de API para autocompletar (Se mantienen)
router.get("/paciente/:id", async (req, res, next) => {
  try {
    const paciente = await obtenerDatosPaciente(req.params.id);
    if (!paciente) {
      res.status(404).json({ message: "Paciente no encontrado" });
      return;
    }
    res.json({
        ID_PACIENTE: paciente.ID_PACIENTE,
        NOMBRE_COMPLETO: paciente.NOMBRE_COMPLETO,
        RTN_PACIENTE: paciente.RTN_PACIENTE,
    });
  } catch (err) {
    next(err);
  }
});


router.get("/cita/:id", async (req, res, next) => {
  try {
    const citaData = await obtenerDatosCita(req.params.id);
    if (!citaData) {
        res.status(404).json({ message: 'Cita médica no encontrada.' });
        return;
    }
    res.json(citaData);
  } catch (err) {
    next(err);
  }
});

module.exports = router;