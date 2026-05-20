// Variables globales
let tablaMedicamentos;
let medicamentosData = [];
let modalMedicamento = null;

// Inicialización cuando el documento está listo
$(document).ready(function() {
    // Inicializar modal de Bootstrap
    modalMedicamento = new bootstrap.Modal(document.getElementById('modalMedicamento'));
    
    inicializarDataTable();
    cargarMedicamentos();
    inicializarValidaciones();
    inicializarEventListeners();
    
    // Configurar búsqueda en tiempo real
    $('#searchInput').on('input', filtrarMedicamentos);
});

// Inicializar DataTable
function inicializarDataTable() {
    tablaMedicamentos = $('#tablaMedicamentos').DataTable({
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
        },
        columns: [
            { data: 'NOMBRE_MEDICAMENTO' },
            { data: 'NOMBRE_GENERICO' },
            { data: 'PRESENTACION' },
            { data: 'CONCENTRACION' },
            { 
                data: 'STOCK_ACTUAL',
                render: function(data, type, row) {
                    const stockClass = getStockClass(row.STOCK_ACTUAL, row.STOCK_MINIMO);
                    return `<span class="status ${stockClass}">${data}</span>`;
                }
            },
            { 
                data: 'PRECIO_VENTA',
                render: function(data) {
                    return data ? `L. ${parseFloat(data).toFixed(2)}` : '-';
                }
            },
            { 
                data: 'FECHA_VENCIMIENTO',
                render: function(data) {
                    if (!data) return '-';
                    const fecha = new Date(data);
                    const hoy = new Date();
                    const diffTime = fecha - hoy;
                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    
                    if (diffDays < 0) {
                        return `<span class="text-danger">Vencido</span>`;
                    } else if (diffDays <= 30) {
                        return `<span class="text-warning">${formatearFecha(data)} (${diffDays}d)</span>`;
                    } else {
                        return formatearFecha(data);
                    }
                }
            },
            { 
                data: 'ESTADO',
                render: function(data) {
                    const estadoClass = data === 'ACTIVO' ? 'active' : 
                                      data === 'VENCIDO' ? 'danger' : 'inactive';
                    return `<span class="status ${estadoClass}">${data}</span>`;
                }
            },
            {
                data: 'ID_MEDICAMENTO',
                render: function(data, type, row) {
                    return `
                        <div class="table-actions">
                            <button class="action-btn edit" onclick="editarMedicamento(${data})" title="Editar">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="action-btn delete" onclick="eliminarMedicamento(${data})" title="Eliminar">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    `;
                },
                orderable: false
            }
        ]
    });
}

// Inicializar event listeners
function inicializarEventListeners() {
    // Validación en tiempo real para campos de texto
    $('input[type="text"], textarea').on('input', function() {
        validarCampoTexto($(this));
    });
    
    // Validación para números
    $('input[type="number"]').on('input', function() {
        validarCampoNumero($(this));
    });
    
    // Validación para fechas
    $('input[type="date"]').on('change', function() {
        validarFecha($(this));
    });
}

// Inicializar validaciones del formulario
function inicializarValidaciones() {
    $('#formMedicamento').on('submit', function(e) {
        e.preventDefault();
        
        if (validarFormularioCompleto()) {
            guardarMedicamento();
        }
    });
}

// Cargar medicamentos desde la API
function cargarMedicamentos() {
    mostrarLoading(true);
    
    $.ajax({
        url: '/inventario/api/medicamentos',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                medicamentosData = response.data;
                tablaMedicamentos.clear().rows.add(medicamentosData).draw();
                actualizarEstadisticas();
            } else {
                mostrarAlerta('Error al cargar los medicamentos', 'error');
            }
        },
        error: function() {
            mostrarAlerta('Error de conexión al cargar los medicamentos', 'error');
        },
        complete: function() {
            mostrarLoading(false);
        }
    });
}

