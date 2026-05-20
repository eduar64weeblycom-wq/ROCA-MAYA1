// public/js/citas.js (actualizado para seguir la separación de estados)
// Orden y acciones: Citas controla Confirmar -> Preclínica -> (desde Preclínica se pasa a consulta) -> Finalizar.
// Además permite Cancelar y No Asistió desde Citas.
(() => {
  let citasData = [], doctoresData = [], pacientesData = [];
  let metadata = { tipos: [], prioridades: [], canales: [], duraciones: [] };
  const $ = id => document.getElementById(id);
  const processingCitas = new Set();
  let submitInProgress = false;

  function escapeHtml(s) {
    if (s === undefined || s === null) return "";
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function debounce(fn, wait = 200) {
    let t;
    return (...args) => {
      clearTimeout(t);
      t = setTimeout(() => fn(...args), wait);
    };
  }

  async function cargarDatosReales(force = false) {
    try {
      const res = await fetch("/citas/api/datos", { credentials: "same-origin", cache: force ? "no-store" : "default" });
      if (!res.ok) throw new Error("HTTP " + res.status);
      const json = await res.json();
      citasData = json.citas || [];
      doctoresData = json.doctores || [];
      pacientesData = json.pacientes || [];
      metadata = json.metadata || metadata;
      llenarSelectPacientes();
      llenarSelectDoctores();
      llenarFiltroDoctores();
      llenarMetadataSelects();
      mostrarCitas(citasData);
    } catch (err) {
      console.error("Error cargando datos:", err);
      mostrarMensaje("error", "Error cargando datos: " + err.message);
    }
  }

  function llenarSelectPacientes(filter = "") {
    const sel = $("selectPaciente");
    if (!sel) return;
    sel.innerHTML = '<option value="">Seleccionar paciente...</option>';
    const q = String(filter || "").trim().toLowerCase();
    pacientesData.forEach(p => {
      const identidad = p.NUMERO_DOCUMENTO_IDENTIDAD || p.IDENTIDAD || "";
      const label = `${p.NOMBRES} ${p.APELLIDOS}${p.TELEFONO ? " - " + p.TELEFONO : ""}${identidad ? " • " + identidad : ""}`;
      if (q && !label.toLowerCase().includes(q)) return;
      const opt = document.createElement("option");
      opt.value = p.ID_PACIENTE;
      opt.textContent = label;
      opt.dataset.telefono = p.TELEFONO || "";
      opt.dataset.correo = p.CORREO_ELECTRONICO || "";
      opt.dataset.identidad = identidad || "";
      sel.appendChild(opt);
    });
    if (sel.options.length === 1) sel.appendChild(Object.assign(document.createElement("option"), { value: "", textContent: "No se encontraron pacientes" }));
  }

  function llenarSelectDoctores(filter = "") {
    const sel = $("selectDoctor");
    if (!sel) return;
    sel.innerHTML = '<option value="">Seleccionar doctor...</option>';
    const q = String(filter || "").trim().toLowerCase();
    doctoresData.forEach(d => {
      const identidad = d.IDENTIDAD || "";
      const label = `Dr. ${d.NOMBRE} - ${d.ESPECIALIDAD || ""}${identidad ? " • " + identidad : ""}`;
      if (q && !label.toLowerCase().includes(q)) return;
      const opt = document.createElement("option");
      opt.value = d.ID_DOCTOR;
      opt.textContent = label;
      opt.dataset.especialidad = d.ESPECIALIDAD || "";
      opt.dataset.correo = d.CORREO_ELECTRONICO || "";
      opt.dataset.identidad = identidad || "";
      sel.appendChild(opt);
    });
    if (sel.options.length === 1) sel.appendChild(Object.assign(document.createElement("option"), { value: "", textContent: "No se encontraron doctores" }));
  }

  function llenarFiltroDoctores(filter = "") {
    const sel = $("filtroDoctor");
    if (!sel) return;
    sel.innerHTML = '<option value="">Todos los doctores</option>';
    const q = String(filter || "").trim().toLowerCase();
    doctoresData.forEach(d => {
      const label = `Dr. ${d.NOMBRE} - ${d.ESPECIALIDAD || ""}`;
      if (q && !label.toLowerCase().includes(q)) return;
      const opt = document.createElement("option");
      opt.value = d.ID_DOCTOR;
      opt.textContent = label;
      sel.appendChild(opt);
    });
  }

  function llenarMetadataSelects() {
    const tipos = $("selectTipoCita"), prioridades = $("selectPrioridad"), canales = $("selectCanal"), duraciones = $("selectDuracion");
    if (tipos && metadata.tipos) { tipos.innerHTML = ""; metadata.tipos.forEach(t => tipos.appendChild(new Option(formatLabel(t), t))); }
    if (prioridades && metadata.prioridades) { prioridades.innerHTML = ""; metadata.prioridades.forEach(p => prioridades.appendChild(new Option(formatLabel(p), p))); }
    if (canales && metadata.canales) { canales.innerHTML = ""; metadata.canales.forEach(c => canales.appendChild(new Option(formatLabel(c), c))); }
    if (duraciones && metadata.duraciones) { duraciones.innerHTML = ""; metadata.duraciones.forEach(d => duraciones.appendChild(new Option(String(d), d))); }
  }

  function formatLabel(key) {
    return String(key).replace(/_/g, " ").toLowerCase().replace(/\b\w/g, l => l.toUpperCase());
  }

  // Prioridad/orden para la lista de Citas (ajustada a tu requerimiento)
  function statePriorityCitas(estado) {
    if (!estado) return 5;
    const e = String(estado).toUpperCase().trim();
    if (e === "CONFIRMADA") return 0;
    if (e === "PROGRAMADA") return 1;
    if (e === "FINALIZADA") return 2;
    if (e === "NO_ASISTIO") return 3;
    if (e === "CANCELADA") return 4;
    return 5;
  }

  function mostrarCitas(list) {
    const target = $("tablaContenido");
    if (!target) return;
    const seen = new Set();
    const dedup = [];
    (list || []).forEach(c => {
      const key = String(c.ID_CITA);
      if (!seen.has(key)) {
        dedup.push(c);
        seen.add(key);
      }
    });

    dedup.sort((a, b) => {
      const pa = statePriorityCitas(a.ESTADO);
      const pb = statePriorityCitas(b.ESTADO);
      if (pa !== pb) return pa - pb;
      const da = new Date(a.FECHA_CITA).getTime() || 0;
      const db = new Date(b.FECHA_CITA).getTime() || 0;
      return db - da;
    });

    if (!dedup || dedup.length === 0) {
      target.innerHTML = `<div class="ctsin-citas"><i class="fas fa-calendar-times"></i><h3>No hay citas</h3><p>Comienza creando una nueva cita médica.</p><button class="ctbtn-primary" id="btnCrearPrimera"><i class="fas fa-plus"></i> Crear Primera Cita</button></div>`;
      const btnLocal = document.getElementById("btnCrearPrimera");
      if (btnLocal && !btnLocal.dataset.listenerAttached) {
        btnLocal.addEventListener("click", abrirModalNuevaCita);
        btnLocal.dataset.listenerAttached = "1";
      }
      return;
    }

    let html = `<table class="table"><thead><tr><th>Paciente</th><th>Doctor</th><th>Fecha y Hora</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>`;
    dedup.forEach(c => {
      const fecha = new Date(c.FECHA_CITA).toLocaleDateString("es-ES");
      const hora = c.HORA_CITA || new Date(c.FECHA_CITA).toLocaleTimeString("es-ES",{hour:"2-digit",minute:"2-digit"});
      const finHora = c.FECHA_FIN_ESTIMADA ? new Date(c.FECHA_FIN_ESTIMADA).toLocaleTimeString("es-ES",{hour:"2-digit",minute:"2-digit"}) : "-";
      html += `<tr data-cita-id="${c.ID_CITA}"><td><strong>${escapeHtml(c.NOMBRE_PACIENTE)}</strong><br><small>${escapeHtml(c.TELEFONO_PACIENTE || "")}</small></td><td>Dr. ${escapeHtml(c.NOMBRE_DOCTOR)}</td><td><strong>${fecha}</strong><br><small>${hora} • Fin: ${finHora}</small></td><td><span class="ctestado-badge">${escapeHtml(c.ESTADO || "")}</span></td><td>${generarBotonesEstado(c)}</td></tr>`;
    });
    html += "</tbody></table>";
    target.innerHTML = html;
  }

  function generarBotonesEstado(c) {
    const id = c.ID_CITA;
    const s = String(c.ESTADO || "").toUpperCase();
    // Si finalizada o cancelada o no_asistio, mostrar badge estático
    if (s === "FINALIZADA") return `<span class="badge bg-success">FINALIZADA</span>`;
    if (s === "CANCELADA") return `<span class="badge bg-danger">CANCELADA</span>`;
    if (s === "NO_ASISTIO") return `<span class="badge bg-warning text-dark">NO ASISTIÓ</span>`;

    const botones = [];
    if (s === "PROGRAMADA") {
      botones.push(`<button class="ctbtn-accion ctbtn-confirmar" data-action="confirmar" data-id="${id}"><i class="fas fa-check"></i> Confirmar</button>`);
      botones.push(`<button class="ctbtn-accion ctbtn-cancelar" data-action="cancelar" data-id="${id}"><i class="fas fa-times"></i> Cancelar</button>`);
      botones.push(`<button class="ctbtn-accion ctbtn-no-asistio" data-action="no_asistio" data-id="${id}"><i class="fas fa-user-times"></i> No Asistió</button>`);
    } else if (s === "CONFIRMADA") {
      botones.push(`<button class="ctbtn-accion ctbtn-preclinica" data-action="preclinica" data-id="${id}"><i class="fas fa-stethoscope"></i> Ir a Preclínica</button>`);
      botones.push(`<button class="ctbtn-accion ctbtn-cancelar" data-action="cancelar" data-id="${id}"><i class="fas fa-times"></i> Cancelar</button>`);
      botones.push(`<button class="ctbtn-accion ctbtn-no-asistio" data-action="no_asistio" data-id="${id}"><i class="fas fa-user-times"></i> No Asistió</button>`);
    } else {
      // fallback: permitir cancelar/no asistió
      botones.push(`<button class="ctbtn-accion ctbtn-cancelar" data-action="cancelar" data-id="${id}"><i class="fas fa-times"></i> Cancelar</button>`);
      botones.push(`<button class="ctbtn-accion ctbtn-no-asistio" data-action="no_asistio" data-id="${id}"><i class="fas fa-user-times"></i> No Asistió</button>`);
    }
    return `<div class="ctacciones-cita">${botones.join("")}</div>`;
  }

  async function tablaClickHandler(e) {
    const btn = e.target.closest(".ctbtn-accion");
    if (!btn) return;
    const action = btn.dataset.action;
    const id = btn.dataset.id;
    if (!action || !id) return;
    if (processingCitas.has(id)) {
      console.warn(`Acción ignorada: cita ${id} ya en procesamiento`);
      return;
    }
    const map = {
      confirmar: "CONFIRMADA",
      cancelar: "CANCELADA",
      preclinica: "PRECLINICA",
      consulta: "CONSULTA_MEDICA",
      completar: "FINALIZADA",
      no_asistio: "NO_ASISTIO",
    };
    const nuevoEstado = map[action];
    if (!nuevoEstado) return;
    // Confirmación del usuario
    const labels = {
      CONFIRMADA: "Confirmada",
      CANCELADA: "Cancelada",
      PRECLINICA: "Preclínica",
      CONSULTA_MEDICA: "Consulta Médica",
      FINALIZADA: "Finalizada",
      NO_ASISTIO: "No Asistió",
    };
    if (!confirm(`¿Cambiar estado a "${labels[nuevoEstado] || nuevoEstado}"?`)) return;

    processingCitas.add(id);
    try {
      btn.disabled = true;
      await cambiarEstadoCita(id, nuevoEstado);
    } finally {
      btn.disabled = false;
      setTimeout(() => processingCitas.delete(id), 250);
    }
  }

  async function cambiarEstadoCita(idCita, nuevoEstado) {
    try {
      const res = await fetch("/citas/cambiar-estado", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "same-origin",
        body: JSON.stringify({ idCita: Number(idCita), nuevoEstado }),
      });
      const ct = res.headers.get("content-type") || "";
      if (!res.ok) {
        if (ct.includes("application/json")) {
          const j = await res.json().catch(() => null);
          mostrarMensaje("error", (j && j.message) || `Error ${res.status}`);
        } else {
          const txt = await res.text().catch(() => "");
          mostrarMensaje("error", `Error ${res.status}: ${txt ? txt.slice(0,200) : res.statusText}`);
        }
        return;
      }
      const j = ct.includes("application/json") ? await res.json().catch(()=>null) : null;
      const ok = (j && j.success) || res.ok;
      if (!ok) {
        mostrarMensaje("error", (j && j.message) || "Error al actualizar");
        return;
      }

      // Actualizamos el dataset local y recargamos datos para evitar inconsistencias.
      citasData = citasData.map(c => String(c.ID_CITA) === String(idCita) ? { ...c, ESTADO: nuevoEstado, FECHA_MODIFICACION: new Date().toISOString() } : c);
      await cargarDatosReales(true);
      mostrarMensaje("success", (j && j.message) || "Estado actualizado");
    } catch (err) {
      console.error("Error cambiarEstadoCita:", err);
      mostrarMensaje("error", "Error de conexión al cambiar estado");
    }
  }

  function abrirModalNuevaCita() {
    const modal = $("modalNuevaCita");
    if (!modal) return;
    modal.style.display = "flex";
    modal.setAttribute("aria-hidden", "false");
    const inputFecha = $("inputFecha");
    if (inputFecha) inputFecha.min = new Date().toISOString().split("T")[0];
  }
  function cerrarModalNuevaCita() {
    const modal = $("modalNuevaCita");
    if (!modal) return;
    modal.style.display = "none";
    modal.setAttribute("aria-hidden", "true");
    const form = $("formNuevaCita");
    if (form) form.reset();
    if ($("pacienteInfo")) $("pacienteInfo").textContent = "";
    if ($("doctorInfo")) $("doctorInfo").textContent = "";
    if ($("finEstimado")) $("finEstimado").textContent = "-";
    if ($("modalError")) $("modalError").style.display = "none";
  }

  function calcularFinEstimado() {
    const fecha = $("inputFecha")?.value;
    const hora = $("inputHora")?.value;
    const dur = Number($("selectDuracion")?.value || 30);
    if (!fecha || !hora) {
      if ($("finEstimado")) $("finEstimado").textContent = "-";
      return;
    }
    const dt = new Date(`${fecha}T${hora}:00`);
    if (isNaN(dt.getTime())) { if ($("finEstimado")) $("finEstimado").textContent = "-"; return; }
    const fin = new Date(dt.getTime() + dur * 60000);
    if ($("finEstimado")) $("finEstimado").textContent = fin.toLocaleString("es-ES", { hour: "2-digit", minute: "2-digit", day: "2-digit", month: "2-digit", year: "numeric" });
  }

  function onPacienteChange() {
    const sel = $("selectPaciente");
    if (!sel) return;
    const opt = sel.options[sel.selectedIndex];
    if (!opt) { if ($("pacienteInfo")) $("pacienteInfo").textContent = ""; return; }
    const tel = opt.dataset.telefono || "";
    const mail = opt.dataset.correo || "";
    const id = opt.dataset.identidad || "";
    if ($("pacienteInfo")) $("pacienteInfo").textContent = `${id ? "ID: " + id + " • " : ""}${tel ? "Tel: " + tel : ""}${tel && mail ? " • " : ""}${mail ? "Correo: " + mail : ""}`;
  }
  function onDoctorChange() {
    const sel = $("selectDoctor");
    if (!sel) return;
    const opt = sel.options[sel.selectedIndex];
    if (!opt) { if ($("doctorInfo")) $("doctorInfo").textContent = ""; return; }
    const esp = opt.dataset.especialidad || "";
    const mail = opt.dataset.correo || "";
    const id = opt.dataset.identidad || "";
    if ($("doctorInfo")) $("doctorInfo").textContent = `${id ? "ID: " + id + " • " : ""}${esp ? "Especialidad: " + esp : ""}${esp && mail ? " • " : ""}${mail ? "Correo: " + mail : ""}`;
  }

  async function guardarCitaHandler() {
    if (submitInProgress) { console.warn("Ignorando envío: hay un envío en progreso"); return; }
    submitInProgress = true;

    const paciente = $("selectPaciente")?.value;
    const doctor = $("selectDoctor")?.value;
    const fecha = $("inputFecha")?.value;
    const hora = $("inputHora")?.value;
    const duracion = $("selectDuracion")?.value;
    const tipoCita = $("selectTipoCita")?.value;
    const prioridad = $("selectPrioridad")?.value;
    const canal = $("selectCanal")?.value;
    const motivo = $("textareaMotivo")?.value;
    if (!paciente || !doctor || !fecha || !hora) {
      mostrarErrorModal("Complete todos los campos obligatorios");
      submitInProgress = false;
      return;
    }
    const fechaHora = `${fecha}T${hora}:00`;
    const btn = $("btnGuardarCita");
    if (btn) btn.disabled = true;
    try {
      const res = await fetch("/citas/nueva", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "same-origin",
        body: JSON.stringify({ paciente, doctor, fechaCita: fechaHora, tipoCita, prioridad, motivo, duracion, canal })
      });
      const ct = res.headers.get("content-type") || "";
      if (res.status === 409) {
        const j = ct.includes("application/json") ? await res.json().catch(()=>null) : null;
        const msg = j && j.message ? j.message : "Ya existe una cita igual.";
        mostrarErrorModal(msg);
        return;
      }
      if (!res.ok) {
        if (ct.includes("application/json")) {
          const j = await res.json().catch(()=>null);
          mostrarErrorModal((j && j.message) || `Error ${res.status}`);
        } else {
          const t = await res.text().catch(()=>"");
          mostrarErrorModal(`Error ${res.status}: ${t.slice(0,200)}`);
        }
        return;
      }
      const j = ct.includes("application/json") ? await res.json().catch(()=>null) : null;
      if (j && j.success) {
        mostrarMensaje("success", j.message || "Cita creada");
        cerrarModalNuevaCita();
        await cargarDatosReales(true);
      } else {
        mostrarErrorModal((j && j.message) || "Cita creada (respuesta inesperada)");
        await cargarDatosReales(true);
      }
    } catch (err) {
      console.error("Error crear cita", err);
      mostrarErrorModal("Error de conexión: " + err.message);
    } finally {
      if (btn) btn.disabled = false;
      setTimeout(()=>{ submitInProgress = false; }, 400);
    }
  }

  function aplicarFiltros() {
    const est = $("filtroEstado")?.value;
    const doc = $("filtroDoctor")?.value;
    const fecha = $("filtroFecha")?.value;
    let list = [...citasData];
    if (est) list = list.filter(c => c.ESTADO === est);
    if (doc) list = list.filter(c => String(c.ID_DOCTOR) === String(doc));
    if (fecha) list = list.filter(c => new Date(c.FECHA_CITA).toISOString().split("T")[0] === fecha);
    mostrarCitas(list);
  }

  function applyGlobalSearch(q) {
    const s = String(q || "").trim().toLowerCase();
    if (!s) { mostrarCitas(citasData); llenarFiltroDoctores(); return; }
    llenarFiltroDoctores(s);
    const filtered = citasData.filter(c => {
      const patient = (c.NOMBRE_PACIENTE || "").toLowerCase();
      const doctor = (c.NOMBRE_DOCTOR || "").toLowerCase();
      const phone = (c.TELEFONO_PACIENTE || "").toLowerCase();
      const pIdent = (c.IDENTIDAD_PACIENTE || "").toLowerCase();
      const dIdent = (c.IDENTIDAD_DOCTOR || "").toLowerCase();
      const esp = (c.ESPECIALIDAD || "").toLowerCase();
      const dateStr = new Date(c.FECHA_CITA).toLocaleDateString("es-ES").toLowerCase();
      const timeStr = (c.HORA_CITA || "").toLowerCase();
      return patient.includes(s) || doctor.includes(s) || phone.includes(s) || pIdent.includes(s) || dIdent.includes(s) || esp.includes(s) || dateStr.includes(s) || timeStr.includes(s);
    });
    mostrarCitas(filtered);
  }

  function mostrarMensaje(tipo, texto) {
    try {
      if (tipo === "success") {
        const el = $("alertSuccess");
        if (!el) return alert(texto);
        $("successMessage").textContent = texto;
        el.style.display = "flex";
        setTimeout(() => el.style.display = "none", 3500);
      } else {
        const el = $("alertError");
        if (!el) return alert(texto);
        $("errorMessage").textContent = texto;
        el.style.display = "flex";
        setTimeout(() => el.style.display = "none", 5000);
      }
    } catch (e) { console.warn("mostrarMensaje error:", e); }
  }

  function mostrarErrorModal(texto) {
    const el = $("modalError");
    if (!el) return alert(texto);
    $("modalErrorMessage").textContent = texto;
    el.style.display = "block";
  }

  async function imageToBase64(url, maxWidth = 100) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => {
        try {
          const scale = img.width > maxWidth ? maxWidth / img.width : 1;
          const canvas = document.createElement("canvas");
          canvas.width = img.width * scale;
          canvas.height = img.height * scale;
          const ctx = canvas.getContext("2d");
          ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
          resolve(canvas.toDataURL("image/png"));
        } catch (e) { reject(e); }
      };
      img.onerror = (e) => reject(e);
      img.src = "/roca-maya-oct.jpg" + "?_t=" + Date.now();
    });
  }

  async function imprimirListado() {
    const contenido = $("tablaContenido");
    if (!contenido) { alert("No hay contenido para imprimir."); return; }
    let logoData = null;
    try { logoData = await imageToBase64("/roca-maya-oct.jpg", 100); } catch (e) { logoData = null; }
    const nowLabel = new Date().toLocaleString();
    const headerHtml = `<div style="display:flex;align-items:center;gap:12px;margin-bottom:12px;">${logoData ? `<img src="${logoData}" style="height:64px;object-fit:contain"/>` : ""}<div><div style="font-size:18px;font-weight:700;">Clínicas Roca Maya</div><div style="font-size:13px;color:#666;">Listado de Citas</div><div style="font-size:12px;color:#666;margin-top:6px;">Generado: ${nowLabel}</div></div></div>`;
    const w = window.open("", "_blank", "width=900,height=700,scrollbars=yes");
    w.document.write(`<html><head><meta charset="utf-8" /><title>Imprimir - Citas</title><style>body{font-family:Arial,Helvetica,sans-serif;padding:20px;color:#222;}table{width:100%;border-collapse:collapse;font-size:12px;}th,td{text-align:left;padding:8px;border:1px solid #e6e6e6;vertical-align:top;}th{background:#f7f7f7;font-weight:700;}</style></head><body>${headerHtml}${contenido.innerHTML}</body></html>`);
    w.document.close();
    setTimeout(()=>{ try { w.print(); w.close(); } catch(e) {} }, 600);
  }

  document.addEventListener("DOMContentLoaded", () => {
    cargarDatosReales();

    $("btnNuevaCitaHeader")?.addEventListener("click", abrirModalNuevaCita);
    const btnCrearPrimera = $("btnCrearPrimera");
    if (btnCrearPrimera && !btnCrearPrimera.dataset.listenerAttached) {
      btnCrearPrimera.addEventListener("click", abrirModalNuevaCita);
      btnCrearPrimera.dataset.listenerAttached = "1";
    }
    $("btnCancelarModal")?.addEventListener("click", cerrarModalNuevaCita);
    $("btnCloseModal")?.addEventListener("click", cerrarModalNuevaCita);
    const btnGuardar = $("btnGuardarCita");
    if (btnGuardar && !btnGuardar.dataset.listenerAttached) {
      btnGuardar.type = "button";
      btnGuardar.addEventListener("click", guardarCitaHandler);
      btnGuardar.dataset.listenerAttached = "1";
    }

    const tabla = $("tablaContenido");
    if (tabla) {
      tabla.removeEventListener("click", tablaClickHandler);
      tabla.addEventListener("click", tablaClickHandler);
    }

    $("selectPaciente")?.addEventListener("change", onPacienteChange);
    $("selectDoctor")?.addEventListener("change", onDoctorChange);
    $("inputFecha")?.addEventListener("change", calcularFinEstimado);
    $("inputHora")?.addEventListener("change", calcularFinEstimado);
    $("selectDuracion")?.addEventListener("change", calcularFinEstimado);
    $("filtroEstado")?.addEventListener("change", aplicarFiltros);
    $("filtroDoctor")?.addEventListener("change", aplicarFiltros);
    $("filtroFecha")?.addEventListener("change", aplicarFiltros);

    const searchPaciente = $("searchPaciente");
    const searchDoctor = $("searchDoctor");
    const searchGlobal = $("searchGlobal");
    if (searchPaciente) searchPaciente.addEventListener("input", debounce((e) => llenarSelectPacientes(e.target.value), 200));
    if (searchDoctor) searchDoctor.addEventListener("input", debounce((e) => llenarSelectDoctores(e.target.value), 200));
    if (searchGlobal) searchGlobal.addEventListener("input", debounce((e) => { const q = e.target.value; llenarFiltroDoctores(q); applyGlobalSearch(q); }, 200));
    $("btnImprimir")?.addEventListener("click", imprimirListado);

    const logoBtn = $("logoBtn");
    if (logoBtn) {
      logoBtn.addEventListener("click", (e) => { e.preventDefault(); window.location.href = "/dashboard"; });
      logoBtn.addEventListener("keydown", (e) => { if (e.key === "Enter" || e.key === " ") { e.preventDefault(); logoBtn.click(); } });
    }

    const modal = $("modalNuevaCita");
    if (modal) modal.addEventListener("click", (e) => { if (e.target === modal) cerrarModalNuevaCita(); });

    try {
      const bc = new BroadcastChannel("citas_channel");
      bc.onmessage = (ev) => {
        const d = ev.data || {};
        if (!d) return;
        if (d.type === "estado_cita" || d.type === "preclinica_saved" || d.type === "consulta_saved") cargarDatosReales(true);
      };
    } catch (e) { console.warn("BroadcastChannel no soportado", e); }
  });

  window.__citas_debug = { cargarDatosReales, get citas() { return citasData; }, get doctores() { return doctoresData; }, get pacientes() { return pacientesData; } };
})();