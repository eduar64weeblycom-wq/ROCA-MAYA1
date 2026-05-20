document.addEventListener('DOMContentLoaded', () => {
  const tabla = document.getElementById('usuariosTable');
  const filas = tabla.querySelectorAll('tbody tr');
  const totalUsuarios = document.getElementById('totalUsuarios');
  const usuariosMostrados = document.getElementById('usuariosMostrados');
  const ultimaActualizacion = document.getElementById('ultimaActualizacion');

  // Filtros
  const usuarioFilter = document.getElementById('usuarioFilter');
  const nombreFilter = document.getElementById('nombreFilter');
  const estadoFilter = document.getElementById('estadoFilter');
  const tfaFilter = document.getElementById('tfaFilter');

  // Botones
  const btnFiltros = document.getElementById('btnAplicarFiltros');
  const btnLimpiar = document.getElementById('btnLimpiarFiltros');
  const btnImprimir = document.getElementById('btnImprimir');
  const logoBtn = document.getElementById('logoBtn');
  const btnNuevoUsuario = document.getElementById('btnNuevoUsuario');

  // Modal elements
  const modalUsuario = document.getElementById('modalUsuario');
  const modalEliminar = document.getElementById('modalEliminar');
  const formUsuario = document.getElementById('formUsuario');
  const btnCancelar = document.getElementById('btnCancelar');
  const btnCancelarEliminar = document.getElementById('btnCancelarEliminar');
  const btnConfirmarEliminar = document.getElementById('btnConfirmarEliminar');
  const textoConfirmacion = document.getElementById('textoConfirmacion');

  // Variables globales
  let usuarioEditandoId = null;
  let usuarioEliminarId = null;

  // Inicializar contadores
  totalUsuarios.textContent = filas.length;
  usuariosMostrados.textContent = filas.length;
  ultimaActualizacion.textContent = new Date().toLocaleString();

  // Aplicar filtros
  btnFiltros.addEventListener('click', aplicarFiltros);

  // Limpiar filtros
  btnLimpiar.addEventListener('click', () => {
    usuarioFilter.value = '';
    nombreFilter.value = '';
    estadoFilter.value = '';
    tfaFilter.value = '';
    aplicarFiltros();
  });

  // Funcionalidad del botón Imprimir
  btnImprimir.addEventListener('click', async () => {
    try {
      const logoBase64 = await imageToBase64('/roca-maya-oct.jpg');
      generarVentanaImpresion(logoBase64);
    } catch (error) {
      console.log('No se pudo cargar el logo, usando versión sin logo');
      generarVentanaImpresion(null);
    }
  });

  // Funcionalidad del botón del logo
  logoBtn.addEventListener('click', () => {
    window.location.href = '/dashboard';
  });

  // Funcionalidad de los botones del modal
  btnCancelar.addEventListener('click', cerrarModal);
  btnCancelarEliminar.addEventListener('click', cerrarModalEliminar);
  btnConfirmarEliminar.addEventListener('click', confirmarEliminacion);

  // Submit del formulario de edición
  formUsuario.addEventListener('submit', async function(e) {
    e.preventDefault();
    await guardarUsuario();
  });

  // Delegación de eventos para botones de acción en las filas
  tabla.addEventListener('click', function(e) {
    const target = e.target;
    const btnEditar = target.closest('.btn-editar');
    const btnEliminar = target.closest('.btn-eliminar');
    const btnActivar = target.closest('.btn-activar');
    const btnEliminarPermanente = target.closest('.btn-eliminar-permanente');
    
    if (btnEditar) {
      const fila = btnEditar.closest('.fila-usuario');
      if (!fila) return;
      
      const id = fila.dataset.id;
      const usuario = fila.querySelector('.usuario').textContent;
      const nombre = fila.querySelector('.nombre').textContent;
      const estado = fila.querySelector('.estado-td span').textContent;

      abrirModalEditar(id, usuario, nombre, estado);
      return;
    }
    
    if (btnEliminar) {
      const fila = btnEliminar.closest('.fila-usuario');
      if (!fila) return;
      const id = fila.dataset.id;
      const usuario = fila.querySelector('.usuario').textContent;
      
      cambiarEstadoUsuario(id, usuario, 'INACTIVO');
      return;
    }
    
    if (btnActivar) {
      const fila = btnActivar.closest('.fila-usuario');
      if (!fila) return;
      const id = fila.dataset.id;
      const usuario = fila.querySelector('.usuario').textContent;
      
      cambiarEstadoUsuario(id, usuario, 'ACTIVO');
      return;
    }
    
    if (btnEliminarPermanente) {
      const fila = btnEliminarPermanente.closest('.fila-usuario');
      if (!fila) return;
      const id = fila.dataset.id;
      const usuario = fila.querySelector('.usuario').textContent;
      
      abrirModalEliminar(id, usuario);
      return;
    }
  });

  // Cerrar modales al hacer clic fuera de ellos
  window.addEventListener('click', function(e) {
    if (e.target === modalUsuario) {
      cerrarModal();
    }
    if (e.target === modalEliminar) {
      cerrarModalEliminar();
    }
  });

  // ==================== FUNCIONES PRINCIPALES ====================

  async function aplicarFiltros() {
    let mostrados = 0;
    const usuario = usuarioFilter.value.toLowerCase();
    const nombre = nombreFilter.value.toLowerCase();
    const estado = estadoFilter.value;
    const tfa = tfaFilter.value;

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

    usuariosMostrados.textContent = mostrados;
    ultimaActualizacion.textContent = new Date().toLocaleString();
  }

  function abrirModalEditar(id, usuario, nombre, estado) {
    usuarioEditandoId = id;
    
    document.getElementById('modalTitulo').textContent = 'Editar Usuario';
    document.getElementById('inputId').value = id;
    document.getElementById('inputUsuario').value = usuario;
    document.getElementById('inputNombre').value = nombre;
    document.getElementById('selectEstado').value = estado;

    modalUsuario.style.display = 'block';
  }

  function abrirModalEliminar(id, usuario) {
    usuarioEliminarId = id;
    textoConfirmacion.textContent = `¿Está seguro de que desea eliminar permanentemente al usuario "${usuario}"? Esta acción no se puede deshacer.`;
    modalEliminar.style.display = 'block';
  }

  async function guardarUsuario() {
    if (!usuarioEditandoId) {
      alert("Error: No se encontró el usuario a editar.");
      return;
    }

    const usuario = document.getElementById('inputUsuario').value;
    const nombre_usuario = document.getElementById('inputNombre').value;
    const estado = document.getElementById('selectEstado').value;

    // Validaciones
    if (!usuario.trim()) {
      alert("El usuario no puede estar vacío");
      return;
    }

    if (!nombre_usuario.trim()) {
      alert("El nombre no puede estar vacío");
      return;
    }

    // Aquí debes obtener el ID del usuario que está realizando la acción
    const usuarioAccion = 1; // Reemplaza esto con el ID del usuario logueado

    try {
      const res = await fetch("/users/api/update", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id: usuarioEditandoId,
          usuario,
          nombre_usuario,
          estado,
          activo_2fa: 0,
          usuarioAccion
        })
      });

      const data = await res.json();
      if (!data.ok) {
        alert("Error al actualizar usuario: " + (data.msg || 'Error desconocido'));
        return;
      }

      alert("Usuario actualizado correctamente");

      // Actualizar la interfaz
      const fila = document.querySelector(`.fila-usuario[data-id="${usuarioEditandoId}"]`);
      if (fila) {
        fila.querySelector('.usuario').textContent = usuario;
        fila.querySelector('.nombre').textContent = nombre_usuario;
        
        // Actualizar estado
        const estadoSpan = fila.querySelector('.estado-td span');
        estadoSpan.textContent = estado;
        estadoSpan.className = estado === 'ACTIVO' ? 'estado-activo' : 'estado-inactivo';
        
        // Actualizar botones si el estado cambió
        actualizarBotonesEstado(fila, estado);
      }

      cerrarModal();
      aplicarFiltros(); // Re-aplicar filtros para actualizar contadores

    } catch (err) {
      console.error(err);
      alert("Error de conexión con el servidor");
    }
  }

  async function confirmarEliminacion() {
    if (!usuarioEliminarId) {
      alert("Error: No se encontró el usuario a eliminar.");
      return;
    }

    const usuarioAccion = 1; // Reemplaza esto con el ID del usuario logueado

    try {
      console.log("Intentando eliminar usuario ID:", usuarioEliminarId);
      
      const res = await fetch("/users/api/delete", {
        method: "POST",
        headers: { 
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: JSON.stringify({
          id: usuarioEliminarId,
          usuarioAccion: usuarioAccion
        })
      });

      console.log("Respuesta del servidor:", res.status, res.statusText);

      // Si la respuesta es 404, la ruta no existe
      if (res.status === 404) {
        throw new Error("La ruta de eliminación no existe en el servidor (404)");
      }

      // Si la respuesta no es JSON, hay un problema
      const contentType = res.headers.get("content-type");
      if (!contentType || !contentType.includes("application/json")) {
        const text = await res.text();
        console.error("Respuesta no JSON del servidor:", text);
        
        // Si llegamos aquí pero el usuario se eliminó, mostramos éxito
        if (res.status === 200) {
          eliminarFilaYMostrarExito();
          return;
        }
        throw new Error("El servidor respondió con un formato incorrecto");
      }

      const data = await res.json();
      
      if (!data.ok) {
        alert("Error al eliminar usuario: " + (data.msg || 'Error desconocido'));
        return;
      }

      // Éxito - eliminar fila y mostrar mensaje
      eliminarFilaYMostrarExito(data.msg);

    } catch (err) {
      console.error("Error completo:", err);
      
      // Verificar si el usuario fue eliminado a pesar del error
      const fila = document.querySelector(`.fila-usuario[data-id="${usuarioEliminarId}"]`);
      if (!fila) {
        // Si la fila ya no existe, significa que se eliminó exitosamente
        alert("Usuario eliminado correctamente");
        cerrarModalEliminar();
        actualizarContadores();
        return;
      }
      
      if (err.message.includes("404") || err.message.includes("ruta no existe")) {
        alert("Error: La funcionalidad de eliminar no está configurada en el servidor. Contacta al administrador.");
      } else if (err.message.includes("formato incorrecto")) {
        alert("Error: El servidor no respondió correctamente.");
      } else if (err.message.includes("Failed to fetch")) {
        alert("Error de conexión: No se pudo contactar al servidor.");
      } else {
        alert("Error al eliminar usuario: " + err.message);
      }
    }
  }

  // Función auxiliar para eliminar la fila y mostrar éxito
  function eliminarFilaYMostrarExito(mensaje = "Usuario eliminado correctamente") {
    const fila = document.querySelector(`.fila-usuario[data-id="${usuarioEliminarId}"]`);
    if (fila) {
      fila.remove();
    }
    
    alert(mensaje);
    cerrarModalEliminar();
    actualizarContadores();
  }

  async function cambiarEstadoUsuario(id, usuario, nuevoEstado) {
    const accion = nuevoEstado === 'ACTIVO' ? 'activar' : 'desactivar';
    
    if (!confirm(`¿Está seguro de que desea ${accion} al usuario ${usuario}?`)) {
      return;
    }

    const usuarioAccion = 1; // Reemplaza con el ID del usuario logueado

    try {
      const res = await fetch("/users/api/cambiar-estado", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id: id,
          estado: nuevoEstado,
          usuarioAccion: usuarioAccion
        })
      });

      const data = await res.json();
      if (!data.ok) {
        alert("Error al cambiar estado del usuario: " + (data.msg || 'Error desconocido'));
        return;
      }

      // Actualizar interfaz
      const filaActualizada = document.querySelector(`.fila-usuario[data-id="${id}"]`);
      if (filaActualizada) {
        const estadoSpan = filaActualizada.querySelector('.estado-td span');
        estadoSpan.textContent = nuevoEstado;
        estadoSpan.className = nuevoEstado === 'ACTIVO' ? 'estado-activo' : 'estado-inactivo';
        
        actualizarBotonesEstado(filaActualizada, nuevoEstado);
      }

      alert(data.msg || `Usuario ${usuario} ${accion}do exitosamente`);
      aplicarFiltros();

    } catch (err) {
      console.error(err);
      alert("Error de conexión con el servidor");
    }
  }

  function actualizarBotonesEstado(fila, estado) {
    const tdAcciones = fila.querySelector('.acciones-td');
    const id = fila.dataset.id;

    if (estado === 'ACTIVO') {
      tdAcciones.innerHTML = `
        <button class="btn-accion btn-editar" title="Editar usuario" data-id="${id}">
          <i class="fas fa-edit"></i> Editar
        </button>
        <button class="btn-accion btn-eliminar" title="Desactivar usuario" data-id="${id}">
          <i class="fas fa-user-slash"></i> Desactivar
        </button>
        <button class="btn-accion btn-eliminar-permanente" title="Eliminar usuario" data-id="${id}">
          <i class="fas fa-trash"></i> Eliminar
        </button>
      `;
    } else {
      tdAcciones.innerHTML = `
        <button class="btn-accion btn-editar" title="Editar usuario" data-id="${id}">
          <i class="fas fa-edit"></i> Editar
        </button>
        <button class="btn-accion btn-activar" title="Activar usuario" data-id="${id}">
          <i class="fas fa-user-check"></i> Activar
        </button>
        <button class="btn-accion btn-eliminar-permanente" title="Eliminar usuario" data-id="${id}">
          <i class="fas fa-trash"></i> Eliminar
        </button>
      `;
    }
  }

  function actualizarContadores() {
    const filasActuales = document.querySelectorAll('tbody tr.fila-usuario');
    const total = filasActuales.length;
    const mostrados = Array.from(filasActuales).filter(fila => 
      fila.style.display !== 'none'
    ).length;
    
    totalUsuarios.textContent = total;
    usuariosMostrados.textContent = mostrados;
    ultimaActualizacion.textContent = new Date().toLocaleString();
  }

  function cerrarModal() {
    modalUsuario.style.display = 'none';
    usuarioEditandoId = null;
    formUsuario.reset();
  }

  function cerrarModalEliminar() {
    modalEliminar.style.display = 'none';
    usuarioEliminarId = null;
  }

  // Funciones auxiliares para impresión
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
    const tablaClon = tabla.cloneNode(true);
    
    // Remover columna de acciones
    const filasTabla = tablaClon.querySelectorAll('tr');
    filasTabla.forEach(fila => {
      const celdas = fila.querySelectorAll('td, th');
      if (celdas.length > 4) {
        celdas[4].remove();
      }
    });
    
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
            h2 { font-family: "Times New Roman", Times, serif; text-align: center; margin: 20px 0; color: #2c3e50; }
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
            <strong>Total de usuarios:</strong> ${totalUsuarios.textContent}<br>
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