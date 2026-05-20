// Variable global para almacenar el ID del paciente, se completa al cargar la cita
let ID_PACIENTE_ACTUAL = null; 
const ISV_RATE = 0.15; // Tasa de Impuesto sobre Ventas

// Elementos del DOM (Definidos aquí para que sean accesibles globalmente si se usa una IIFE o al inicio del script)
const inputCitaId = document.getElementById('cita_id');
const inputPacienteId = document.getElementById('paciente_id');
const infoCitaPaciente = document.getElementById('datos_cita_paciente');
const infoNombrePaciente = document.getElementById('info_nombre_paciente');
const infoRtnPaciente = document.getElementById('info_rtn_paciente');
const infoFechaCita = document.getElementById('info_fecha_cita');
const infoMotivoCita = document.getElementById('info_motivo_cita');

// Lógica de Servicios y Totales (para recibo_nuevo.ejs)
const servicioSelector = document.getElementById('servicio_selector');
const cantidadInput = document.getElementById('cantidad_input');
const btnAddService = document.getElementById('btnAddService');
const detalleBody = document.getElementById('detalleBody');
const noServicesRow = document.getElementById('no-services-row');
const detallesJsonInput = document.getElementById('detalles_json');

const subtotalInputDisplay = document.getElementById('subtotal_input_display');
const subtotalInputHidden = document.getElementById('subtotal_input_hidden');
const descuentoInput = document.getElementById('descuento_input');
const isvInputDisplay = document.getElementById('isv_input_display');
const isvInputHidden = document.getElementById('isv_input_hidden');
const totalInputDisplay = document.getElementById('total_input_display');
const totalInputHidden = document.getElementById('total_input_hidden');
const btnCrearRecibo = document.getElementById('btnCrearRecibo');
const btnCrearYpagar = document.getElementById('btnCrearYpagar');

let detallesRecibo = []; // Almacena los ítems del recibo

/**
 * Convierte una imagen de una URL a una cadena Base64.
 * Esto es crucial para incrustar el logo en documentos de impresión generados en una nueva ventana.
 * @param {string} url - La URL de la imagen.
 * @returns {Promise<string|null>} La cadena Base64 de la imagen o null si falla.
 */
async function imageToBase64(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        const blob = await response.blob();
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onloadend = () => resolve(reader.result);
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    } catch (error) {
        console.error("Error al convertir imagen a Base64:", error);
        return null;
    }
}

/**
 * Genera una nueva ventana con la tabla clonada y estilos para la impresión de Listados.
 * @param {string} logoBase64 - El logo codificado en Base64.
 * @param {string} title - El título del documento de impresión.
 */