// Filtrar medicamentos
function filtrarMedicamentos() {
    const searchTerm = $('#searchInput').val().toLowerCase();
    const estadoFilter = $('#estadoFilter').val();
    const stockFilter = $('#stockFilter').val();

    const filteredData = medicamentosData.filter(med => {
        const matchSearch = !searchTerm || 
            (med.NOMBRE_MEDICAMENTO && med.NOMBRE_MEDICAMENTO.toLowerCase().includes(searchTerm)) ||
            (med.NOMBRE_GENERICO && med.NOMBRE_GENERICO.toLowerCase().includes(searchTerm));
        
        const matchEstado = !estadoFilter || med.ESTADO === estadoFilter;
        
        let matchStock = true;
        if (stockFilter && med.STOCK_ACTUAL !== undefined && med.STOCK_MINIMO !== undefined) {
            if (stockFilter === 'bajo') {
                matchStock = med.STOCK_ACTUAL <= med.STOCK_MINIMO;
            } else if (stockFilter === 'critico') {
                matchStock = med.STOCK_ACTUAL < med.STOCK_MINIMO * 0.5;
            } else if (stockFilter === 'normal') {
                matchStock = med.STOCK_ACTUAL > med.STOCK_MINIMO;
            }
        }

        return matchSearch && matchEstado && matchStock;
    });

    tablaMedicamentos.clear().rows.add(filteredData).draw();
}

// Resetear filtros
function resetearFiltros() {
    $('#searchInput').val('');
    $('#estadoFilter').val('');
    $('#stockFilter').val('');
    filtrarMedicamentos();
}

// Abrir modal para nuevo medicamento
function abrirModalNuevo() {
    $('#modalTitle').html('<i class="fas fa-pills me-2"></i>Nuevo Medicamento');
    $('#formMedicamento')[0].reset();
    $('#idMedicamento').val('');
    limpiarValidaciones();
    modalMedicamento.show();
}

// Editar medicamento
function editarMedicamento(id) {
    mostrarLoading(true);
    
    $.ajax({
        url: `/inventario/api/medicamentos/${id}`,
        method: 'GET',
        success: function(response) {
            if (response.success) {
                const med = response.data;
                $('#modalTitle').html('<i class="fas fa-pills me-2"></i>Editar Medicamento');
                $('#idMedicamento').val(med.ID_MEDICAMENTO);
                
                // Llenar formulario
                $('input[name="nombre_medicamento"]').val(med.NOMBRE_MEDICAMENTO || '');
                $('input[name="nombre_generico"]').val(med.NOMBRE_GENERICO || '');
                $('textarea[name="descripcion"]').val(med.DESCRIPCION || '');
                $('select[name="presentacion"]').val(med.PRESENTACION || '');
                $('input[name="concentracion"]').val(med.CONCENTRACION || '');
                $('select[name="via_administracion"]').val(med.VIA_ADMINISTRACION || '');
                $('input[name="stock_actual"]').val(med.STOCK_ACTUAL || 0);
                $('input[name="stock_minimo"]').val(med.STOCK_MINIMO || 10);
                $('input[name="stock_maximo"]').val(med.STOCK_MAXIMO || 100);
                $('input[name="precio_compra"]').val(med.PRECIO_COMPRA || '');
                $('input[name="precio_venta"]').val(med.PRECIO_VENTA || '');
                $('input[name="lote"]').val(med.LOTE || '');
                $('input[name="fecha_vencimiento"]').val(med.FECHA_VENCIMIENTO || '');
                $('input[name="proveedor"]').val(med.PROVEEDOR || '');
                $('input[name="requiere_receta"]').prop('checked', med.REQUIERE_RECETA || false);
                
                limpiarValidaciones();
                modalMedicamento.show();
            } else {
                mostrarAlerta('Error al cargar el medicamento', 'error');
            }
        },
        error: function() {
            mostrarAlerta('Error de conexión', 'error');
        },
        complete: function() {
            mostrarLoading(false);
        }
    });
}

