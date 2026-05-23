document.addEventListener('DOMContentLoaded', () => {
  // Elementos principales de la interfaz
  const tabla = document.getElementById('usuariosTable');
  const filas = tabla ? tabla.querySelectorAll('tbody tr.fila-usuario') : [];
  const totalUsuarios = document.getElementById('totalUsuarios');
  const usuariosMostrados = document.getElementById('usuariosMostrados');
  const ultimaActualizacion = document.getElementById('ultimaActualizacion');

  // Filtros de búsqueda
  const usuarioFilter = document.getElementById('usuarioFilter');
  const nombreFilter = document.getElementById('nombreFilter');
  const estadoFilter = document.getElementById('estadoFilter');
  const tfaFilter = document.getElementById('tfaFilter');

  // Botones de acción general
  const btnFiltros = document.getElementById('btnAplicarFiltros');
  const btnLimpiar = document.getElementById('btnLimpiarFiltros');
  const btnImprimir = document.getElementById('btnImprimir');
  const logoBtn = document.getElementById('logoBtn');
  const btnNuevoUsuario = document.getElementById('btnNuevoUsuario');

  // Modales y sus formularios internos
  const modalUsuario = document.getElementById('modalUsuario');
  const modalEliminar = document.getElementById('modalEliminar');
  const formUsuario = document.getElementById('formUsuario');
  
  // Inputs del Modal de Edición / Creación
  const inputId = document.getElementById('inputId');
  const inputUsuario = document.getElementById('inputUsuario');
  const inputNombre = document.getElementById('inputNombre');
  const selectRol = document.getElementById('selectRol'); 
  const selectEstado = document.getElementById('selectEstado');

  // Botones de control de los Modales
  const btnCancelar = document.getElementById('btnCancelar');
  const btnCancelarEliminar = document.getElementById('btnCancelarEliminar');
  const btnConfirmarEliminar = document.getElementById('btnConfirmarEliminar');
  const textoConfirmacion = document.getElementById('textoConfirmacion');

  // Identificador único del Administrador en sesión para Auditoría/Bitácora
  const usuarioLogueado = "ADMINISTRADOR"; 

  // Variables de control de estado interno
  let usuarioEliminarId = null;

  // =====================================================================
  // INICIALIZACIÓN DE CONTADORES
  // =====================================================================
  if (totalUsuarios) totalUsuarios.textContent = filas.length;
  if (usuariosMostrados) usuariosMostrados.textContent = filas.length;
  if (ultimaActualizacion) ultimaActualizacion.textContent = new Date().toLocaleString();

  // =====================================================================
  // EVENTOS DE FILTROS Y NAVEGACIÓN
  // =====================================================================
  if (btnFiltros) btnFiltros.addEventListener('click', aplicarFiltros);

  if (btnLimpiar) {
    btnLimpiar.addEventListener('click', () => {
      if (usuarioFilter) usuarioFilter.value = '';
      if (nombreFilter) nombreFilter.value = '';
      if (estadoFilter) estadoFilter.value = '';
      if (tfaFilter) tfaFilter.value = '';
      aplicarFiltros();
    });
  }

  if (logoBtn) {
    logoBtn.addEventListener('click', () => {
      window.location.href = '/dashboard';
    });
  }

  // =====================================================================
  // EVENTO PARA CREAR NUEVO USUARIO (ABRIR MODAL LIMPIO)
  // =====================================================================
  if (btnNuevoUsuario) {
    btnNuevoUsuario.addEventListener('click', () => {
      if (formUsuario) formUsuario.reset(); 
      if (inputId) inputId.value = '';     
      
      const modalTitulo = document.getElementById('modalTitulo');
      if (modalTitulo) modalTitulo.textContent = 'Crear Nuevo Usuario';
      
      if (modalUsuario) modalUsuario.style.display = 'block';
    });
  }

  // =====================================================================
  // DELEGACIÓN DE EVENTOS DE LA TABLA (EDITAR, ELIMINAR, ACTIVAR)
  // =====================================================================
  if (tabla) {
    tabla.addEventListener('click', function(e) {
      const target = e.target;
      const btnEditar = target.closest('.btn-editar');
      const btnEliminar = target.closest('.btn-eliminar');
      const btnActivar = target.closest('.btn-activar');
      const btnEliminarPermanente = target.closest('.btn-eliminar-permanente');
      
      if (btnEditar) {
        const fila = btnEditar.closest('.fila-usuario');
        if (!fila) return;
        
        const id = fila.getAttribute('data-id');
        const usuario = fila.querySelector('.usuario').textContent.trim();
        const nombre = fila.querySelector('.nombre').textContent.trim();
        const idRol = fila.getAttribute('data-id-rol'); 
        const estado = fila.querySelector('.estado-td span').textContent.trim();

        inputId.value = id;
        inputUsuario.value = usuario;
        inputNombre.value = nombre;
        if (selectRol) selectRol.value = idRol; 
        if (selectEstado) selectEstado.value = estado;

        const modalTitulo = document.getElementById('modalTitulo');
        if (modalTitulo) modalTitulo.textContent = 'Editar Usuario';
        
        modalUsuario.style.display = 'block';
        return;
      }
      
      if (btnEliminar) {
        const fila = btnEliminar.closest('.fila-usuario');
        if (!fila) return;
        const id = fila.getAttribute('data-id');
        const usuario = fila.querySelector('.usuario').textContent.trim();
        
        cambiarEstadoUsuario(id, usuario, 'INACTIVO');
        return;
      }
      
      if (btnActivar) {
        const fila = btnActivar.closest('.fila-usuario');
        if (!fila) return;
        const id = fila.getAttribute('data-id');
        const usuario = fila.querySelector('.usuario').textContent.trim();
        
        cambiarEstadoUsuario(id, usuario, 'ACTIVO');
        return;
      }
      
      if (btnEliminarPermanente) {
        const fila = btnEliminarPermanente.closest('.fila-usuario');
        if (!fila) return;
        const id = fila.getAttribute('data-id');
        const usuario = fila.querySelector('.usuario').textContent.trim();
        
        usuarioEliminarId = id;
        textoConfirmacion.textContent = `¿Está seguro de que desea eliminar permanentemente al usuario "${usuario}"? Esta acción no se puede deshacer.`;
        modalEliminar.style.display = 'block';
        return;
      }
    });
  }

  // =====================================================================
  // GUARDAR EDICIÓN O CREACIÓN DE USUARIO (SUBMIT FORM)
  // =====================================================================
  if (formUsuario) {
    formUsuario.addEventListener('submit', async function(e) {
      e.preventDefault();

      const id = inputId.value; 
      const usuario = inputUsuario.value.trim();
      const nombre_usuario = inputNombre.value.trim();
      const estado = selectEstado.value;
      const id_rol = selectRol ? selectRol.value : null;

      if (!usuario || !nombre_usuario) {
        alert("El usuario y el nombre completo no pueden estar vacíos.");
        return;
      }

      const datosPeticion = {
        usuario,
        nombre_usuario,
        id_rol,
        estado,
        usuarioAccion: usuarioLogueado
      };

      let url = "/users/api/create"; 

      if (id) {
        url = "/users/api/update";
        datosPeticion.id = id;

        const filaAfectada = document.querySelector(`.fila-usuario[data-id="${id}"]`);
        datosPeticion.activo_2fa = filaAfectada ? (filaAfectada.getAttribute('data-tfa') || 0) : 0;
      } else {
        datosPeticion.contrasena = "RocaMaya2026!"; 
        datosPeticion.correo = "correo@ejemplo.com"; 
      }

      try {
        const res = await fetch(url, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(datosPeticion)
        });

        const data = await res.json();
        
        if (!data.ok) {
          alert(`Error al procesar usuario: ${data.msg || 'Error desconocido'}`);
          return;
        }

        alert(id ? "Usuario y Rol actualizados correctamente" : "Usuario creado correctamente (Contraseña temporal: RocaMaya2026!)");
        cerrarModal();
        window.location.reload(); 

      } catch (err) {
        console.error("Error en Fetch Form:", err);
        alert("Error de conexión con el servidor");
      }
    });
  }

  // =====================================================================
  // CONFIRMAR ELIMINACIÓN PERMANENTE
  // =====================================================================
  if (btnConfirmarEliminar) {
    btnConfirmarEliminar.addEventListener('click', async () => {
      if (!usuarioEliminarId) return;

      try {
        const res = await fetch("/users/api/delete", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            id: usuarioEliminarId,
            usuarioAccion: usuarioLogueado
          })
        });

        const data = await res.json();
        if (!data.ok) {
          alert("Error al eliminar: " + (data.msg || 'Error desconocido'));
          return;
        }

        const fila = document.querySelector(`.fila-usuario[data-id="${usuarioEliminarId}"]`);
        if (fila) fila.remove();

        alert(data.msg || "Usuario eliminado de forma permanente.");
        cerrarModalEliminar();
        actualizarContadores();

      } catch (err) {
        console.error("Error al eliminar usuario:", err);
        alert("Error al intentar procesar la eliminación: " + err.message);
      }
    });
  }

  // =====================================================================
  // ACTIVAR / DESACTIVAR ESTADO
  // =====================================================================
  async function cambiarEstadoUsuario(id, usuario, nuevoEstado) {
    const accion = nuevoEstado === 'ACTIVO' ? 'activar' : 'desactivar';
    if (!confirm(`¿Está seguro de que desea ${accion} al usuario "${usuario}"?`)) return;

    try {
      const res = await fetch("/users/api/cambiar-estado", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id: id,
          estado: nuevoEstado,
          usuarioAccion: usuarioLogueado
        })
      });

      const data = await res.json();
      if (!data.ok) {
        alert("Error al procesar cambio de estado: " + (data.msg || 'Error interno'));
        return;
      }

      const filaActualizada = document.querySelector(`.fila-usuario[data-id="${id}"]`);
      if (filaActualizada) {
        const estadoSpan = filaActualizada.querySelector('.estado-td span');
        if (estadoSpan) {
          estadoSpan.textContent = nuevoEstado;
          estadoSpan.className = nuevoEstado === 'ACTIVO' ? 'estado-activo' : 'estado-inactivo';
        }
        actualizarBotonesEstado(filaActualizada, nuevoEstado);
      }

      alert(data.msg || `Usuario modificado exitosamente.`);
      aplicarFiltros();

    } catch (err) {
      console.error("Error en Cambio Estado:", err);
      alert("Error de comunicación con el servidor.");
    }
  }

  function actualizarBotonesEstado(fila, estado) {
    const tdAcciones = fila.querySelector('.acciones-td');
    if (!tdAcciones) return;
    const id = fila.getAttribute('data-id');

    let botonesHTML = `
      <button class="btn-accion btn-editar" title="Editar usuario" data-id="${id}">
        <i class="fas fa-edit"></i> Editar
      </button>
    `;

    if (estado === 'ACTIVO') {
      botonesHTML += `
        <button class="btn-accion btn-eliminar" title="Desactivar usuario" data-id="${id}">
          <i class="fas fa-user-slash"></i> Desactivar
        </button>
      `;
    } else {
      botonesHTML += `
        <button class="btn-accion btn-activar" title="Activar usuario" data-id="${id}">
          <i class="fas fa-user-check"></i> Activar
        </button>
      `;
    }

    botonesHTML += `
      <button class="btn-accion btn-eliminar-permanente" title="Eliminar usuario" data-id="${id}">
        <i class="fas fa-trash"></i> Eliminar
      </button>
    `;

    tdAcciones.innerHTML = botonesHTML;
  }

  // =====================================================================
  // SISTEMA DE FILTRADO LOCAL
  // =====================================================================
  async function aplicarFiltros() {
    let mostrados = 0;
    const usuario = usuarioFilter ? usuarioFilter.value.toLowerCase() : '';
    const nombre = nombreFilter ? nombreFilter.value.toLowerCase() : '';
    const estado = estadoFilter ? estadoFilter.value : '';
    const tfa = tfaFilter ? tfaFilter.value : '';

    filas.forEach(fila => {
      const usuarioCelda = fila.querySelector('.usuario').textContent.toLowerCase();
      const nombreCelda = fila.querySelector('.nombre').textContent.toLowerCase();
      const estadoCelda = fila.querySelector('.estado-td span').textContent.trim();
      const tfaCelda = fila.querySelector('.tfa-td').textContent.trim();
      
      const tfaValor = tfaCelda.includes('Sí') ? 'SI' : 'NO';

      const coincideUsuario = !usuario || usuarioCelda.includes(usuario);
      const coincideNombre = !nombre || nombreCelda.includes(nombre);
      const coincideEstado = !estado || estadoCelda === estado;
      const coincideTfa = !tfa || tfaValor === tfa;

      if (coincideUsuario && coincideNombre && coincideEstado && coincideTfa) {
        fila.style.display = '';
        mostrados++;
      } else {
        fila.style.display = 'none';
      }
    });

    if (usuariosMostrados) usuariosMostrados.textContent = mostrados;
    if (ultimaActualizacion) ultimaActualizacion.textContent = new Date().toLocaleString();
  }

  function actualizarContadores() {
    const filasActuales = document.querySelectorAll('tbody tr.fila-usuario');
    const total = filasActuales.length;
    const mostrados = Array.from(filasActuales).filter(fila => fila.style.display !== 'none').length;
    
    if (totalUsuarios) totalUsuarios.textContent = total;
    if (usuariosMostrados) usuariosMostrados.textContent = mostrados;
    if (ultimaActualizacion) ultimaActualizacion.textContent = new Date().toLocaleString();
  }

  // =====================================================================
  // CONTROLADORES DE CIERRE DE MODAL
  // =====================================================================
  if (btnCancelar) btnCancelar.addEventListener('click', cerrarModal);
  if (btnCancelarEliminar) btnCancelarEliminar.addEventListener('click', cerrarModalEliminar);

  function cerrarModal() {
    if (modalUsuario) modalUsuario.style.display = 'none';
    if (formUsuario) formUsuario.reset();
  }

  function cerrarModalEliminar() {
    if (modalEliminar) modalEliminar.style.display = 'none';
    usuarioEliminarId = null;
  }

  window.addEventListener('click', function(e) {
    if (e.target === modalUsuario) cerrarModal();
    if (e.target === modalEliminar) cerrarModalEliminar();
  });

  // =====================================================================
  // MÓDULO DE REPORTE E IMPRESIÓN
  // =====================================================================
  if (btnImprimir) {
    btnImprimir.addEventListener('click', async () => {
      try {
        const logoBase64 = await imageToBase64('/roca-maya-oct.jpg');
        generarVentanaImpresion(logoBase64);
      } catch (error) {
        console.log('No se pudo cargar el logo, usando versión sin logo');
        generarVentanaImpresion(null);
      }
    });
  }

  function imageToBase64(url) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.crossOrigin = 'Anonymous';
      img.onload = function() {
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
    const ventana = window.open('', '', 'width=900,height=700');
    const tablaOriginal = document.getElementById('usuariosTable');
    if (!tablaOriginal) return;
    
    const tablaClon = tablaOriginal.cloneNode(true);
    
    // Remover columna de acciones
    const filasTabla = tablaClon.querySelectorAll('tr');
    filasTabla.forEach(fila => {
      const celdas = fila.querySelectorAll('td, th');
      if (celdas.length >= 5) {
        celdas[4].remove(); 
      }
    });
    
    const totalUsuariosText = document.getElementById('totalUsuarios')?.textContent || '0';
    
    ventana.document.write(`
      <html>
        <head>
          <title>Usuarios del Sistema - Clínicas Roca Maya</title>
          <style>
            body { font-family: "Times New Roman", Times, serif; padding: 20px; margin: 0; }
            .header { display: flex; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 15px; }
            .logo { height: 80px; margin-right: 20px; max-width: 200px; object-fit: contain; }
            .logo-placeholder { height: 80px; width: 200px; background: #f0f0f0; border: 2px dashed #ccc; display: flex; align-items: center; justify-content: center; margin-right: 20px; color: #666; font-size: 12px; text-align: center; }
            .company-info { flex: 1; }
            .company-name { font-size: 20px; font-weight: bold; color: #333; margin-bottom: 5px; }
            .company-slogan { font-size: 14px; color: #666; font-style: italic; }
            table { width: 100%; border-collapse: collapse; font-family: "Times New Roman", Times, serif; margin-top: 20px; }
            th, td { border: 1px solid #ccc; padding: 8px; text-align: left; font-size: 12px; }
            th { background: #f3f3f3; font-weight: bold; }
            h2 { text-align: center; margin: 20px 0; color: #2c3e50; }
            .estado-activo { background-color: #2ecc71; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
            .estado-inactivo { background-color: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
          </style>
        </head>
        <body>
          <div class="header">
            ${logoBase64 ? `<img src="${logoBase64}" alt="Clínicas Roca Maya" class="logo">` : '<div class="logo-placeholder">Logo no disponible</div>'}
            <div class="company-info">
                <div class="company-name">Clínicas Médicas Roca Maya</div>
                <div class="company-slogan">Tu salud es nuestra seguridad</div>
            </div>
          </div>
          <h2>Usuarios del Sistema</h2>
          ${tablaClon.outerHTML}
          <div style="margin-top: 20px; font-size: 12px; text-align: right;">
            <strong>Total de usuarios:</strong> ${totalUsuariosText}<br>
            <strong>Generado el:</strong> ${new Date().toLocaleString()}
          </div>
        </body>
      </html>
    `);
    ventana.document.close();

    setTimeout(() => {
      ventana.print();
      ventana.close();
    }, 500);
  }
});
