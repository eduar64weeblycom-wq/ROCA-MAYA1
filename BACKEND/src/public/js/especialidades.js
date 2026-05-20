(() => {
    let especialidadesData = [];
    let currentEspecialidadId = null;
    const $ = (id) => document.getElementById(id);
    const LOGO_URL = "/img/logo-roca-maya.png"; // RUTA DEL LOGO ACTUALIZADA

    // Lista de iconos disponibles para el selector
    const ICONOS_DISPONIBLES = [
        "fas fa-stethoscope",
        "fas fa-user-md",
        "fas fa-heartbeat",
        "fas fa-tooth",
        "fas fa-x-ray",
        "fas fa-brain",
        "fas fa-pills",
        "fas fa-syringe",
        "fas fa-hospital",
        "fas fa-wheelchair"
    ];

    /* ---------- Helpers de Impresión Nativa ---------- */

    function imageToBase64(url) {
        return new Promise((resolve, reject) => {
            const img = new Image();
            // Esto permite cargar imágenes del mismo origen o con encabezados CORS.
            // Si el logo está en el mismo dominio, funciona bien.
            img.crossOrigin = 'Anonymous'; 
            img.onload = function() {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                canvas.width = img.width;
                canvas.height = img.height;
                ctx.drawImage(img, 0, 0);
                resolve(canvas.toDataURL('image/png'));
            };
            img.onerror = () => reject(new Error(`Fallo al cargar la imagen: ${url}`));
            img.src = url;
        });
    }

    
    // Corregida para aceptar el HTML de la tabla
    function generarVentanaImpresion(logoBase64, tablaHtml) {
        const ventana = window.open('', '', 'width=900,height=700');

        // ✅ CORRECCIÓN 1: Se añade el enlace a Font Awesome CDN
        const fontAwesomeLink = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />';

        ventana.document.write(`
            <html>
                <head>
                    <title>Reporte de Especialidades - Roca Maya</title>
                    ${fontAwesomeLink} <style>
                        body { 
                            font-family: "Times New Roman", Times, serif; 
                            padding: 20px;
                            margin: 0;
                        }
                        .header {
                            display: flex;
                            align-items: center;
                            margin-bottom: 20px;
                            border-bottom: 2px solid #333;
                            padding-bottom: 15px;
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
                            background: #f0f0f0;
                            border: 2px dashed #ccc;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            margin-right: 20px;
                            color: #666;
                            font-size: 12px;
                            text-align: center;
                        }
                        .company-info {
                            flex: 1;
                        }
                        .company-name {
                            font-size: 20px;
                            font-weight: bold;
                            color: #333;
                            margin-bottom: 5px;
                        }
                        .company-slogan {
                            font-size: 14px;
                            color: #666;
                            font-style: italic;
                        }
                        table { 
                            width: 100%; 
                            border-collapse: collapse;
                            font-family: "Times New Roman", Times, serif;
                            margin-top: 20px;
                        }
                        th, td { 
                            border: 1px solid #ccc; 
                            padding: 8px; 
                            text-align: left; 
                            font-size: 12px;
                        }
                        th { 
                            background: #f3f3f3; 
                            font-weight: bold;
                        }
                        h2 {
                            font-family: "Times New Roman", Times, serif;
                            text-align: center;
                            margin: 20px 0;
                            color: #2c3e50;
                        }
                        /* Estilos para impresión de la tabla de especialidades */
                        .estado-col.success { color: green; font-weight: bold; }
                        .estado-col.error { color: red; font-weight: bold; }

                        @media print {
                            .header { break-after: avoid; }
                            table { break-inside: auto; }
                            tr { break-inside: avoid; break-after: auto; }
                        }
                    </style>
                </head>
                <body>
                    <div class="header">
                        ${logoBase64 ?
                            `<img src="${logoBase64}" alt="Clínicas Roca Maya" class="logo">` :
                            '<div class="logo-placeholder">Logo no disponible</div>'
                        }
                        <div class="company-info">
                            <div class="company-name">Clínicas Médicas Roca Maya</div>
                            <div class="company-slogan">Tu salud es nuestra seguridad</div>
                        </div>
                    </div>
                    <h2>Reporte de Especialidades Registradas</h2>
                    ${tablaHtml}
                </body>
            </html>
        `);
        ventana.document.close();

        // Esperar brevemente para asegurar que el contenido se ha renderizado antes de imprimir
        setTimeout(() => {
            ventana.print();
        }, 500);
    }

    // Nueva función para generar el HTML de la tabla SIN la columna de Acciones
    function generarTablaHtmlParaImpresion(list) {
        if (!list || list.length === 0) {
            return `<p style="text-align:center;">No hay especialidades registradas para imprimir.</p>`;
        }

        // 1. Encabezados sin "Acciones"
        const header = `
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Color/Icono</th>
                    <th>Estado</th>
                </tr>
            </thead>
        `;
        
        // 2. Cuerpo de la tabla sin la columna de botones
        const body = list.map(e => {
            const estadoClass = e.ESTADO === 'ACTIVA' ? 'success' : 'error';
            const iconoHtml = `<i class="${e.ICONO || 'fas fa-stethoscope'}"></i>`;
            const colorStyle = `style="background-color: ${e.COLOR_HEXADECIMAL || '#3498DB'}; color:#fff; padding:2px 8px; border-radius:5px; font-weight:bold;"`;
            
            return `<tr>
                <td>${e.ID_ESPECIALIDAD}</td>
                <td><strong>${e.NOMBRE_ESPECIALIDAD}</strong></td>
                <td>${e.DESCRIPCION || '-'}</td>
                <td><span ${colorStyle}>${iconoHtml}</span></td>
                <td class="estado-col ${estadoClass}">${e.ESTADO}</td>
            </tr>`;
        }).join('');

        // Devolvemos la tabla completa
        return `<table id="especialidadesTablePrint">${header}<tbody>${body}</tbody></table>`;
    }

    /* ---------- Carga de datos ---------- */
    async function cargarDatosReales() {
        try {
            const res = await fetch("/especialidades/api/datos");
            if (!res.ok) throw new Error("HTTP " + res.status);
            const json = await res.json();
            especialidadesData = json.especialidades || [];
            aplicarFiltros(); // Mostrar tabla filtrada (inicialmente todos)
        } catch (err) {
            console.error("Error cargando datos:", err);
            mostrarMensaje("error", "Error cargando datos: " + err.message);
        }
    }

    /* ---------- Render tabla (para la vista principal con acciones) ---------- */
    function mostrarEspecialidades(list) {
        const tbody = $("tablaBody");
        if (!tbody) return;

        if (!list || list.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="no-results no-results-message" style="text-align:center;">
                        <i class="fas fa-microscope"></i> No se encontraron especialidades registradas
                    </td>
                </tr>`;
            $("registrosMostrados").textContent = 0;
            $("totalRegistros").textContent = especialidadesData.length;
            $("ultimaActualizacion").textContent = new Date().toLocaleString();
            return;
        }

        tbody.innerHTML = list.map(e => {
            const estadoClass = e.ESTADO === 'ACTIVA' ? 'success' : 'error';
            const iconoHtml = `<i class="${e.ICONO || 'fas fa-stethoscope'}"></i>`;
            const colorStyle = `style="background-color: ${e.COLOR_HEXADECIMAL || '#3498DB'}; color:#fff; padding:2px 8px; border-radius:5px; font-weight:bold;"`;

            // Nota: Aquí se incluye la columna de acciones para la vista web
            return `<tr data-id="${e.ID_ESPECIALIDAD}">
                <td>${e.ID_ESPECIALIDAD}</td>
                <td><strong>${e.NOMBRE_ESPECIALIDAD}</strong></td>
                <td>${e.DESCRIPCION || '-'}</td>
                <td><span ${colorStyle}>${iconoHtml}</span></td>
                <td class="estado-col ${estadoClass}">${e.ESTADO}</td>
                <td class="acciones-col">${generarBotonesAccion(e)}</td>
            </tr>`;
        }).join('');

        $("registrosMostrados").textContent = list.length;
        $("totalRegistros").textContent = especialidadesData.length;
        $("ultimaActualizacion").textContent = new Date().toLocaleString();
    }

    function generarBotonesAccion(e) {
        const id = e.ID_ESPECIALIDAD;
        const s = e.ESTADO;
        const botones = [];

        botones.push(
            `<button class="btn-accion edit" data-action="editar" data-id="${id}" title="Editar"><i class="fas fa-pen"></i></button>`
        );

        if (s === "ACTIVA") {
            botones.push(
                `<button class="btn-accion delete" data-action="inactivar" data-id="${id}" title="Inactivar"><i class="fas fa-toggle-off"></i></button>`
            );
        } else {
            botones.push(
                `<button class="btn-accion success" data-action="activar" data-id="${id}" title="Activar"><i class="fas fa-toggle-on"></i></button>`
            );
        }
        botones.push(
            `<button class="btn-accion delete" data-action="eliminar" data-id="${id}" title="Eliminar"><i class="fas fa-trash"></i></button>`
        );

        return `<div class="acciones">${botones.join("")}</div>`;
    }

    /* ---------- Filtros ---------- */
    function aplicarFiltros() {
        const nombre = $("filterNombre")?.value.trim().toLowerCase() || "";
        const estado = $("filterEstado")?.value || "";

        const filtrados = especialidadesData.filter(e => {
            const matchNombre = e.NOMBRE_ESPECIALIDAD.toLowerCase().includes(nombre);
            const matchEstado = estado ? e.ESTADO === estado : true;
            return matchNombre && matchEstado;
        });

        mostrarEspecialidades(filtrados);
    }

    /* ---------- Tabla acciones ---------- */
    function tablaClickHandler(e) {
        const btn = e.target.closest(".btn-accion");
        if (!btn) return;
        const action = btn.dataset.action;
        const id = btn.dataset.id;

        if (action === "editar") {
            const especialidad = especialidadesData.find(d => String(d.ID_ESPECIALIDAD) === id);
            if (especialidad) abrirModalEspecialidad("editar", especialidad);
            return;
        }

        if (action === "eliminar") {
            // Nota: En un entorno real se usaría un modal personalizado en lugar de confirm()
            if (!confirm(`⚠️ ¿Seguro que deseas eliminar permanentemente la especialidad ${id}? Esta acción NO se puede deshacer.`)) return;
            eliminarEspecialidad(id);
            return;
        }

        if (action === "inactivar" || action === "activar") {
            const nuevoEstado = action === "activar" ? "ACTIVA" : "INACTIVA";
            const nombreAccion = action === "activar" ? 'ACTIVAR' : 'INACTIVAR';
            // Nota: En un entorno real se usaría un modal personalizado en lugar de confirm()
            if (!confirm(`¿Deseas ${nombreAccion} la especialidad ${id}?`)) return;

            btn.disabled = true;
            cambiarEstadoEspecialidad(id, nuevoEstado, btn);
        }
    }

    async function cambiarEstadoEspecialidad(idEspecialidad, nuevoEstado, btn) {
        try {
            const res = await fetch("/especialidades/cambiar-estado", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ idEspecialidad, nuevoEstado }),
            });

            const j = await res.json().catch(() => null);
            if (!res.ok || (j && !j.success)) {
                const msg = (j && j.message) || `Error ${res.status}`;
                mostrarMensaje("error", `Fallo al cambiar estado: ${msg}`);
                return;
            }

            await cargarDatosReales();
            mostrarMensaje("success", (j && j.message) || `Estado actualizado a ${nuevoEstado}`);
        } catch (err) {
            console.error("Error cambiarEstadoEspecialidad:", err);
            mostrarMensaje("error", "Error de conexión al cambiar estado.");
        } finally {
            if (btn) btn.disabled = false;
        }
    }

    /* ---------- Modal ---------- */
    function abrirModalEspecialidad(modo, especialidad = {}) {
        const modal = $("modalEspecialidad");
        if (!modal) return;
        const isNew = modo === "nueva";
        currentEspecialidadId = isNew ? null : especialidad.ID_ESPECIALIDAD;

        $("modalTitle").textContent = isNew ? "Nueva Especialidad" : "Editar Especialidad";
        $("inputNombre").value = especialidad.NOMBRE_ESPECIALIDAD || "";
        $("textareaDescripcion").value = especialidad.DESCRIPCION || "";
        $("inputColor").value = especialidad.COLOR_HEXADECIMAL || "#3498DB";
        $("inputIcono").value = especialidad.ICONO || "fas fa-stethoscope";
        $("modalGuardarBtn").textContent = isNew ? "Guardar" : "Actualizar";

        const estadoGroup = $("estadoGroup");
        if (estadoGroup) {
            estadoGroup.style.display = isNew ? "none" : "block";
            if (!isNew) $("selectEstado").value = especialidad.ESTADO || "ACTIVA";
        }

        actualizarPreview();
        mostrarErrorModal("");
        modal.style.display = "flex";
        renderIconos(); // Render iconos al abrir modal
    }

    function cerrarModalEspecialidad() {
        const modal = $("modalEspecialidad");
        if (modal) modal.style.display = "none";
        const form = $("formEspecialidad");
        if (form) form.reset();
        currentEspecialidadId = null;
        mostrarErrorModal("");
    }

    function actualizarPreview() {
        const icono = $("inputIcono")?.value || 'fas fa-stethoscope';
        const color = $("inputColor")?.value || '#3498DB';
        const preview = $("previewIcono");

        if (preview) {
            preview.style.backgroundColor = color;
            preview.innerHTML = `<i class="${icono}"></i>`;
        }
    }

    /* ---------- Selector de iconos ---------- */
    const iconInput = $("inputIcono");
    const iconList = $("iconList");

    function renderIconos(filter = "") {
        if (!iconList) return;
        iconList.innerHTML = "";
        ICONOS_DISPONIBLES
            .filter(ic => ic.includes(filter))
            .forEach(ic => {
                const iElem = document.createElement("i");
                iElem.className = ic;
                iElem.style.fontSize = "20px";
                iElem.style.padding = "5px";
                iElem.style.cursor = "pointer";
                iElem.style.borderRadius = "4px";
                iElem.addEventListener("click", () => {
                    if (iconInput) iconInput.value = ic;
                    actualizarPreview();
                });
                iconList.appendChild(iElem);
            });
    }

    if (iconInput) {
        iconInput.addEventListener("input", () => renderIconos(iconInput.value));
    }

    /* ---------- Guardar / Actualizar ---------- */
    async function guardarEspecialidadHandler(e) {
        e.preventDefault();
        const isNew = currentEspecialidadId === null;
        const nombre = $("inputNombre")?.value.trim();
        const descripcion = $("textareaDescripcion")?.value.trim();
        const color = $("inputColor")?.value.trim() || "#3498DB";
        const icono = $("inputIcono")?.value.trim() || "fas fa-stethoscope";
        const estado = $("selectEstado")?.value || "ACTIVA";

        if (!nombre) { mostrarErrorModal("El nombre es obligatorio."); return; }

        const regexDescripcion = /^[a-zA-ZÁÉÍÓÚÜÑáéíóúüñ\s.,]*$/;
        if (!regexDescripcion.test(descripcion)) { mostrarErrorModal("La descripción solo puede contener letras, espacios, coma y punto."); return; }

        const regexNombre = /^[a-zA-ZÁÉÍÓÚÜÑáéíóúüñ\s]+$/;
        if (!regexNombre.test(nombre)) { mostrarErrorModal("El nombre solo puede contener letras y espacios."); return; }

        const btn = $("modalGuardarBtn");
        if (btn) btn.disabled = true;
        mostrarErrorModal("");

        const url = isNew ? "/especialidades/nueva" : `/especialidades/actualizar/${currentEspecialidadId}`;
        const method = isNew ? "POST" : "PUT";

        try {
            const res = await fetch(url, {
                method: method,
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ nombre, descripcion, color, icono, estado }),
            });
            const j = await res.json().catch(() => null);

            if (!res.ok || (j && !j.success)) {
                const msg = (j && j.message) || `Error ${res.status}`;
                mostrarErrorModal(msg);
                return;
            }

            mostrarMensaje("success", (j && j.message) || "Operación exitosa.");
            cerrarModalEspecialidad();
            await cargarDatosReales();
        } catch (err) {
            console.error("Error al guardar especialidad", err);
            mostrarErrorModal("Error de conexión: " + err.message);
        } finally {
            if (btn) btn.disabled = false;
        }
    }

    /* ---------- Mensajes ---------- */
    function mostrarMensaje(tipo, texto) {
        const el = tipo === "success" ? $("alertSuccess") : $("alertError");
        const msgEl = tipo === "success" ? $("successMessage") : $("errorMessage");

        if (!el) return;

        el.className = `alert ${tipo}`;
        msgEl.textContent = texto;
        el.style.display = "flex";

        setTimeout(() => (el.style.display = "none"), 4000);
    }

    function mostrarErrorModal(txt) {
        const msgEl = $("modalErrorMessage");
        const containerEl = $("modalError");
        if (!msgEl || !containerEl) return;
        msgEl.textContent = txt;
        containerEl.style.display = txt ? "flex" : "none";
    }

    /* ---------- Eliminar ---------- */
    async function eliminarEspecialidad(id) {
        try {
            const res = await fetch(`/especialidades/eliminar/${id}`, { method: "DELETE", headers: { "Content-Type": "application/json" } });
            const j = await res.json().catch(() => null);

            if (!res.ok || (j && !j.success)) {
                const msg = (j && j.message) || `Error ${res.status}`;
                mostrarMensaje("error", msg);
                return;
            }

            mostrarMensaje("success", j.message || "Especialidad eliminada correctamente");
            await cargarDatosReales();
        } catch (err) {
            console.error("Error al eliminar especialidad:", err);
            mostrarMensaje("error", "Error de conexión al eliminar la especialidad.");
        }

    }

    /* ---------- Imprimir (ACTUALIZADO para usar tabla limpia) ---------- */
    async function imprimirEspecialidades() {
        const loading = $("loadingPrint");
        if (loading) loading.style.display = "flex";

        try {
            // 1. Obtener el logo en Base64 (si es posible)
            let logoBase64 = null;
            try {
                // ✅ CORRECCIÓN 2: Se usa LOGO_URL (ruta absoluta o relativa correcta)
                logoBase64 = await imageToBase64(LOGO_URL); 
            } catch (e) {
                console.warn("Advertencia: No se pudo cargar el logo para impresión. Se usará placeholder.", e);
            }

            // 2. Generar el HTML de la tabla limpia (sin columna de Acciones)
            const cleanTableHtml = generarTablaHtmlParaImpresion(especialidadesData);

            // 3. Generar la ventana de impresión
            generarVentanaImpresion(logoBase64, cleanTableHtml);
            
            mostrarMensaje("success", "Generando vista previa de impresión...");

        } catch (err) {
            console.error("Error al generar vista de impresión:", err);
            mostrarMensaje("error", "Error al generar la vista previa de impresión: " + err.message);
        } finally {
            if (loading) loading.style.display = "none";
        }
    }

    /* ---------- Inicialización ---------- */
    document.addEventListener("DOMContentLoaded", () => {
        cargarDatosReales();

        $("btnNuevaEspecialidadHeader")?.addEventListener("click", () => abrirModalEspecialidad("nueva"));
        $("btnCancelarModal")?.addEventListener("click", cerrarModalEspecialidad);
        $("btnCloseModal")?.addEventListener("click", cerrarModalEspecialidad);
        $("modalGuardarBtn")?.addEventListener("click", guardarEspecialidadHandler);

        $("inputColor")?.addEventListener("input", actualizarPreview);
        $("inputIcono")?.addEventListener("input", actualizarPreview);

        const tabla = $("especialidadesTable");
        if (tabla) tabla.addEventListener("click", tablaClickHandler);

        $("filterNombre")?.addEventListener("input", aplicarFiltros);
        $("filterEstado")?.addEventListener("change", aplicarFiltros);
        $("btnAplicarFiltros")?.addEventListener("click", aplicarFiltros);
        $("btnLimpiarFiltros")?.addEventListener("click", () => {
            $("filterNombre").value = "";
            $("filterEstado").value = "";
            aplicarFiltros();
        });

        const modal = $("modalEspecialidad");
        if (modal) modal.addEventListener("click", (e) => { if (e.target === modal) cerrarModalEspecialidad(); });

        $("btnImprimir")?.addEventListener("click", imprimirEspecialidades);

        // --- INICIALIZACIÓN: Botón para volver al Dashboard (Logo) ---
        const logoBtn = $("logoBtn");
        if (logoBtn) {
            const dashboardUrl = logoBtn.getAttribute('data-url') || '/dashboard';
            logoBtn.addEventListener('click', () => {
                window.location.href = dashboardUrl;
            });
        }
        // ------------------------------------------------------------------

        // Validaciones en tiempo real
        $("inputNombre")?.addEventListener("input", () => {
            const input = $("inputNombre");
            input.value = input.value.replace(/[^a-zA-ZÁÉÍÓÚÜÑáéíóúüñ\s]/g, "").replace(/\s{2,}/g, " ");
        });

        $("textareaDescripcion")?.addEventListener("input", () => {
            const input = $("textareaDescripcion");
            input.value = input.value.replace(/[^a-zA-ZÁÉÍÓÚÜÑáéíóúüñ\s.,]/g, "").replace(/\s{2,}/g, " ");
        });
    });

})();