// Guardar medicamento
function guardarMedicamento() {
    mostrarLoading(true);
    
    const formData = $('#formMedicamento').serialize();
    const idMedicamento = $('#idMedicamento').val();
    const url = idMedicamento ? `/inventario/editar/${idMedicamento}` : '/inventario/nuevo';

    $.ajax({
        url: url,
        method: 'POST',
        data: formData,
        success: function(response) {
            if (response.success) {
                modalMedicamento.hide();
                mostrarAlerta(response.message, 'success');
                cargarMedicamentos();
            } else {
                mostrarAlerta(response.message || 'Error al guardar', 'error');
            }
        },
        error: function(xhr, status, error) {
            let mensaje = 'Error al guardar el medicamento';
            if (xhr.responseJSON && xhr.responseJSON.message) {
                mensaje = xhr.responseJSON.message;
            }
            mostrarAlerta(mensaje, 'error');
        },
        complete: function() {
            mostrarLoading(false);
        }
    });
}

// Eliminar medicamento
function eliminarMedicamento(id) {
    if (confirm('¿Está seguro de que desea eliminar este medicamento?')) {
        mostrarLoading(true);
        
        $.ajax({
            url: `/inventario/eliminar/${id}`,
            method: 'POST',
            success: function(response) {
                if (response.success) {
                    mostrarAlerta(response.message, 'success');
                    cargarMedicamentos();
                } else {
                    mostrarAlerta(response.message || 'Error al eliminar', 'error');
                }
            },
            error: function(xhr) {
                let mensaje = 'Error al eliminar el medicamento';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    mensaje = xhr.responseJSON.message;
                }
                mostrarAlerta(mensaje, 'error');
            },
            complete: function() {
                mostrarLoading(false);
            }
        });
    }
}

// Generar reporte
function generarReporte() {
    mostrarLoading(true);
    
    // Simular generación de reporte
    setTimeout(() => {
        mostrarAlerta('Reporte generado exitosamente', 'success');
        mostrarLoading(false);
        
        // Aquí puedes agregar la lógica real para descargar el reporte
        // window.open('/inventario/reporte', '_blank');
    }, 2000);
}

// ========== VALIDACIONES ==========

// Validar formulario completo
function validarFormularioCompleto() {
    let esValido = true;
    const formulario = $('#formMedicamento')[0];
    
    // Validar campos requeridos
    const camposRequeridos = formulario.querySelectorAll('[required]');
    camposRequeridos.forEach(campo => {
        if (!campo.value.trim()) {
            marcarError(campo, 'Este campo es requerido');
            esValido = false;
        } else {
            limpiarError(campo);
        }
    });
    
    // Validar nombres
    const nombreMedicamento = $('input[name="nombre_medicamento"]');
    if (nombreMedicamento.val().trim() && !validarSoloTextoYNumeros(nombreMedicamento.val())) {
        marcarError(nombreMedicamento[0], 'Solo se permiten letras, números y espacios');
        esValido = false;
    }
    
    const nombreGenerico = $('input[name="nombre_generico"]');
    if (nombreGenerico.val().trim() && !validarSoloTextoYNumeros(nombreGenerico.val())) {
        marcarError(nombreGenerico[0], 'Solo se permiten letras, números y espacios');
        esValido = false;
    }
    
    // Validar concentración
    const concentracion = $('input[name="concentracion"]');
    if (concentracion.val().trim() && !validarConcentracion(concentracion.val())) {
        marcarError(concentracion[0], 'Formato inválido. Ejemplo: 100mg, 5ml, 250mg/5ml');
        esValido = false;
    }
    
    // Validar stock
    const stockActual = parseFloat($('input[name="stock_actual"]').val()) || 0;
    const stockMinimo = parseFloat($('input[name="stock_minimo"]').val()) || 0;
    const stockMaximo = parseFloat($('input[name="stock_maximo"]').val()) || 0;
    
    if (stockMinimo >= stockMaximo) {
        marcarError($('input[name="stock_minimo"]')[0], 'El stock mínimo debe ser menor al stock máximo');
        marcarError($('input[name="stock_maximo"]')[0], 'El stock máximo debe ser mayor al stock mínimo');
        esValido = false;
    }
    
    if (stockActual < 0) {
        marcarError($('input[name="stock_actual"]')[0], 'El stock no puede ser negativo');
        esValido = false;
    }
    
    // Validar precios
    const precioCompra = parseFloat($('input[name="precio_compra"]').val()) || 0;
    const precioVenta = parseFloat($('input[name="precio_venta"]').val()) || 0;
    
    if (precioCompra < 0) {
        marcarError($('input[name="precio_compra"]')[0], 'El precio no puede ser negativo');
        esValido = false;
    }
    
    if (precioVenta < 0) {
        marcarError($('input[name="precio_venta"]')[0], 'El precio no puede ser negativo');
        esValido = false;
    }
    
    if (precioCompra > precioVenta && precioVenta > 0) {
        marcarError($('input[name="precio_compra"]')[0], 'El precio de compra no puede ser mayor al precio de venta');
        esValido = false;
    }
    
    // Validar fecha de vencimiento
    const fechaVencimiento = $('input[name="fecha_vencimiento"]');
    if (fechaVencimiento.val() && !validarFechaFutura(fechaVencimiento.val())) {
        marcarError(fechaVencimiento[0], 'La fecha de vencimiento debe ser futura');
        esValido = false;
    }
    
    return esValido;
}

