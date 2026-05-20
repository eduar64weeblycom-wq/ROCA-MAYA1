// public/js/preclinica.js (validaciones médicas mejoradas, auto-conversión de cm->m y severidad de mensajes)
(() => {
    const $ = id => document.getElementById(id);

    let citas = [];
    let preclinicas = {};
    let submitting = false;

    let filtroBusquedaPaciente = "";
    let filtroBusquedaFecha = "";
    let filtroBusquedaEstado = "";

    function escapeHtml(s) { if (s == null) return ""; return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }
    function debounce(fn, wait = 200) { let t; return (...a) => { clearTimeout(t); t = setTimeout(()=>fn(...a), wait); }; }

    function sanitizeSearch(value) { if (typeof value !== 'string') return ''; return value.replace(/[^a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ\s\.\-]/g, ''); }
    function sanitizeInput(value) { if (typeof value !== 'string') return ''; return value.replace(/[^a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ\s\.\,\;\:\-\(\)]/g, ''); }

    async function cargarDatos() {
        try {
            const res = await fetch("/preclinica/api/datos", { credentials: "same-origin" });
            if (!res.ok) throw new Error("HTTP " + res.status);
            const j = await res.json();
            citas = j.citas || [];
            citas.sort((a,b) => (Number(b.ID_CITA) || 0) - (Number(a.ID_CITA) || 0));
            preclinicas = {};
            (j.preclinicas || []).forEach(p => preclinicas[p.ID_CITA] = p);
            renderTabla();
            llenarSelectCitas();
            llenarSelectEstados();
        } catch (err) {
            console.error("Error cargando datos en Preclínica:", err);
            alert("Error cargando datos: " + err.message);
        }
    }

    function safeEstadoClass(estado) {
        if (!estado) return "";
        return "estado-" + String(estado).toLowerCase().replace(/[^a-z0-9]+/g, "_");
    }

    function renderTabla() {
        const target = $("tablaContenidoPreclinica");
        if (!target) return;
        const filtroTexto = sanitizeSearch(filtroBusquedaPaciente).toLowerCase().trim();
        const filtroFechaStr = filtroBusquedaFecha;
        const filtroEstado = filtroBusquedaEstado.toUpperCase();

        const citasFiltradas = citas.filter(c => {
            const cumpleTexto = !filtroTexto ||
                String(c.ID_CITA).includes(filtroTexto) ||
                (c.NOMBRE_PACIENTE && c.NOMBRE_PACIENTE.toLowerCase().includes(filtroTexto)) ||
                (c.TELEFONO && c.TELEFONO.includes(filtroTexto)) ||
                (c.NOMBRE_DOCTOR && c.NOMBRE_DOCTOR.toLowerCase().includes(filtroTexto)) ||
                (c.ESTADO && c.ESTADO.toLowerCase().includes(filtroTexto));

            let cumpleFecha = true;
            if (filtroFechaStr) {
                const citaFechaStr = new Date(c.FECHA_CITA).toISOString().split('T')[0];
                cumpleFecha = citaFechaStr === filtroFechaStr;
            }

            const cumpleEstado = !filtroEstado || filtroEstado === "" || (c.ESTADO && c.ESTADO.toUpperCase() === filtroEstado);

            return cumpleTexto && cumpleFecha && cumpleEstado;
        });

        citasFiltradas.sort((a,b) => (Number(b.ID_CITA) || 0) - (Number(a.ID_CITA) || 0));

        if (!citasFiltradas.length) {
            target.innerHTML = `<div class="ctsin-citas"><i class="fas fa-stethoscope"></i><h3>${ filtroTexto || filtroFechaStr || filtroEstado ? 'No se encontraron citas con los filtros aplicados.' : 'No hay citas' }</h3></div>`;
            return;
        }

        let html = `<div class="cttabla-preclinica"><table class="table"><thead><tr><th>ID</th><th>Cita</th><th>Paciente</th><th>Doctor</th><th>Fecha</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>`;
        citasFiltradas.forEach(c => {
            const fecha = new Date(c.FECHA_CITA).toLocaleDateString("es-ES");
            const hora = new Date(c.FECHA_CITA).toLocaleTimeString("es-ES",{ hour: "2-digit", minute: "2-digit" });
            const hasPre = !!preclinicas[c.ID_CITA];
            const estadoClass = safeEstadoClass(c.ESTADO || "");
            const mostrarPreclinica = String(c.ESTADO || "").toUpperCase() !== "CANCELADA";
            html += `<tr data-id="${c.ID_CITA}"><td>#${c.ID_CITA}</td><td>${fecha}<br><small>${hora}</small></td><td><strong>${escapeHtml(c.NOMBRE_PACIENTE)}</strong><br><small>${escapeHtml(c.TELEFONO || "")}</small></td><td>${escapeHtml(c.NOMBRE_DOCTOR || "")}</td><td>${fecha}</td><td><span class="ctestado-badge ${estadoClass}">${escapeHtml(c.ESTADO || "")}</span></td><td><div class="ctacciones-preclinica">`;
            if (mostrarPreclinica) {
                html += `<button class="ctbtn-accion" data-action="abrirPreclinica" data-id="${c.ID_CITA}"><i class="fas fa-stethoscope"></i> Preclínica</button>`;
                if (hasPre) html += `<button class="ctbtn-accion edit" data-action="editarPreclinica" data-id="${c.ID_CITA}"><i class="fas fa-edit"></i> Editar</button>`;
            } else {
                html += `<span class="text-muted">Sin acciones</span>`;
            }
            html += `</div></td></tr>`;
        });
        html += `</tbody></table></div>`;
        target.innerHTML = html;
    }

    function llenarSelectCitas() {
        const sel = $("selectCita");
        if (!sel) return;
        sel.innerHTML = '<option value="">Seleccionar cita...</option>';
        citas.forEach(c => {
            const opt = document.createElement("option");
            opt.value = c.ID_CITA;
            opt.textContent = `#${c.ID_CITA} — ${c.NOMBRE_PACIENTE} • ${new Date(c.FECHA_CITA).toLocaleString("es-ES")}`;
            opt.dataset.telefono = c.TELEFONO || "";
            opt.dataset.correo = c.CORREO_ELECTRONICO || "";
            sel.appendChild(opt);
        });
    }

    function llenarSelectEstados() {
        const sel = $("filtroEstadoCita");
        if (!sel) return;
        const estadosUnicos = [...new Set(citas.map(c => c.ESTADO).filter(e => e))].sort();
        const valorActual = sel.value;
        sel.innerHTML = '<option value="">Todos</option>';
        estadosUnicos.forEach(estado => {
            const opt = document.createElement("option");
            opt.value = estado;
            opt.textContent = estado;
            sel.appendChild(opt);
        });
        if (estadosUnicos.includes(valorActual)) sel.value = valorActual;
        else filtroBusquedaEstado = "";
    }

    function abrirModal() {
        const modal = $("modalPreclinica");
        if (!modal) return;
        modal.style.display = "flex";
        modal.setAttribute("aria-hidden", "false");
        limpiarModal();
    }
    function closePreclinicaModal() {
        const modal = $("modalPreclinica");
        if (!modal) return;
        modal.style.display = "none";
        modal.setAttribute("aria-hidden", "true");
        renderValidationMessages([]);
        clearAllFieldErrors();
        clearInfoField("talla-info");
    }
    function limpiarModal() {
        const f = $("formPreclinica");
        if (f) f.reset();
        if ($("idPreclinica")) $("idPreclinica").value = "";
        if ($("imc")) $("imc").value = "";
        if ($("finIMC")) $("finIMC").textContent = "-";
        if ($("modalError")) $("modalError").style.display = "none";
        if ($("selectCita")) $("selectCita").value = "";
        if ($("pacienteInfo")) $("pacienteInfo").textContent = "";
        renderValidationMessages([]);
        clearAllFieldErrors();
        clearInfoField("talla-info");
    }

    async function cargarPreclinicaEnModal(idCita) {
        try {
            const res = await fetch(`/preclinica/por-cita/${idCita}`, { credentials: "same-origin" });
            if (res.status === 404) {
                abrirModal();
                if ($("selectCita")) { $("selectCita").value = idCita; $("selectCita").dispatchEvent(new Event("change")); }
                return;
            }
            if (!res.ok) throw new Error("HTTP " + res.status);
            const j = await res.json();
            if (j && j.success && j.preclinica) {
                const p = j.preclinica;
                abrirModal();
                if ($("idPreclinica")) $("idPreclinica").value = p.ID_PRECLINICA || "";
                if ($("selectCita")) { $("selectCita").value = p.ID_CITA; $("selectCita").dispatchEvent(new Event("change")); }
                if ($("temperatura")) $("temperatura").value = p.TEMPERATURA || "";
                if ($("presionSistolica")) $("presionSistolica").value = p.PRESION_SISTOLICA || "";
                if ($("presionDiastolica")) $("presionDiastolica").value = p.PRESION_DIASTOLICA || "";
                if ($("frecuenciaCardiaca")) $("frecuenciaCardiaca").value = p.FRECUENCIA_CARDIACA || "";
                if ($("frecuenciaRespiratoria")) $("frecuenciaRespiratoria").value = p.FRECUENCIA_RESPIRATORIA || "";
                if ($("saturacionOxigeno")) $("saturacionOxigeno").value = p.SATURACION_OXIGENO || "";
                if ($("peso")) $("peso").value = p.PESO || "";
                if ($("talla")) $("talla").value = p.TALLA || "";
                if ($("glucosa")) $("glucosa").value = p.GLUCOSA || "";
                if ($("perimetroAbdominal")) $("perimetroAbdominal").value = p.PERIMETRO_ABDOMINAL || "";
                if ($("observaciones")) $("observaciones").value = p.OBSERVACIONES || "";
                if ($("estadoGeneral")) $("estadoGeneral").value = p.ESTADO_GENERAL || "BUENO";
                calcularIMC();
            }
        } catch (err) {
            console.error("Error cargando preclinica por cita:", err);
            mostrarModalError("No se pudo cargar la preclínica: " + err.message);
        }
    }

    function calcularIMC() {
        const peso = parseFloat($("peso")?.value || 0);
        let tallaVal = parseFloat($("talla")?.value || 0);

        // auto-conversión si el usuario ingresó talla en cm (ej 180)
        if (!isNaN(tallaVal) && tallaVal > 3 && tallaVal <= 300) {
            // convertir cm -> m
            const converted = (tallaVal / 100);
            // actualizar campo para consistencia
            $("talla").value = converted.toFixed(2);
            tallaVal = converted;
            showInfoField("talla-info", `Se interpretó ${Math.round(tallaVal * 100)} cm y se convirtió a ${tallaVal.toFixed(2)} m.`);
        } else {
            clearInfoField("talla-info");
        }

        if (!peso || !tallaVal) { if ($("imc")) $("imc").value = ""; if ($("finIMC")) $("finIMC").textContent = "-"; return; }
        const imc = peso / (tallaVal * tallaVal);
        const v = isFinite(imc) ? imc.toFixed(2) : "";
        if ($("imc")) $("imc").value = v;
        if ($("finIMC")) $("finIMC").textContent = v;
    }

    // VALIDACIÓN mejorada: devuelve {ok, errors:[{field,message,severity}], summary}
    function validatePreclinicaFromForm() {
        const getRaw = id => (document.getElementById(id) ? document.getElementById(id).value : "");
        let idCita = Number(getRaw("selectCita") || 0);
        let temperatura = parseFloat(getRaw("temperatura") || "");
        let presionS = parseInt(getRaw("presionSistolica") || "");
        let presionD = parseInt(getRaw("presionDiastolica") || "");
        let fc = parseInt(getRaw("frecuenciaCardiaca") || "");
        let fr = parseInt(getRaw("frecuenciaRespiratoria") || "");
        let sat = parseFloat(getRaw("saturacionOxigeno") || "");
        let peso = parseFloat(getRaw("peso") || "");
        let tallaRaw = parseFloat(getRaw("talla") || "");
        let glucosa = parseFloat(getRaw("glucosa") || "");
        let perim = parseFloat(getRaw("perimetroAbdominal") || "");
        const observ = sanitizeInput(getRaw("observaciones") || "");
        const estadoGeneral = getRaw("estadoGeneral") || "BUENO";

        const errors = [];
        const infos = [];

        // Detectar si ingresó talla en cm (ej 180)
        let talla = tallaRaw;
        if (!isNaN(tallaRaw) && tallaRaw > 3 && tallaRaw <= 300) {
            // convertir cm -> m
            talla = tallaRaw / 100;
            infos.push({ field: "talla", message: `Se detectó ${tallaRaw} como centímetros y se convirtió a ${talla.toFixed(2)} m.`, severity: "info" });
            // actualizar campo de formulario para evitar confusión
            try { if ($("talla")) $("talla").value = talla.toFixed(2); if ($("talla-info")) $("talla-info").style.display = "block"; } catch (e) {}
        }

        // Validaciones críticas (bloqueantes)
        if (!idCita || isNaN(idCita)) errors.push({ field: "selectCita", message: "Seleccione la cita.", severity: "critical" });
        if (!(peso > 0) || isNaN(peso)) errors.push({ field: "peso", message: "Peso debe ser mayor a 0 kg.", severity: "critical" });
        if (!(talla > 0) || isNaN(talla)) errors.push({ field: "talla", message: "Talla debe ser mayor a 0 m.", severity: "critical" });

        // Rango razonable basado en ciencia médica
        // Talla (m): 0.5 - 2.5 (50 cm - 250 cm)
        if (!isNaN(talla) && (talla > 0) && (talla < 0.5 || talla > 2.5)) {
            errors.push({ field: "talla", message: "Talla fuera de rango razonable (0.50 - 2.50 m). Verifique entrada (si ingresó 180, se convertirá automáticamente a 1.80 m).", severity: "critical" });
        }

        // Peso (kg): 2 - 500 (práctico: >0 y < 500)
        if (!isNaN(peso) && (peso < 2 || peso > 500)) {
            // peso extremadamente bajo o alto
            errors.push({ field: "peso", message: "Peso fuera de rango razonable (2 - 500 kg). Verifique.", severity: "critical" });
        }

        // Advertencias / rangos menos estrictos
        if (!isNaN(temperatura) && (temperatura < 32 || temperatura > 42)) {
            errors.push({ field: "temperatura", message: "Temperatura fuera de rango normal/esperado (32 - 42 °C).", severity: "warning" });
        }
        if (!isNaN(presionS) && (presionS < 70 || presionS > 220)) {
            errors.push({ field: "presionSistolica", message: "Presión sistólica fuera de rango esperado (70 - 220 mmHg).", severity: "warning" });
        }
        if (!isNaN(presionD) && (presionD < 40 || presionD > 140)) {
            errors.push({ field: "presionDiastolica", message: "Presión diastólica fuera de rango esperado (40 - 140 mmHg).", severity: "warning" });
        }
        if (!isNaN(sat) && (sat < 50 || sat > 100)) {
            errors.push({ field: "saturacionOxigeno", message: "Saturación O₂ fuera de rango (50 - 100%).", severity: "warning" });
        }
        if (!isNaN(fc) && (fc < 30 || fc > 200)) {
            errors.push({ field: "frecuenciaCardiaca", message: "Frecuencia cardíaca fuera de rango (30 - 200 lpm).", severity: "warning" });
        }
        if (!isNaN(fr) && (fr < 8 || fr > 60)) {
            errors.push({ field: "frecuenciaRespiratoria", message: "Frecuencia respiratoria fuera de rango (8 - 60 rpm).", severity: "warning" });
        }
        if (!isNaN(glucosa) && (glucosa < 30 || glucosa > 900)) {
            errors.push({ field: "glucosa", message: "Glucosa fuera de rango (30 - 900 mg/dL). Verifique.", severity: "warning" });
        }
        if (!isNaN(perim) && (perim < 10 || perim > 300)) {
            errors.push({ field: "perimetroAbdominal", message: "Perímetro abdominal fuera de rango (10 - 300 cm).", severity: "warning" });
        }

        // Combine infos into the errors array as non-critical messages so they display as info blocks
        infos.forEach(i => errors.push(i));

        const imc = (peso > 0 && talla > 0) ? (peso / (talla * talla)) : null;

        const summary = {
            idCita,
            temperatura: isNaN(temperatura) ? "" : temperatura,
            presionS,
            presionD,
            fc,
            fr,
            sat,
            peso: isNaN(peso) ? "" : peso,
            talla: isNaN(talla) ? "" : talla,
            imc: imc ? imc.toFixed(2) : "",
            glucosa: isNaN(glucosa) ? "" : glucosa,
            perimetroAbdominal: isNaN(perim) ? "" : perim,
            observaciones: observ,
            estadoGeneral
        };

        const criticalPresent = errors.some(e => e.severity === "critical");
        return { ok: !criticalPresent, errors, summary };
    }

    // visual inline errors (critical -> red, warning -> orange, info -> greenish)
    function setFieldError(field, message, severity) {
        const el = document.getElementById(field);
        const errEl = document.getElementById(field + "-error");
        const infoEl = document.getElementById(field + "-info");
        if (severity === "critical") {
            if (el) el.classList.add("field-error");
            if (errEl) { errEl.textContent = message; errEl.style.display = "block"; errEl.className = "error-text"; }
        } else if (severity === "warning") {
            if (el) el.classList.add("field-warning");
            if (errEl) { errEl.textContent = message; errEl.style.display = "block"; errEl.className = "error-text"; }
        } else if (severity === "info") {
            // info message uses info-text element if exists, otherwise reuse error element but with info style
            const infoTarget = document.getElementById(field + "-info") || document.getElementById(field + "-error");
            if (infoTarget) { infoTarget.textContent = message; infoTarget.style.display = "block"; infoTarget.className = "info-text"; }
        }
    }
    function clearFieldError(field) {
        const el = document.getElementById(field);
        if (el) { el.classList.remove("field-error"); el.classList.remove("field-warning"); }
        const errEl = document.getElementById(field + "-error");
        if (errEl) { errEl.textContent = ""; errEl.style.display = "none"; }
        const infoEl = document.getElementById(field + "-info");
        if (infoEl) { infoEl.textContent = ""; infoEl.style.display = "none"; }
    }
    function clearAllFieldErrors() {
        const ids = ["selectCita","temperatura","presionSistolica","presionDiastolica","frecuenciaCardiaca","frecuenciaRespiratoria","saturacionOxigeno","peso","talla","glucosa","perimetroAbdominal","observaciones"];
        ids.forEach(clearFieldError);
    }
    function showInfoField(id, message) {
        const el = document.getElementById(id);
        if (!el) return;
        el.textContent = message;
        el.style.display = "block";
    }
    function clearInfoField(id) {
        const el = document.getElementById(id);
        if (!el) return;
        el.textContent = "";
        el.style.display = "none";
    }

    function renderValidationMessages(errors) {
        const container = $("validationMessages");
        if (!container) return;
        clearAllFieldErrors();

        if (!errors || errors.length === 0) {
            container.innerHTML = `<div class="validation-ok">No se detectaron problemas críticos. Puedes continuar y confirmar para guardar.</div>`;
            return;
        }

        const critical = errors.filter(e => e.severity === "critical");
        const warnings = errors.filter(e => e.severity === "warning");
        const infos = errors.filter(e => e.severity === "info");

        // apply inline messages
        errors.forEach(e => {
            setFieldError(e.field, e.message, e.severity || "warning");
        });

        let html = "";
        if (critical.length) {
            html += `<div class="validation-error"><strong>Errores obligatorios:</strong><ul>`;
            critical.forEach(e => html += `<li>${escapeHtml(e.message)}</li>`);
            html += `</ul></div>`;
        }
        if (warnings.length) {
            html += `<div class="validation-list"><strong>Advertencias:</strong><ul>`;
            warnings.forEach(e => html += `<li>${escapeHtml(e.message)}</li>`);
            html += `</ul></div>`;
        }
        if (infos.length) {
            html += `<div class="validation-info"><strong>Información:</strong><ul>`;
            infos.forEach(e => html += `<li>${escapeHtml(e.message)}</li>`);
            html += `</ul></div>`;
        }
        container.innerHTML = html;
    }

    // muestra el resumen en el modal de confirmación
    function renderConfirmSummary(summary) {
        const c = $("confirmSummary");
        if (!c) return;
        const rows = [
            { label: "Cita ID", value: summary.idCita },
            { label: "Peso (kg)", value: summary.peso },
            { label: "Talla (m)", value: summary.talla },
            { label: "IMC", value: summary.imc },
            { label: "Temperatura (°C)", value: summary.temperatura },
            { label: "Presión (S/D)", value: (summary.presionS || "") + (summary.presionS ? " / " + (summary.presionD||"") : "") },
            { label: "FC (lpm)", value: summary.fc },
            { label: "FR (rpm)", value: summary.fr },
            { label: "Saturación (%)", value: summary.sat },
            { label: "Glucosa (mg/dL)", value: summary.glucosa },
            { label: "Perímetro abdominal (cm)", value: summary.perimetroAbdominal },
            { label: "Estado general", value: summary.estadoGeneral },
            { label: "Observaciones", value: summary.observaciones }
        ];
        let html = "";
        rows.forEach(r => {
            html += `<div class="confirm-field"><strong>${escapeHtml(r.label)}:</strong><div>${escapeHtml(String(r.value || ""))}</div></div>`;
        });
        c.innerHTML = html;
    }

    // Envío real (nuevo/actualizar)
    async function submitPreclinica(payload, isUpdate = false) {
        submitting = true;
        const btn = $("btnConfirmPreclinica");
        if (btn) btn.disabled = true;
        try {
            let url = "/preclinica/nueva";
            if (isUpdate) {
                url = "/preclinica/actualizar";
                payload.idPreclinica = Number($("idPreclinica")?.value) || payload.idPreclinica;
                payload.idCita = Number(payload.idCita);
            }
            const res = await fetch(url, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                credentials: "same-origin",
                body: JSON.stringify(payload)
            });
            const j = res.headers.get("content-type")?.includes("application/json") ? await res.json().catch(()=>null) : null;
            if (!res.ok) {
                closeConfirmModal();
                mostrarModalError((j && j.message) || "Error " + res.status);
                return;
            }
            mostrarAlerta("success", (j && j.message) || "Preclínica guardada correctamente");
            closeConfirmModal();
            closePreclinicaModal();
            await cargarDatos();
            try {
                const bc = new BroadcastChannel("citas_channel");
                bc.postMessage({
                    type: "preclinica_saved",
                    idCita: Number(payload.idCita),
                    nuevoEstado: (j && j.nota_estado_actualizado) || 'PRECLINICA'
                });
                bc.postMessage({ type: "estado_cita", id: Number(payload.idCita), nuevoEstado: (j && j.nota_estado_actualizado) || 'PRECLINICA' });
                bc.close();
            } catch (e) {}
        } catch (err) {
            console.error("Error guardando preclinica", err);
            closeConfirmModal();
            mostrarModalError("Error guardando: " + err.message);
        } finally {
            submitting = false;
            if (btn) btn.disabled = false;
        }
    }

    // Manejador inicial: valida y si todo OK muestra modal de confirmación
    async function guardarHandler() {
        const validation = validatePreclinicaFromForm();
        renderValidationMessages(validation.errors);
        if (!validation.ok) {
            // Enfocar primer campo crítico
            const firstCritical = validation.errors.find(e => e.severity === "critical");
            if (firstCritical && document.getElementById(firstCritical.field)) document.getElementById(firstCritical.field).focus();
            return;
        }
        renderConfirmSummary(validation.summary);
        openConfirmModal();
    }

    function gatherPayloadFromForm() {
        const get = id => (document.getElementById(id) ? document.getElementById(id).value : "");
        return {
            idCita: Number(get("selectCita") || 0),
            temperatura: parseFloat(get("temperatura") || null),
            presionSistolica: parseInt(get("presionSistolica") || null),
            presionDiastolica: parseInt(get("presionDiastolica") || null),
            frecuenciaCardiaca: parseInt(get("frecuenciaCardiaca") || null),
            frecuenciaRespiratoria: parseInt(get("frecuenciaRespiratoria") || null),
            saturacionOxigeno: parseFloat(get("saturacionOxigeno") || null),
            peso: parseFloat(get("peso") || null),
            talla: parseFloat(get("talla") || null),
            glucosa: parseFloat(get("glucosa") || null),
            perimetroAbdominal: parseFloat(get("perimetroAbdominal") || null),
            observaciones: sanitizeInput(get("observaciones") || null),
            estadoGeneral: get("estadoGeneral") || "BUENO",
            signosVitalesJson: { temperatura: get("temperatura") || null, peso: get("peso") || null, talla: get("talla") || null }
        };
    }

    function openConfirmModal() {
        const m = $("confirmPreclinicaModal");
        if (!m) return;
        m.style.display = "flex";
        m.setAttribute("aria-hidden", "false");
    }
    function closeConfirmModal() {
        const m = $("confirmPreclinicaModal");
        if (!m) return;
        m.style.display = "none";
        m.setAttribute("aria-hidden", "true");
    }

    function mostrarAlerta(tipo, texto) {
        const el = tipo === "success" ? $("alertSuccessPre") : $("alertErrorPre");
        if (!el) return alert(texto);
        (tipo === "success" ? $("successMessagePre") : $("errorMessagePre")).textContent = texto;
        el.style.display = "flex";
        setTimeout(() => (el.style.display = "none"), 3000);
    }
    function mostrarModalError(txt) {
        const el = $("modalError");
        if (!el) return alert(txt);
        el.textContent = txt;
        el.style.display = "flex";
    }

    // Handler para eventos en la tabla y botones
    document.addEventListener("click", (ev) => {
        const b = ev.target.closest("button");
        if (!b) return;
        const action = b.dataset.action;
        const id = b.dataset.id;
        if (action === "abrirPreclinica") {
            ev.preventDefault();
            abrirModal();
            if ($("selectCita")) { $("selectCita").value = id; $("selectCita").dispatchEvent(new Event("change")); }
            return;
        }
        if (action === "editarPreclinica") {
            ev.preventDefault();
            cargarPreclinicaEnModal(id);
            return;
        }
        if (b.id === "btnNuevaPreclinica") { ev.preventDefault(); abrirModal(); return; }
        if (b.id === "btnCerrarModalPreclinica" || b.id === "btnCancelarPreclinica") { ev.preventDefault(); closePreclinicaModal(); return; }
        if (b.id === "btnGuardarPreclinica") { ev.preventDefault(); guardarHandler(); return; }

        if (b.id === "btnConfirmPreclinica") {
            ev.preventDefault();
            const payload = gatherPayloadFromForm();
            const isUpdate = !!($("idPreclinica") && $("idPreclinica").value);
            submitPreclinica(payload, isUpdate);
            return;
        }
        if (b.id === "btnEditPreclinica" || b.id === "btnCloseConfirm") {
            ev.preventDefault();
            closeConfirmModal();
            return;
        }
    });

    // filtros
    const handleFilterChange = debounce(()=>{ renderTabla(); }, 300);

    document.addEventListener("DOMContentLoaded", () => {
        ["btnGuardarPreclinica","btnNuevaPreclinica","btnCancelarPreclinica","btnCerrarModalPreclinica","btnConfirmPreclinica","btnEditPreclinica","btnCloseConfirm"].forEach(id => { const el = $(id); if (el && el.tagName === "BUTTON") el.type = "button"; });

        const logoBtn = $("logoBtn"); if (logoBtn) { logoBtn.type = "button"; logoBtn.addEventListener("click", e => { e.preventDefault(); window.location.href = "/"; }); }

        cargarDatos();

        const inputBusqueda = $("filtroPaciente");
        if (inputBusqueda) {
            inputBusqueda.addEventListener("input", (e) => {
                const cleanValue = sanitizeSearch(e.target.value);
                e.target.value = cleanValue;
                filtroBusquedaPaciente = cleanValue;
                handleFilterChange();
            });
        }

        const inputFecha = $("filtroFecha");
        if (inputFecha) {
            inputFecha.addEventListener("change", (e) => {
                filtroBusquedaFecha = e.target.value;
                renderTabla();
            });
        }

        const selectEstado = $("filtroEstadoCita");
        if (selectEstado) {
            selectEstado.addEventListener("change", (e) => {
                filtroBusquedaEstado = e.target.value;
                renderTabla();
            });
        }

        const inputObservaciones = $("observaciones");
        if (inputObservaciones) {
            inputObservaciones.addEventListener('input', (e) => {
                const cleanValue = sanitizeInput(e.target.value);
                e.target.value = cleanValue;
            });
        }

        // CALCULAR IMC al cambiar peso/talla
        $("peso")?.addEventListener("input", debounce(calcularIMC, 80));
        $("talla")?.addEventListener("input", debounce(calcularIMC, 80));

        $("selectCita")?.addEventListener("change", () => {
            const opt = $("selectCita").selectedOptions[0];
            if (!opt) return;
            const info = [];
            if (opt.dataset.telefono) info.push("Tel: " + opt.dataset.telefono);
            if (opt.dataset.correo) info.push(opt.dataset.correo);
            $("pacienteInfo").textContent = info.join(" • ");
        });

        try {
            const bc = new BroadcastChannel("citas_channel");
            bc.onmessage = (ev) => {
                const d = ev.data || {};
                if (!d) return;
                if (d.type === "estado_cita" || d.type === "preclinica_saved") cargarDatos();
            };
        } catch (e) {}
    });

    // helpers to close modals on outside click
    window.addEventListener("click", (e) => {
        const modal = $("confirmPreclinicaModal");
        if (!modal) return;
        if (e.target === modal) closeConfirmModal();
        const preModal = $("modalPreclinica");
        if (e.target === preModal) closePreclinicaModal();
    });

    window.__preclinica_debug = { cargarDatos, preclinicas };
})();