document.addEventListener('DOMContentLoaded', async () => {
  const logoBtn = document.getElementById('logoBtn');
  const selectorPaciente = document.getElementById('selectorPaciente');
  const btnExportarPDF = document.getElementById('btnExportarPDF');
  const btnImprimir = document.getElementById('btnImprimir');
  const btnEditarHistorial = document.getElementById('btnEditarHistorial');
  const formEditarHistorial = document.getElementById('formEditarHistorial');
  const historialContainer = document.querySelector('.historial-contenido');

  let pacienteActualId = null;

  // --- BOTÓN LOGO ---
  if (logoBtn) {
    logoBtn.addEventListener('click', () => window.location.href = '/dashboard');
  }

  // --- FORMULARIO EDITAR HISTORIAL ---
  if (formEditarHistorial) {
    formEditarHistorial.addEventListener('submit', async (e) => {
      e.preventDefault();
      await guardarHistorial();
    });
  }

  // --- CARGAR LISTA DE PACIENTES ---
  if (selectorPaciente) {
    await cargarPacientes();
    
    // Si viene por URL ?pacienteId=...
    const params = new URLSearchParams(window.location.search);
    const pacienteId = params.get('pacienteId');
    if (pacienteId) {
      selectorPaciente.value = pacienteId;
      await cargarHistorial(pacienteId);
    }
  }

  // --- CAMBIO DE PACIENTE ---
  if (selectorPaciente) {
    selectorPaciente.addEventListener('change', async (e) => {
      const pacienteId = e.target.value;
      if (!pacienteId) {
        historialContainer.innerHTML = '<p class="text-muted">Seleccione un paciente para ver su historial médico.</p>';
        return;
      }
      pacienteActualId = pacienteId;
      await cargarHistorial(pacienteId);
    });
  }

  // --- FUNCIÓN PARA CARGAR PACIENTES ---
  async function cargarPacientes() {
    try {
      mostrarLoading(selectorPaciente, 'Cargando pacientes...');
      
      const res = await fetch('/historial/pacientes');
      if (!res.ok) throw new Error('No se pudieron cargar los pacientes');
      
      const pacientes = await res.json();
      selectorPaciente.innerHTML = '<option value="">Seleccione un paciente...</option>';
      
      pacientes.forEach(p => {
        const opt = document.createElement('option');
        opt.value = p.ID_PACIENTE;
        opt.textContent = `${p.NOMBRES} ${p.APELLIDOS}`;
        selectorPaciente.appendChild(opt);
      });
      
    } catch (err) {
      console.error('Error cargando pacientes:', err);
      mostrarNotificacion(err.message, 'danger');
    }
  }

  // --- FUNCIÓN PARA CARGAR HISTORIAL ---
  async function cargarHistorial(pacienteId) {
    try {
      mostrarLoading(historialContainer, 'Cargando historial médico...');
      
      const res = await fetch(`/historial/${pacienteId}`);
      if (!res.ok) throw new Error('Error al cargar historial');
      
      const data = await res.json();

      if (!data.paciente) {
        historialContainer.innerHTML = `<p class="text-danger">Paciente no encontrado.</p>`;
        return;
      }

      if (!data.historial) {
        historialContainer.innerHTML = `
          <div class="alert alert-info">
            <h5>${data.paciente.NOMBRES} ${data.paciente.APELLIDOS}</h5>
            <p class="mb-0">El paciente no tiene historial médico registrado.</p>
          </div>`;
        return;
      }

      const h = data.historial;
      historialContainer.innerHTML = `
        <div class="historial-header bg-light p-3 rounded mb-3">
          <h5 class="mb-1">Historial Médico de ${data.paciente.NOMBRES} ${data.paciente.APELLIDOS}</h5>
          <small class="text-muted">ID: ${data.paciente.ID_PACIENTE} | ${data.paciente.GENERO || 'N/A'} | ${data.paciente.FECHA_NACIMIENTO ? new Date(data.paciente.FECHA_NACIMIENTO).toLocaleDateString() : 'N/A'}</small>
        </div>
        
        <div class="row">
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header bg-warning bg-opacity-25">
                <h6 class="mb-0"><i class="fas fa-allergies me-2"></i>Alergias</h6>
              </div>
              <div class="card-body">
                <p class="card-text">${parseJSONField(h.ALERGIAS).join(', ') || 'Ninguna registrada'}</p>
              </div>
            </div>
            
            <div class="card mb-3">
              <div class="card-header bg-danger bg-opacity-25">
                <h6 class="mb-0"><i class="fas fa-heartbeat me-2"></i>Enfermedades Crónicas</h6>
              </div>
              <div class="card-body">
                <p class="card-text">${parseJSONField(h.ENFERMEDADES_CRONICAS).join(', ') || 'Ninguna registrada'}</p>
              </div>
            </div>
            
            <div class="card mb-3">
              <div class="card-header bg-info bg-opacity-25">
                <h6 class="mb-0"><i class="fas fa-syringe me-2"></i>Cirugías Previas</h6>
              </div>
              <div class="card-body">
                <p class="card-text">${parseJSONField(h.CIRUGIAS_PREVIAS).join(', ') || 'Ninguna registrada'}</p>
              </div>
            </div>
          </div>
          
          <div class="col-md-6">
            <div class="card mb-3">
              <div class="card-header bg-success bg-opacity-25">
                <h6 class="mb-0"><i class="fas fa-pills me-2"></i>Medicamentos Actuales</h6>
              </div>
              <div class="card-body">
                <p class="card-text">${parseJSONField(h.MEDICAMENTOS_ACTUALES).join(', ') || 'Ninguno registrado'}</p>
              </div>
            </div>
            
            <div class="card mb-3">
              <div class="card-header bg-primary bg-opacity-25">
                <h6 class="mb-0"><i class="fas fa-shield-alt me-2"></i>Vacunas</h6>
              </div>
              <div class="card-body">
                <p class="card-text">${parseJSONField(h.VACUNAS).join(', ') || 'No registradas'}</p>
              </div>
            </div>
            
            <div class="card mb-3">
              <div class="card-header bg-secondary bg-opacity-25">
                <h6 class="mb-0"><i class="fas fa-sticky-note me-2"></i>Notas Importantes</h6>
              </div>
              <div class="card-body">
                <p class="card-text">${h.NOTAS_IMPORTANTES || 'Sin notas importantes'}</p>
              </div>
            </div>
          </div>
        </div>
      `;
      
    } catch (err) {
      console.error('Error cargando historial:', err);
      historialContainer.innerHTML = `<p class="text-danger">Error al cargar el historial: ${err.message}</p>`;
      mostrarNotificacion(err.message, 'danger');
    }
  }

  // --- GUARDAR NUEVO PACIENTE ---
  async function guardarNuevoPaciente() {
    const form = document.getElementById('formCrearPaciente');
    const btn = document.getElementById('btnGuardarPaciente');
    
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }

    const datosPaciente = {
      NOMBRES: document.getElementById('nombres').value.trim(),
      APELLIDOS: document.getElementById('apellidos').value.trim(),
      FECHA_NACIMIENTO: document.getElementById('fechaNacimiento').value,
      GENERO: document.getElementById('genero').value,
      TELEFONO: document.getElementById('telefono').value.trim(),
      EMAIL: document.getElementById('email').value.trim(),
      DIRECCION: document.getElementById('direccion').value.trim(),
      USUARIO_CREACION: 'admin' // En un caso real, obtener del usuario logueado
    };

    try {
      btn.disabled = true;
      btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Guardando...';

      const res = await fetch('/pacientes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(datosPaciente)
      });

      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.error || 'Error al crear paciente');
      }

      const result = await res.json();
      
      mostrarNotificacion('Paciente creado exitosamente', 'success');
      
      // Cerrar modal y limpiar formulario
      const modal = bootstrap.Modal.getInstance(document.getElementById('crearPacienteModal'));
      modal.hide();
      form.reset();
      
      // Recargar lista de pacientes
      await cargarPacientes();
      
      // Seleccionar el nuevo paciente
      if (result.idPaciente) {
        selectorPaciente.value = result.idPaciente;
        await cargarHistorial(result.idPaciente);
      }
      
    } catch (err) {
      console.error('Error creando paciente:', err);
      mostrarNotificacion(err.message, 'danger');
    } finally {
      btn.disabled = false;
      btn.innerHTML = 'Guardar';
    }
  }

  // --- GUARDAR HISTORIAL MÉDICO ---
  async function guardarHistorial() {
    if (!pacienteActualId) {
      mostrarNotificacion('Seleccione un paciente primero', 'warning');
      return;
    }

    const datosHistorial = {
      ALERGIAS: splitStringToArray(document.getElementById('editarAlergias').value),
      ENFERMEDADES_CRONICAS: splitStringToArray(document.getElementById('editarEnfermedades').value),
      CIRUGIAS_PREVIAS: splitStringToArray(document.getElementById('editarCirugias').value),
      MEDICAMENTOS_ACTUALES: splitStringToArray(document.getElementById('editarMedicamentos').value),
      VACUNAS: splitStringToArray(document.getElementById('editarVacunas').value),
      NOTAS_IMPORTANTES: document.getElementById('editarNotas').value.trim(),
      USUARIO_MODIFICACION: 'admin'
    };

    try {
      const res = await fetch(`/historial/${pacienteActualId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(datosHistorial)
      });

      if (!res.ok) throw new Error('Error al guardar historial');

      const result = await res.json();
      
      mostrarNotificacion(result.message, 'success');
      
      // Cerrar modal y recargar historial
      const modal = bootstrap.Modal.getInstance(document.getElementById('editarHistorialModal'));
      modal.hide();
      
      await cargarHistorial(pacienteActualId);
      
    } catch (err) {
      console.error('Error guardando historial:', err);
      mostrarNotificacion(err.message, 'danger');
    }
  }

  // --- EXPORTAR PDF ---
  if (btnExportarPDF) {
    btnExportarPDF.addEventListener('click', async () => {
      if (!pacienteActualId) {
        mostrarNotificacion('Seleccione un paciente primero', 'warning');
        return;
      }
      
      try {
        btnExportarPDF.disabled = true;
        btnExportarPDF.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Generando...';

        const res = await fetch(`/historial/${pacienteActualId}/exportar-pdf`);
        if (!res.ok) throw new Error('Error al generar PDF');
        
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `historial_${pacienteActualId}_${new Date().toISOString().split('T')[0]}.pdf`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        mostrarNotificacion('PDF descargado exitosamente', 'success');
      } catch (err) {
        console.error('Error generando PDF:', err);
        mostrarNotificacion('Error al generar PDF: ' + err.message, 'danger');
      } finally {
        btnExportarPDF.disabled = false;
        btnExportarPDF.innerHTML = '<i class="fa fa-file-pdf"></i> Exportar PDF';
      }
    });
  }

  // --- IMPRIMIR HISTORIAL ---
  if (btnImprimir) {
    btnImprimir.addEventListener('click', async () => {
      if (!pacienteActualId) {
        mostrarNotificacion('Seleccione un paciente primero', 'warning');
        return;
      }
      
      try {
        const logoBase64 = await imageToBase64('/img/logo-roca-maya.png');
        generarVentanaImpresion(logoBase64);
      } catch {
        console.log('No se pudo cargar el logo, usando versión sin logo');
        generarVentanaImpresion(null);
      }
    });
  }

  // --- EDITAR HISTORIAL ---
  if (btnEditarHistorial) {
    btnEditarHistorial.addEventListener('click', async () => {
      if (!pacienteActualId) {
        mostrarNotificacion('Seleccione un paciente primero', 'warning');
        return;
      }
      
      try {
        // Cargar datos actuales en el modal
        const res = await fetch(`/historial/${pacienteActualId}`);
        if (!res.ok) throw new Error('Error al cargar datos del historial');
        
        const data = await res.json();
        
        if (data.historial) {
          const h = data.historial;
          document.getElementById('editarAlergias').value = parseJSONField(h.ALERGIAS).join(', ');
          document.getElementById('editarEnfermedades').value = parseJSONField(h.ENFERMEDADES_CRONICAS).join(', ');
          document.getElementById('editarCirugias').value = parseJSONField(h.CIRUGIAS_PREVIAS).join(', ');
          document.getElementById('editarMedicamentos').value = parseJSONField(h.MEDICAMENTOS_ACTUALES).join(', ');
          document.getElementById('editarVacunas').value = parseJSONField(h.VACUNAS).join(', ');
          document.getElementById('editarNotas').value = h.NOTAS_IMPORTANTES || '';
        }
        
        const modal = new bootstrap.Modal(document.getElementById('editarHistorialModal'));
        modal.show();
        
      } catch (err) {
        console.error('Error cargando datos para editar:', err);
        mostrarNotificacion('Error al cargar datos del historial', 'danger');
      }
    });
  }
});

// ==============================
// FUNCIONES UTILITARIAS
// ==============================

function parseJSONField(field) {
  // 1. Manejar valores nulos o indefinidos inmediatamente.
  if (!field) {
    return [];
  }
  
  // 2. Convertir el valor a string de forma segura para evitar el error 'field.split is not a function'.
  let fieldString = String(field);

  try {
    // Intentar parsear como JSON
    const parsed = JSON.parse(fieldString);
    return Array.isArray(parsed) ? parsed.filter(item => item && item.trim() !== '') : [];
  } catch {
    // Si falla el parseo JSON, usar el fallback de coma.
    return fieldString.split(',').map(item => item.trim()).filter(item => item !== '');
  }
}

function splitStringToArray(str) {
  return str.split(',').map(item => item.trim()).filter(item => item !== '');
}

function imageToBase64(url) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.crossOrigin = 'Anonymous';
    img.onload = function () {
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      canvas.width = img.width;
      canvas.height = img.height;
      ctx.drawImage(img, 0, 0);
      resolve(canvas.toDataURL('image/png')); 
    };
    img.onerror = reject;
    img.src = url;
  });
}

function generarVentanaImpresion(logoBase64) {
  const contenedor = document.querySelector('.historial-contenido') || document.body;
  const pacienteNombre = document.querySelector('.historial-header h5')?.textContent || 'Historial Médico';
  
  const ventana = window.open('', '', 'width=900,height=700');
  
  const estilo = `
    <style>
      body { 
        font-family: "Times New Roman", serif; 
        padding: 20px; 
        margin: 0; 
        line-height: 1.4;
        color: #333;
      }
      .header { 
        display: flex; 
        align-items: center; 
        border-bottom: 2px solid #333; 
        padding-bottom: 15px; 
        margin-bottom: 20px; 
      }
      .logo { 
        height: 80px; 
        margin-right: 20px; 
        max-width: 200px; 
        object-fit: contain; 
      }
      .logo-placeholder { 
        height: 80px; 
        width: 200px; 
        border: 2px dashed #ccc; 
        display: flex; 
        align-items: center; 
        justify-content: center; 
        color: #666; 
        font-size: 12px; 
        margin-right: 20px; 
      }
      .company-info { 
        flex: 1; 
      }
      .company-name { 
        font-size: 20px; 
        font-weight: bold; 
        color: #333; 
      }
      .company-slogan { 
        font-size: 14px; 
        color: #666; 
        font-style: italic; 
      }
      h2 { 
        text-align: center; 
        margin: 20px 0; 
        color: #2c3e50; 
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
      }
      .card { 
        border: 1px solid #ddd !important; 
        margin-bottom: 15px !important;
        box-shadow: none !important;
      }
      .card-header {
        background-color: #f8f9fa !important;
        border-bottom: 1px solid #ddd !important;
        font-weight: bold;
      }
      .historial-header {
        background-color: #f8f9fa !important;
        border: 1px solid #ddd !important;
        margin-bottom: 20px !important;
      }
      @media print {
        .card { break-inside: avoid; }
      }
    </style>
  `;

  ventana.document.write(`
    <html>
      <head>
        <title>Historial Médico</title>
        ${estilo}
      </head>
      <body>
        <div class="header">
          ${logoBase64 ? `<img src="${logoBase64}" class="logo">` : '<div class="logo-placeholder">Logo no disponible</div>'}
          <div class="company-info">
            <div class="company-name">Clínicas Médicas Roca Maya</div>
            <div class="company-slogan">Tu salud es nuestra seguridad</div>
          </div>
        </div>
        <h2>${pacienteNombre}</h2>
        ${contenedor.innerHTML}
        <div style="margin-top: 30px; font-size: 12px; color: #666; text-align: center;">
          Generado el ${new Date().toLocaleDateString()} a las ${new Date().toLocaleTimeString()}
        </div>
      </body>
    </html>
  `);
  ventana.document.close();
  
  setTimeout(() => { 
    ventana.print(); 
    setTimeout(() => ventana.close(), 500);
  }, 1000);
}

function mostrarNotificacion(mensaje, tipo = 'info') {
  // Remover notificaciones anteriores
  const alertasAnteriores = document.querySelectorAll('.alert-notificacion');
  alertasAnteriores.forEach(alerta => alerta.remove());

  const alerta = document.createElement('div');
  alerta.className = `alert alert-${tipo} alert-notificacion alert-dismissible fade show position-fixed`;
  alerta.style.cssText = `top: 20px; right: 20px; z-index: 2000; min-width: 280px;`;
  alerta.innerHTML = `
    ${mensaje}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  `;
  document.body.appendChild(alerta);
  
  // Auto-remover después de 5 segundos
  setTimeout(() => {
    if (alerta.parentNode) {
      alerta.remove();
    }
  }, 5000);
}

function mostrarLoading(elemento, mensaje = 'Cargando...') {
  elemento.innerHTML = `
    <div class="text-center py-4">
      <div class="spinner-border text-primary mb-2"></div>
      <p class="text-muted">${mensaje}</p>
    </div>
  `;
}