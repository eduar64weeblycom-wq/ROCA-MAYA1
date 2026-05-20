console.log("pacientes.js cargado (mejorado)");

document.addEventListener("DOMContentLoaded", () => {
  // Elementos principales
  const tabla = document.getElementById("pacientesTable");
  const tablaBody = document.getElementById("tablaBody");
  const formPaciente = document.getElementById("formPaciente");
  const modalPaciente = document.getElementById("modalPaciente");
  const idPacienteInput = document.getElementById("idPaciente");

  // Botones
  const btnNuevoPaciente = document.getElementById("btnNuevoPaciente");
  const btnImprimir = document.getElementById("btnImprimir");
  const btnCancelar = document.getElementById("btnCancelar");
  const logoBtn = document.getElementById("logoBtn");

  // Filtros
  const nombresFilter = document.getElementById("nombresFilter");
  const apellidosFilter = document.getElementById("apellidosFilter");
  const documentoFilter = document.getElementById("documentoFilter");
  const estadoFilter = document.getElementById("estadoFilter");
  const btnAplicarFiltros = document.getElementById("btnAplicarFiltros");
  const btnLimpiarFiltros = document.getElementById("btnLimpiarFiltros");

  // Contadores
  const totalPacientes = document.getElementById("totalPacientes");
  const pacientesMostrados = document.getElementById("pacientesMostrados");
  const ultimaActualizacion = document.getElementById("ultimaActualizacion");

  // Formulario modal
  const nombresInput = document.getElementById("nombres");
  const apellidosInput = document.getElementById("apellidos");
  const fechaNacimientoInput = document.getElementById("fechaNacimiento");
  const generoSelect = document.getElementById("genero");
  const estadoCivilSelect = document.getElementById("estadoCivil");
  const ocupacionInput = document.getElementById("ocupacion");
  const direccionInput = document.getElementById("direccion");
  const telefonoInput = document.getElementById("telefono");
  const correoInput = document.getElementById("correo");
  const tipoDocumentoSelect = document.getElementById("tipoDocumento");
  const numeroDocumentoInput = document.getElementById("numeroDocumento");
  const rtnInput = document.getElementById("rtn");
  const nombreContactoEmergenciaInput = document.getElementById(
    "nombreContactoEmergencia"
  );
  const telefonoContactoEmergenciaInput = document.getElementById(
    "telefonoContactoEmergencia"
  );
  const parentescoContactoEmergenciaInput = document.getElementById(
    "parentescoContactoEmergencia"
  );
  const estadoSelect = document.getElementById("estado");
  const edadCalculadaSpan = document.getElementById("edadCalculada");

  // Loading overlay
  const loadingEl = document.getElementById("loading");

  function setLoading(show, text) {
    if (!loadingEl) return;
    loadingEl.style.display = show ? "flex" : "none";
    if (show)
      loadingEl.querySelector("div").textContent = text || "Procesando...";
  }

  // Estado de filtros
  let filtrosActivos = {
    nombres: "",
    apellidos: "",
    documento: "",
    estado: "",
  };

  // ========================
  // VALIDACIONES EN TIEMPO REAL
  // ========================

  function limpiarSoloLetras(valor, max) {
    // letras, espacios y tildes
    let limpio = valor.normalize("NFD").replace(/[^a-zA-ZñÑáéíóúÁÉÍÓÚ\s]/g, "");
    if (max) limpio = limpio.slice(0, max);
    return limpio;
  }

  function limpiarSoloNumeros(valor, max) {
    let limpio = valor.replace(/\D/g, "");
    if (max) limpio = limpio.slice(0, max);
    return limpio;
  }

  function esEmailValido(email) {
    if (!email) return true; // no obligatorio
    const re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return re.test(String(email).toLowerCase());
  }

  function mostrarFieldError(inputEl, mensaje) {
    if (!inputEl) return;
    // crear span si no existe
    let span = inputEl.parentNode.querySelector(".field-error");
    if (!span) {
      span = document.createElement("div");
      span.className = "field-error";
      span.style.color = "#b91c1c";
      span.style.fontSize = "12px";
      span.style.marginTop = "6px";
      inputEl.parentNode.appendChild(span);
    }
    span.textContent = mensaje;
    inputEl.classList.add("input-error");
  }

  function limpiarFieldError(inputEl) {
    if (!inputEl) return;
    const span = inputEl.parentNode.querySelector(".field-error");
    if (span) span.remove();
    inputEl.classList.remove("input-error");
  }

  function configurarValidaciones() {
    // Solo letras con límite
    [
      { input: nombresInput, max: 60 },
      { input: apellidosInput, max: 60 },
      { input: ocupacionInput, max: 20 },
      { input: parentescoContactoEmergenciaInput, max: 15 },
    ].forEach(({ input, max }) => {
      if (!input) return;
      input.addEventListener("input", (e) => {
        const valorLimpio = limpiarSoloLetras(e.target.value, max);
        if (e.target.value !== valorLimpio) {
          e.target.value = valorLimpio;
        }
        limpiarFieldError(e.target);
      });
      input.addEventListener("blur", (e) => {
        if (e.target.value.trim() === "") {
          // no mostrar error por estar vacío si no es obligatorio aquí (se valida al submit)
          limpiarFieldError(e.target);
        }
      });
    });

    // Solo números con límite
    [
      { input: telefonoInput, max: 15 },
      { input: numeroDocumentoInput, max: 13 },
      { input: rtnInput, max: 14 },
      { input: telefonoContactoEmergenciaInput, max: 15 },
    ].forEach(({ input, max }) => {
      if (!input) return;
      input.addEventListener("input", (e) => {
        const valorLimpio = limpiarSoloNumeros(e.target.value, max);
        if (e.target.value !== valorLimpio) {
          e.target.value = valorLimpio;
        }
        limpiarFieldError(e.target);
      });
    });

    // Dirección: solo limitar longitud (ya tiene maxlength=40)
    if (direccionInput) {
      direccionInput.addEventListener("input", (e) => {
        if (e.target.value.length > 40) {
          e.target.value = e.target.value.slice(0, 40);
        }
        limpiarFieldError(e.target);
      });
    }

    // Correo: limitar longitud a 30 y validar formato al blur
    if (correoInput) {
      correoInput.addEventListener("input", (e) => {
        if (e.target.value.length > 30) {
          e.target.value = e.target.value.slice(0, 30);
        }
        limpiarFieldError(e.target);
      });
      correoInput.addEventListener("blur", (e) => {
        if (e.target.value && !esEmailValido(e.target.value)) {
          mostrarFieldError(e.target, "Formato de correo inválido");
        } else {
          limpiarFieldError(e.target);
        }
      });
    }
  }

  configurarValidaciones();

  // ========================
  // Utilidades
  // ========================

  function calcularEdad(fechaNacimiento) {
    if (!fechaNacimiento) return "";
    const nacimiento = new Date(fechaNacimiento);
    if (isNaN(nacimiento)) return "";

    const hoy = new Date();
    let edad = hoy.getFullYear() - nacimiento.getFullYear();
    const mes = hoy.getMonth() - nacimiento.getMonth();

    if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
      edad--;
    }

    return `${edad} años`;
  }

  function actualizarContadores() {
    const filas = document.querySelectorAll(".fila-paciente");
    const visibles = Array.from(filas).filter(
      (f) => f.style.display !== "none"
    );
    if (totalPacientes) totalPacientes.textContent = filas.length;
    if (pacientesMostrados) pacientesMostrados.textContent = visibles.length;
    if (ultimaActualizacion) {
      ultimaActualizacion.textContent = new Date().toLocaleString();
    }
  }

  // Mensajes toast simples (success / error)
  function showToast(type, message, ms = 3500) {
    const toast = document.createElement("div");
    toast.className = `pm-toast pm-toast-${type}`;
    toast.style.position = "fixed";
    toast.style.right = "20px";
    toast.style.bottom = "20px";
    toast.style.background = type === "error" ? "#b91c1c" : "#059669";
    toast.style.color = "white";
    toast.style.padding = "10px 14px";
    toast.style.borderRadius = "8px";
    toast.style.boxShadow = "0 6px 18px rgba(0,0,0,0.15)";
    toast.style.zIndex = 2000;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
      toast.style.transition = "opacity 250ms";
      toast.style.opacity = 0;
      setTimeout(() => toast.remove(), 300);
    }, ms);
  }

  // ========================
  // Filtros
  // ========================

  function aplicarFiltros() {
    const filas = document.querySelectorAll(".fila-paciente");
    let contadorMostrados = 0;

    filas.forEach((fila) => {
      const nombres = fila.querySelector(".nombres").textContent.toLowerCase();
      const apellidos = fila
        .querySelector(".apellidos")
        .textContent.toLowerCase();
      const documento = fila
        .querySelector(".documento")
        .textContent.toLowerCase();
      const estado = fila.querySelector(".estado-td span").textContent;

      const coincideNombres = nombres.includes(
        filtrosActivos.nombres.toLowerCase()
      );
      const coincideApellidos = apellidos.includes(
        filtrosActivos.apellidos.toLowerCase()
      );
      const coincideDocumento = documento.includes(
        filtrosActivos.documento.toLowerCase()
      );
      const coincideEstado =
        !filtrosActivos.estado || estado === filtrosActivos.estado;

      if (
        coincideNombres &&
        coincideApellidos &&
        coincideDocumento &&
        coincideEstado
      ) {
        fila.style.display = "";
        contadorMostrados++;
      } else {
        fila.style.display = "none";
      }
    });

    if (pacientesMostrados) pacientesMostrados.textContent = contadorMostrados;

    // Mensaje "sin resultados" cuando se aplican filtros
    let noResults = document.querySelector(".no-results-message");
    if (contadorMostrados === 0) {
      if (!noResults) {
        const tr = document.createElement("tr");
        tr.innerHTML =
          '<td colspan="9" class="no-results no-results-message">No se encontraron pacientes con los filtros aplicados.</td>';
        tablaBody.appendChild(tr);
      }
    } else if (noResults) {
      noResults.remove();
    }
  }

  function limpiarFiltros() {
    if (nombresFilter) nombresFilter.value = "";
    if (apellidosFilter) apellidosFilter.value = "";
    if (documentoFilter) documentoFilter.value = "";
    if (estadoFilter) estadoFilter.value = "";

    filtrosActivos = { nombres: "", apellidos: "", documento: "", estado: "" };
    aplicarFiltros();
    actualizarContadores();
  }

  // ========================
  // Modal
  // ========================

  function abrirModalNuevo() {
    const titulo = document.getElementById("modalTitulo");
    if (titulo) titulo.textContent = "Nuevo Paciente";
    formPaciente.reset();
    idPacienteInput.value = "";
    if (edadCalculadaSpan) edadCalculadaSpan.textContent = "";
    // limpiar errores
    Array.from(formPaciente.querySelectorAll(".input-error")).forEach((el) =>
      el.classList.remove("input-error")
    );
    Array.from(formPaciente.querySelectorAll(".field-error")).forEach((el) =>
      el.remove()
    );
    modalPaciente.style.display = "block";
  }

  async function abrirModalEditar(id) {
    try {
      setLoading(true, "Cargando paciente...");
      const resp = await fetch(`/pacientes/api/${id}`);
      const data = await resp.json();
      setLoading(false);

      if (!data.success) {
        showToast("error", data.message || "Error al cargar paciente");
        return;
      }

      const paciente = data.data;
      idPacienteInput.value = paciente.ID_PACIENTE;

      nombresInput.value = paciente.NOMBRES || "";
      apellidosInput.value = paciente.APELLIDOS || "";

      if (paciente.FECHA_NACIMIENTO) {
        const fecha = new Date(paciente.FECHA_NACIMIENTO);
        const iso = !isNaN(fecha)
          ? fecha.toISOString().split("T")[0]
          : String(paciente.FECHA_NACIMIENTO).split("T")[0];
        fechaNacimientoInput.value = iso;
        edadCalculadaSpan.textContent = calcularEdad(iso);
      } else {
        fechaNacimientoInput.value = "";
        edadCalculadaSpan.textContent = "";
      }

      generoSelect.value = paciente.GENERO || "MASCULINO";
      estadoCivilSelect.value = paciente.ESTADO_CIVIL || "SOLTERO";
      ocupacionInput.value = paciente.OCUPACION || "";
      direccionInput.value = paciente.DIRECCION || "";
      telefonoInput.value = paciente.TELEFONO || "";
      correoInput.value = paciente.CORREO_ELECTRONICO || "";
      tipoDocumentoSelect.value = paciente.TIPO_DOCUMENTO_IDENTIDAD || "DNI";
      numeroDocumentoInput.value = paciente.NUMERO_DOCUMENTO_IDENTIDAD || "";
      rtnInput.value = paciente.RTN_PACIENTE || "";
      nombreContactoEmergenciaInput.value =
        paciente.NOMBRE_CONTACTO_EMERGENCIA || "";
      telefonoContactoEmergenciaInput.value =
        paciente.TELEFONO_CONTACTO_EMERGENCIA || "";
      parentescoContactoEmergenciaInput.value =
        paciente.PARENTESCO_CONTACTO_EMERGENCIA || "";
      estadoSelect.value = paciente.ESTADO || "ACTIVO";

      const titulo = document.getElementById("modalTitulo");
      if (titulo) titulo.textContent = "Editar Paciente";
      modalPaciente.style.display = "block";
    } catch (err) {
      setLoading(false);
      console.error("Error al cargar paciente:", err);
      showToast("error", "Error al cargar datos del paciente");
    }
  }

  function cerrarModal() {
    modalPaciente.style.display = "none";
    idPacienteInput.value = "";
  }

  // ========================
  // Guardar / Eliminar (API)
  // ========================

  function validarFormulario() {
    // Limpieza previa de errores
    Array.from(formPaciente.querySelectorAll(".field-error")).forEach((el) =>
      el.remove()
    );
    Array.from(formPaciente.querySelectorAll(".input-error")).forEach((el) =>
      el.classList.remove("input-error")
    );

    // Campos obligatorios: NOMBRES, APELLIDOS, NUMERO_DOCUMENTO_IDENTIDAD
    if (!nombresInput.value.trim()) {
      mostrarFieldError(nombresInput, "Nombres es obligatorio");
    }
    if (!apellidosInput.value.trim()) {
      mostrarFieldError(apellidosInput, "Apellidos es obligatorio");
    }
    if (!numeroDocumentoInput.value.trim()) {
      mostrarFieldError(
        numeroDocumentoInput,
        "Número de documento es obligatorio"
      );
    }

    // Email validation
    if (correoInput.value && !esEmailValido(correoInput.value)) {
      mostrarFieldError(correoInput, "Correo electrónico inválido");
    }

    // Phone minimum length suggestion (if provided)
    if (telefonoInput.value && telefonoInput.value.length < 7) {
      mostrarFieldError(telefonoInput, "Teléfono demasiado corto");
    }

    // After marking, check if any .field-error exists
    const anyError = formPaciente.querySelector(".field-error");
    return !anyError;
  }

  async function guardarPacienteAPI(datos) {
    // validate client-side before calling API
    if (!validarFormulario()) {
      showToast("error", "Por favor corrija los campos en rojo");
      return;
    }

    const id = idPacienteInput.value;
    const url = id ? `/pacientes/api/${id}` : "/pacientes/api";
    const method = id ? "PUT" : "POST";

    try {
      setLoading(true, id ? "Actualizando paciente..." : "Creando paciente...");
      const resp = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(datos),
      });

      const data = await resp.json();
      setLoading(false);

      if (!data.success) {
        showToast("error", data.message || "Error al guardar paciente");
        // If server returned field-specific errors in a predictable shape, you could map them here.
        return;
      }

      showToast(
        "success",
        `Paciente ${id ? "actualizado" : "creado"} exitosamente`
      );
      cerrarModal();

      // Mejor UX: actualizar la tabla sin recargar (opcional). Aquí haremos recarga simple.
      // Si quieres, puedo cambiar esto por un update-in-place.
      setTimeout(() => location.reload(), 700);
    } catch (err) {
      setLoading(false);
      console.error("Error al guardar paciente:", err);
      showToast("error", "Error al guardar paciente");
    }
  }

  async function eliminarPacienteAPI(id, nombres, apellidos) {
    if (
      !confirm(
        `¿Está seguro de que desea eliminar al paciente ${nombres} ${apellidos}?`
      )
    ) {
      return;
    }

    try {
      setLoading(true, "Eliminando paciente...");
      const resp = await fetch(`/pacientes/api/${id}`, { method: "DELETE" });
      const data = await resp.json();
      setLoading(false);

      if (!data.success) {
        showToast("error", data.message || "Error al eliminar paciente");
        return;
      }

      showToast("success", "Paciente eliminado exitosamente");
      setTimeout(() => location.reload(), 600);
    } catch (err) {
      setLoading(false);
      console.error("Error al eliminar paciente:", err);
      showToast("error", "Error al eliminar paciente");
    }
  }

  // ========================
  // PDF (Impresión)
  // ========================

  async function imageToBase64(url) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.crossOrigin = "Anonymous";
      img.onload = function () {
        const canvas = document.createElement("canvas");
        const ctx = canvas.getContext("2d");
        canvas.width = img.width;
        canvas.height = img.height;
        ctx.drawImage(img, 0, 0);
        resolve(canvas.toDataURL("image/png"));
      };
      img.onerror = reject;
      img.src = url;
    });
  }

  async function generarVentanaImpresion(logoBase64) {
    const tabla = document.getElementById("pacientesTable");
    if (!tabla) {
      showToast("error", "No se encontró la tabla de pacientes.");
      return;
    }

    const ventana = window.open("", "", "width=900,height=700");

    // Clonar tabla para no tocar la original
    const tablaClon = tabla.cloneNode(true);

    // Quitar columna de ACCIONES (última columna)
    const filasTabla = tablaClon.querySelectorAll("tr");
    filasTabla.forEach((fila) => {
      const celdas = fila.querySelectorAll("td, th");
      if (celdas.length > 8) {
        celdas[8].remove();
      }
    });

    const totalPacientesSpan = document.getElementById("totalPacientes");
    const totalTexto = totalPacientesSpan ? totalPacientesSpan.textContent : "";

    ventana.document.write(`
      <html>
        <head>
          <title>Pacientes - Clínicas Roca Maya</title>
          <style>
            body { font-family: "Times New Roman", Times, serif; padding: 20px; margin: 0; }
            .header { display:flex; align-items:center; margin-bottom:20px; border-bottom:2px solid #333; padding-bottom:15px; }
            .logo { height:80px; margin-right:20px; max-width:200px; object-fit:contain; }
            .logo-placeholder { height:80px; width:200px; background:#f0f0f0; border:2px dashed #ccc; display:flex; align-items:center; justify-content:center; margin-right:20px; color:#666; font-size:12px; text-align:center; }
            .company-info { flex:1; }
            .company-name { font-size:20px; font-weight:bold; color:#333; margin-bottom:5px; }
            .company-slogan { font-size:14px; color:#666; font-style:italic; }
            table { width:100%; border-collapse:collapse; font-family:"Times New Roman", Times, serif; margin-top:20px; }
            th, td { border:1px solid #ccc; padding:8px; text-align:left; font-size:12px; }
            th { background:#f3f3f3; font-weight:bold; }
            h2 { font-family:"Times New Roman", Times, serif; text-align:center; margin:20px 0; color:#2c3e50; }
          </style>
        </head>
        <body>
          <div class="header">
            ${
              logoBase64
                ? `<img src="${logoBase64}" alt="Clínicas Roca Maya" class="logo">`
                : '<div class="logo-placeholder">Logo no disponible</div>'
            }
            <div class="company-info">
                <div class="company-name">Clínicas Médicas Roca Maya</div>
                <div class="company-slogan">Tu salud es nuestra seguridad</div>
            </div>
          </div>
          <h2>Lista de Pacientes</h2>
          ${tablaClon.outerHTML}
          <div style="margin-top:20px; font-size:12px; text-align:right;">
            <strong>Total de pacientes:</strong> ${totalTexto}<br>
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

  // ========================
  // Event Listeners
  // ========================

  if (btnAplicarFiltros) {
    btnAplicarFiltros.addEventListener("click", () => {
      filtrosActivos.nombres = nombresFilter ? nombresFilter.value : "";
      filtrosActivos.apellidos = apellidosFilter ? apellidosFilter.value : "";
      filtrosActivos.documento = documentoFilter ? documentoFilter.value : "";
      filtrosActivos.estado = estadoFilter ? estadoFilter.value : "";
      aplicarFiltros();
      actualizarContadores();
    });
  }

  if (btnLimpiarFiltros)
    btnLimpiarFiltros.addEventListener("click", limpiarFiltros);
  if (btnNuevoPaciente)
    btnNuevoPaciente.addEventListener("click", abrirModalNuevo);

  // NOTE: we use the stable print listener (generarVentanaImpresion via imageToBase64) and avoid duplicate handlers
  if (btnImprimir) {
    btnImprimir.addEventListener("click", async () => {
      try {
        setLoading(true, "Preparando impresión...");
        const logoBase64 = await imageToBase64("/roca-maya-oct.jpg");
        setLoading(false);
        generarVentanaImpresion(logoBase64);
      } catch (error) {
        setLoading(false);
        console.log("No se pudo cargar el logo, usando versión sin logo");
        generarVentanaImpresion(null);
      }
    });
  }

  if (btnCancelar) btnCancelar.addEventListener("click", cerrarModal);

  if (logoBtn) {
    logoBtn.addEventListener("click", () => {
      window.location.href = "/dashboard";
    });
  }

  if (fechaNacimientoInput) {
    fechaNacimientoInput.addEventListener("change", function () {
      if (edadCalculadaSpan)
        edadCalculadaSpan.textContent = calcularEdad(this.value);
    });
  }

  // Submit form
  if (formPaciente) {
    formPaciente.addEventListener("submit", function (e) {
      e.preventDefault();

      // build datosPaciente from form (trim values)
      const datosPaciente = {
        NOMBRES: nombresInput.value.trim(),
        APELLIDOS: apellidosInput.value.trim(),
        FECHA_NACIMIENTO: fechaNacimientoInput.value || null,
        GENERO: generoSelect.value,
        DIRECCION: direccionInput.value.trim() || null,
        TELEFONO: telefonoInput.value.trim() || null,
        CORREO_ELECTRONICO: correoInput.value.trim() || null,
        TIPO_DOCUMENTO_IDENTIDAD: tipoDocumentoSelect.value,
        NUMERO_DOCUMENTO_IDENTIDAD: numeroDocumentoInput.value.trim(),
        RTN_PACIENTE: rtnInput.value.trim() || null,
        ESTADO_CIVIL: estadoCivilSelect.value,
        OCUPACION: ocupacionInput.value.trim() || null,
        NOMBRE_CONTACTO_EMERGENCIA:
          nombreContactoEmergenciaInput.value.trim() || null,
        TELEFONO_CONTACTO_EMERGENCIA:
          telefonoContactoEmergenciaInput.value.trim() || null,
        PARENTESCO_CONTACTO_EMERGENCIA:
          parentescoContactoEmergenciaInput.value.trim() || null,
        ESTADO: estadoSelect.value,
      };

      // Additional convenience: if some important fields missing, show helpful message
      const missing = [];
      if (!datosPaciente.NOMBRES) missing.push("Nombres");
      if (!datosPaciente.APELLIDOS) missing.push("Apellidos");
      if (!datosPaciente.NUMERO_DOCUMENTO_IDENTIDAD)
        missing.push("Número de documento");

      if (missing.length > 0) {
        showToast(
          "error",
          `Complete los campos obligatorios: ${missing.join(", ")}`
        );
        // Also trigger validation UI
        validarFormulario();
        return;
      }

      // All good -> call API
      guardarPacienteAPI(datosPaciente);
    });
  }

  // Table actions (edit / delete) via delegation
  if (tablaBody) {
    tablaBody.addEventListener("click", function (e) {
      const target = e.target;
      const btnEditar = target.closest(".btn-editar");
      const btnEliminar = target.closest(".btn-eliminar");

      if (btnEditar) {
        const fila = btnEditar.closest(".fila-paciente");
        const id = parseInt(fila.getAttribute("data-id"));
        abrirModalEditar(id);
      }

      if (btnEliminar) {
        const fila = btnEliminar.closest(".fila-paciente");
        const id = parseInt(fila.getAttribute("data-id"));
        const nombres = fila.querySelector(".nombres").textContent;
        const apellidos = fila.querySelector(".apellidos").textContent;
        eliminarPacienteAPI(id, nombres, apellidos);
      }
    });
  }

  window.addEventListener("click", function (e) {
    if (e.target === modalPaciente) {
      cerrarModal();
    }
  });

  // Inicializar contadores
  actualizarContadores();
});
