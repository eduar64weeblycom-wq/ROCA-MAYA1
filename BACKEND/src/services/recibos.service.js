const Recibo = require("../models/recibo.model"); 

async function obtenerRecibos(filters = {}) {
  return await Recibo.getAll(filters);
}

async function obtenerReciboPorId(id) {
  return await Recibo.getById(id);
}

async function crearRecibo(data) {
 
  if (data.ID_PACIENTE === undefined || data.MONTO_TOTAL === undefined) {
      throw new Error("ERROR: Faltan campos requeridos (ID de Paciente, MONTO_TOTAL).");
  }

  // Validar detalles
  if (!data.DETALLES || data.DETALLES.length === 0) {
      throw new Error("ERROR: Debe haber al menos un detalle de servicio.");
  }
  
  return await Recibo.create(data);
}

async function actualizarEstadoRecibo(id, newStatus, montoTotalToRestore) {
    return await Recibo.updateStatus(id, newStatus, montoTotalToRestore);
}


async function obtenerDatosPaciente(id) {
  return await Recibo.getPatientDataById(id);
}


async function obtenerDatosCita(idCita) {
  return await Recibo.getCitaDataById(idCita);
}

// NUEVA FUNCIÓN: Obtener servicios para la vista de creación
async function obtenerServicios() {
    return await Recibo.getServices();
}

module.exports = {
  obtenerRecibos,
  obtenerReciboPorId,
  crearRecibo,
  actualizarEstadoRecibo, 
  obtenerDatosPaciente, 
  obtenerDatosCita, 
  // Exportar la nueva función
  obtenerServicios,
};