// Validar campo de texto
function validarCampoTexto(campo) {
    const valor = campo.val().trim();
    const nombre = campo.attr('name');
    
    if (!valor) {
        limpiarError(campo[0]);
        return true;
    }
    
    let esValido = true;
    let mensaje = '';
    
    switch(nombre) {
        case 'nombre_medicamento':
        case 'nombre_generico':
        case 'proveedor':
            if (!validarSoloTextoYNumeros(valor)) {
                mensaje = 'Solo se permiten letras, números y espacios';
                esValido = false;
            } else if (valor.length > 255) {
                mensaje = 'Máximo 255 caracteres permitidos';
                esValido = false;
            }
            break;
            
        case 'concentracion':
            if (!validarConcentracion(valor)) {
                mensaje = 'Formato inválido. Ejemplo: 100mg, 5ml, 250mg/5ml';
                esValido = false;
            }
            break;
            
        case 'lote':
            if (!validarSoloTextoYNumeros(valor)) {
                mensaje = 'Solo se permiten letras, números y guiones';
                esValido = false;
            }
            break;
            
        case 'descripcion':
            if (valor.length > 1000) {
                mensaje = 'Máximo 1000 caracteres permitidos';
                esValido = false;
            }
            break;
    }
    
    if (!esValido) {
        marcarError(campo[0], mensaje);
    } else {
        limpiarError(campo[0]);
    }
    
    return esValido;
}

// Validar campo numérico
function validarCampoNumero(campo) {
    const valor = parseFloat(campo.val()) || 0;
    const nombre = campo.attr('name');
    
    let esValido = true;
    let mensaje = '';
    
    switch(nombre) {
        case 'stock_actual':
        case 'stock_minimo':
        case 'stock_maximo':
            if (valor < 0) {
                mensaje = 'El valor no puede ser negativo';
                esValido = false;
            } else if (valor > 1000000) {
                mensaje = 'El valor es demasiado grande';
                esValido = false;
            }
            break;
            
        case 'precio_compra':
        case 'precio_venta':
            if (valor < 0) {
                mensaje = 'El precio no puede ser negativo';
                esValido = false;
            } else if (valor > 100000) {
                mensaje = 'El precio es demasiado alto';
                esValido = false;
            }
            break;
    }
    
    if (!esValido) {
        marcarError(campo[0], mensaje);
    } else {
        limpiarError(campo[0]);
    }
    
    return esValido;
}