function generarVentanaImpresion(logoBase64, title) {
    const tablaOriginal = document.querySelector(".data-table");
    if (!tablaOriginal) return;
    
    const tablaClonada = tablaOriginal.cloneNode(true);
    
    // Ocultar la columna de Acciones si existe en el listado
    const thAcciones = tablaClonada.querySelector("th:last-child");
    const tdAcciones = tablaClonada.querySelectorAll("td:last-child");

    if (thAcciones && thAcciones.textContent.trim() === "Acciones") {
        thAcciones.style.display = 'none'; 
        tdAcciones.forEach(td => td.style.display = 'none'); 
    }

    const ventana = window.open('', '_blank');
    ventana.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>${title || 'Listado de Recibos'}</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 30px; }
                header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
                .logo { height: 50px; }
                h1 { font-size: 1.5em; margin: 0; }
                table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                th { background-color: #f2f2f2; }
                .estado-tag { padding: 4px 8px; border-radius: 5px; font-weight: bold; display: inline-block; }
                .estado-pendiente { background-color: #ffc107; color: #333; }
                .estado-pagada { background-color: #28a745; color: white; }
                .estado-anulada { background-color: #dc3545; color: white; }
            </style>
        </head>
        <body>
            <header>
                <img src="${logoBase64}" alt="Logo" class="logo">
                <h1>${title || 'Listado'}</h1>
                <p>Fecha de Impresión: ${new Date().toLocaleDateString('es-HN')}</p>
            </header>
            ${tablaClonada.outerHTML}
        </body>
        </html>
    `);
    ventana.document.close();
    // Usa un pequeño timeout para asegurar que el contenido se ha renderizado antes de imprimir
    ventana.onload = () => {
        ventana.print();
    };
}


// --- Funciones para la Lógica de Creación de Recibo (recibo_nuevo.ejs) ---

function limpiarCamposCita() {
    ID_PACIENTE_ACTUAL = null;
    if (inputPacienteId) inputPacienteId.value = '';
    if (infoCitaPaciente) infoCitaPaciente.style.display = 'none';
    if (infoNombrePaciente) infoNombrePaciente.textContent = 'N/A';
    if (infoRtnPaciente) infoRtnPaciente.textContent = 'N/A';
    if (infoFechaCita) infoFechaCita.textContent = 'N/A';
    if (infoMotivoCita) infoMotivoCita.textContent = 'N/A';
}

/**
 * Obtiene y autocompleta los datos del paciente y la cita médica.
 */
async function autocompletarDatosCita() {
    const idCita = inputCitaId ? inputCitaId.value.trim() : '';

    if (idCita === "") {
        limpiarCamposCita();
        return;
    }

    try {
        const response = await fetch(`/recibos/cita/${idCita}`);
        const data = await response.json();

        if (response.ok) {
            
            ID_PACIENTE_ACTUAL = data.ID_PACIENTE;
            if (inputPacienteId) inputPacienteId.value = data.ID_PACIENTE;

            const fecha = new Date(data.FECHA_CITA).toLocaleDateString('es-HN', {
                year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit'
            });

            if (infoCitaPaciente) infoCitaPaciente.style.display = 'block';
            if (infoNombrePaciente) infoNombrePaciente.textContent = data.NOMBRE_PACIENTE;
            if (infoRtnPaciente) infoRtnPaciente.textContent = data.RTN_PACIENTE || 'N/A';
            if (infoFechaCita) infoFechaCita.textContent = fecha;
            if (infoMotivoCita) infoMotivoCita.textContent = data.MOTIVO_CITA;

        } else {
            // alert(`Error: Cita médica no encontrada. ${data.message || ''}`); 
            console.warn(`Cita no encontrada: ${data.message || ''}`);
            limpiarCamposCita();
        }
    } catch (error) {
        console.error("Error al obtener datos de la cita:", error);
        // alert("Ocurrió un error al intentar autocompletar los datos.");
        limpiarCamposCita();
    }
}

/**
 * Habilita o deshabilita los botones de creación de recibo basados en la validez.
 */
function validarBotonesCreacion() {
    const total = parseFloat(totalInputHidden ? totalInputHidden.value : '0.00');
    const hasDetails = detallesRecibo.length > 0;
    const hasPatient = ID_PACIENTE_ACTUAL !== null || (inputPacienteId && inputPacienteId.value.trim() !== '');

    const isValid = hasDetails && hasPatient && total > 0;

    if (btnCrearRecibo) btnCrearRecibo.disabled = !isValid;
    if (btnCrearYpagar) btnCrearYpagar.disabled = !isValid;
}

/**
 * Recalcula el subtotal, descuento, ISV y monto total.
 */
function calcularTotales() {
    let subtotalCalculado = detallesRecibo.reduce((sum, item) => sum + item.total, 0);
    
    const descuento = parseFloat(descuentoInput ? descuentoInput.value : 0) || 0;
    
    // Asegurar que el descuento no sea mayor al subtotal calculado
    const descuentoAplicado = Math.min(descuento, subtotalCalculado);
    if (descuentoInput) descuentoInput.value = descuentoAplicado.toFixed(2);
    
    const subtotalNeto = subtotalCalculado - descuentoAplicado;
    
    // ISV solo se aplica si el subtotal neto es positivo
    const isvCalculado = subtotalNeto > 0 ? subtotalNeto * ISV_RATE : 0;
    
    const montoTotal = subtotalNeto + isvCalculado;

    // Actualizar campos de visualización
    if (subtotalInputDisplay) subtotalInputDisplay.value = subtotalCalculado.toFixed(2) + ' L.';
    if (isvInputDisplay) isvInputDisplay.value = isvCalculado.toFixed(2) + ' L.';
    if (totalInputDisplay) totalInputDisplay.value = montoTotal.toFixed(2) + ' L.';
    
    // Actualizar campos hidden para envío al servidor
    if (subtotalInputHidden) subtotalInputHidden.value = subtotalCalculado.toFixed(2);
    if (isvInputHidden) isvInputHidden.value = isvCalculado.toFixed(2);
    if (totalInputHidden) totalInputHidden.value = montoTotal.toFixed(2);
    
    // Actualizar campo oculto JSON con los detalles
    if (detallesJsonInput) {
        detallesJsonInput.value = JSON.stringify(detallesRecibo.map(item => ({
            ID_SERVICIO: item.id_servicio,
            CANTIDAD: item.cantidad,
            PRECIO_UNITARIO: item.precio_unitario,
            TOTAL: item.total
        })));
    }
    
    if (noServicesRow) {
        noServicesRow.style.display = detallesRecibo.length === 0 ? 'table-row' : 'none';
    }
    
    validarBotonesCreacion();
}

/**
 * Renderiza la tabla de detalles de servicios.
 */
function renderDetalles() {
    if (!detalleBody) return;
    detalleBody.innerHTML = ''; 

    detallesRecibo.forEach((item, index) => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${item.nombre_servicio}</td>
            <td>${item.precio_unitario.toFixed(2)} L.</td>
            <td>${item.cantidad}</td>
            <td>${item.total.toFixed(2)} L.</td>
            <td>
                <button type="button" class="btn-small btn-danger remove-btn" data-index="${index}" title="Eliminar servicio">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        `;
        detalleBody.appendChild(row);
    });

    // Listener para eliminar un servicio
    document.querySelectorAll('.remove-btn').forEach(button => {
        button.addEventListener('click', (e) => {
            const indexToRemove = parseInt(e.currentTarget.getAttribute('data-index'));
            detallesRecibo.splice(indexToRemove, 1);
            renderDetalles(); // Re-renderizar y recalcular
        });
    });

    calcularTotales();
}

/**
 * Agrega un servicio seleccionado a la lista de detalles del recibo.
 */
function addService() {
    if (!servicioSelector || !cantidadInput) return;

    const selectedOption = servicioSelector.options[servicioSelector.selectedIndex];
    const idServicio = selectedOption.value;
    const nombreServicio = selectedOption.getAttribute('data-nombre');
    const precioUnitario = parseFloat(selectedOption.getAttribute('data-precio'));
    const cantidad = parseInt(cantidadInput.value);

    if (!idServicio || isNaN(precioUnitario) || precioUnitario <= 0) {
        alert("Por favor, seleccione un servicio válido con precio.");
        return;
    }

    if (isNaN(cantidad) || cantidad <= 0) {
        alert("La cantidad debe ser un número entero positivo.");
        return;
    }

    // Agregar o actualizar el servicio en la lista de detalles
    const existingItemIndex = detallesRecibo.findIndex(item => item.id_servicio === idServicio);

    if (existingItemIndex !== -1) {
        // Actualizar cantidad del existente
        detallesRecibo[existingItemIndex].cantidad += cantidad;
        detallesRecibo[existingItemIndex].total = detallesRecibo[existingItemIndex].cantidad * detallesRecibo[existingItemIndex].precio_unitario;
    } else {
        // Agregar nuevo ítem
        detallesRecibo.push({
            id_servicio: idServicio,
            nombre_servicio: nombreServicio,
            precio_unitario: precioUnitario,
            cantidad: cantidad,
            total: precioUnitario * cantidad
        });
    }

    // Resetear selector y cantidad
    servicioSelector.value = "";
    cantidadInput.value = "1";

    renderDetalles();
}


// --- Inicialización del Script ---

document.addEventListener('DOMContentLoaded', () => {
    
    // --- Lógica de la página de CREACIÓN (recibo_nuevo.ejs) ---
    
    // Listeners para la Cita/Paciente
    if (inputCitaId) {
        inputCitaId.addEventListener("blur", autocompletarDatosCita);
        
        // Cargar cita si viene en la URL o si ya tiene un valor (ej. después de un error del servidor)
        const urlParams = new URLSearchParams(window.location.search);
        const idCitaFromUrl = urlParams.get('id_cita');
        
        if (idCitaFromUrl && inputCitaId.value === '') {
            inputCitaId.value = idCitaFromUrl;
            autocompletarDatosCita();
        } else if (inputCitaId.value !== '') {
             autocompletarDatosCita();
        }
    }
    
    // Listeners para la lógica de Servicios y Totales
    if (btnAddService) {
        btnAddService.addEventListener('click', addService);
    }
    
    if (descuentoInput) {
        descuentoInput.addEventListener('input', calcularTotales);
    }

    // Listener para el botón de volver (logo) - ¡CORREGIDO!
    const logoBtn = document.getElementById('logoBtn');
    if (logoBtn) {
        logoBtn.addEventListener('click', () => {
            // Se dirige a la raíz o Dashboard
            window.location.href = '/'; 
        });
    }

    // --- Lógica de IMPRESIÓN ---

    // 1. Listener para Imprimir Listado (para la vista de /recibos - listado)
    const btnImprimirListado = document.getElementById('btnImprimirRecibos');
    if (btnImprimirListado) {
        btnImprimirListado.addEventListener('click', async () => {
            try {
                const title = document.querySelector('.page-header h1').textContent.trim();
                const logoBase64 = await imageToBase64("/roca-maya-oct.jpg");
                generarVentanaImpresion(logoBase64, title);
            } catch (error) {
                console.error("Error al imprimir listado:", error);
                alert("No se pudo generar el documento de impresión.");
            }
        });
    }

    // 2. Listener para Imprimir Recibo de Detalle (para la vista de detalle)
    const btnImprimirReciboDetalle = document.getElementById('btnImprimirRecibo');
    if (btnImprimirReciboDetalle) {
        btnImprimirReciboDetalle.addEventListener('click', () => {
            // Usa window.print() para imprimir directamente la página de detalle
            window.print(); 
        });
    }

    // --- Lógica de PRECARGA DE DETALLES (Manejo de errores o edición) ---
    // Si tienes un campo oculto que guarda los detalles precargados (por ejemplo, después de un error de validación)
    if (detallesJsonInput && detallesJsonInput.value) {
        try {
            const initialDetails = JSON.parse(detallesJsonInput.value);
            // Mapear los datos del JSON del servidor al formato interno del script
            detallesRecibo = initialDetails.map(item => ({
                id_servicio: String(item.ID_SERVICIO),
                nombre_servicio: item.NOMBRE_SERVICIO,
                precio_unitario: parseFloat(item.PRECIO_UNITARIO),
                cantidad: parseInt(item.CANTIDAD),
                total: parseFloat(item.TOTAL)
            }));
            renderDetalles();
        } catch (e) {
            console.error("Error al parsear detalles precargados:", e);
        }
    }
    
    // Inicializar totales y botones (al final, después de precargar detalles)
    calcularTotales();
});