// Validar fecha
function validarFecha(campo) {
    const valor = campo.val();
    
    if (!valor) {
        limpiarError(campo[0]);
        return true;
    }
    
    if (!validarFechaFutura(valor)) {
        marcarError(campo[0], 'La fecha de vencimiento debe ser futura');
        return false;
    }
    
    limpiarError(campo[0]);
    return true;
}

// ========== FUNCIONES DE VALIDACIÓN ESPECÍFICAS ==========

function validarSoloTextoYNumeros(texto) {
    return /^[a-zA-ZÁáÉéÍíÓóÚúÑñ0-9\s\-\.\,\(\)]+$/.test(texto);
}

function validarConcentracion(concentracion) {
    return /^[0-9]+(\.[0-9]+)?\s*(mg|ml|g|mg\/ml|mg\/5ml|UI|mcg|%)(\s*\/\s*[0-9]+(\.[0-9]+)?\s*(mg|ml|g))?$/i.test(concentracion);
}

function validarFechaFutura(fecha) {
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);
    const fechaVencimiento = new Date(fecha);
    return fechaVencimiento >= hoy;
}

// ========== FUNCIONES DE UI PARA VALIDACIÓN ==========

function marcarError(campo, mensaje) {
    // Remover errores previos
    limpiarError(campo);
    
    // Agregar clase de error
    $(campo).addClass('is-invalid');
    
    // Crear mensaje de error
    const errorDiv = $('<div class="invalid-feedback"></div>').text(mensaje);
    $(campo).after(errorDiv);
}

function limpiarError(campo) {
    $(campo).removeClass('is-invalid');
    $(campo).next('.invalid-feedback').remove();
}

function limpiarValidaciones() {
    $('.is-invalid').removeClass('is-invalid');
    $('.invalid-feedback').remove();
}

// ========== FUNCIONES HELPER ==========

function getStockClass(stockActual, stockMinimo) {
    if (stockActual < stockMinimo * 0.5) {
        return 'danger';
    } else if (stockActual <= stockMinimo) {
        return 'warning';
    } else {
        return 'active';
    }
}

function formatearFecha(fecha) {
    if (!fecha) return '-';
    return new Date(fecha).toLocaleDateString('es-ES');
}

function mostrarLoading(mostrar) {
    $('#loadingSpinner').css('display', mostrar ? 'flex' : 'none');
}

function mostrarAlerta(mensaje, tipo) {
    // Crear alerta temporal
    const alerta = $(`
        <div class="alert alert-${tipo === 'error' ? 'danger' : 'success'} alert-dismissible fade show" role="alert">
            <i class="fas fa-${tipo === 'error' ? 'exclamation-triangle' : 'check-circle'} me-2"></i>
            ${mensaje}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `);
    
    // Posicionar la alerta
    alerta.css({
        'position': 'fixed',
        'top': '20px',
        'right': '20px',
        'z-index': '9999',
        'min-width': '300px'
    });
    
    $('body').append(alerta);
    
    // Auto-eliminar después de 5 segundos
    setTimeout(() => {
        alerta.alert('close');
    }, 5000);
}

// Actualizar estadísticas
function actualizarEstadisticas() {
    const total = medicamentosData.length;
    const activos = medicamentosData.filter(m => m.ESTADO === 'ACTIVO').length;
    const stockBajo = medicamentosData.filter(m => 
        m.STOCK_ACTUAL <= m.STOCK_MINIMO && m.ESTADO === 'ACTIVO'
    ).length;
    
    const hoy = new Date();
    const proximosVencer = medicamentosData.filter(m => {
        if (!m.FECHA_VENCIMIENTO) return false;
        const vencimiento = new Date(m.FECHA_VENCIMIENTO);
        const diffTime = vencimiento - hoy;
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays <= 30 && diffDays > 0;
    }).length;

    $('#totalMedicamentos').text(total);
    $('#medicamentosActivos').text(activos);
    $('#stockBajo').text(stockBajo);
    $('#proximosVencer').text(proximosVencer);
}