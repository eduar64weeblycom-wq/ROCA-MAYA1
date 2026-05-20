// public/js/consultaMedica.js
// Actualizado: - ocultar botones para citas CANCELADA / NO_ASISTIO
//           - validación antes de guardar (no permite guardar si faltan campos obligatorios)
//           - se eliminan campos Código CIE10 y Próxima cita del flujo de guardado
(() => {
  const $ = id => document.getElementById(id);

  let citas = [];
  let consultas = [];
  let consultasMap = {};
  let saving = false;

  function escapeHtml(s) { if (s === undefined || s === null) return ""; return String(s).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;"); }
  function debounce(fn, wait = 220) { let t; return (...a) => { clearTimeout(t); t = setTimeout(()=>fn(...a), wait); }; }

  function safeEstadoClass(estado) { if (!estado) return ""; return "ctestado-" + String(estado).toLowerCase().replace(/[^a-z0-9]+/g, "_"); }

  async function cargarDatos() {
    try {
      const res = await fetch("/consultaMedica/api/datos", { credentials: "same-origin" });
      if (!res.ok) throw new Error("HTTP " + res.status);
      const j = await res.json();
      citas = j.citas || [];
      citas.sort((a,b) => (Number(b.ID_CITA)||0)-(Number(a.ID_CITA)||0));
      consultas = j.consultas || [];
      consultasMap = {};
      (consultas || []).forEach(c => { if (c.ID_CITA != null) consultasMap[c.ID_CITA] = c; });
      renderTabla();
      llenarSelectCitas();
    } catch (err) {
      console.error("Error cargando citas/consultas para Consulta:", err);
      mostrarAlerta("error", "Error cargando citas/consultas: " + err.message);
    }
  }

  function renderTabla(filter = {}) {
    const target = $("tablaContenidoConsulta");
    if (!target) return;
    let list = [...citas];
    if (filter.q) {
      const q = String(filter.q).trim().toLowerCase();
      list = list.filter(c => {
        const patient = (c.NOMBRE_PACIENTE || "").toLowerCase();
        const doctor = (c.NOMBRE_DOCTOR || "").toLowerCase();
        const phone = (c.TELEFONO || "").toLowerCase();
        const dateStr = new Date(c.FECHA_CITA).toLocaleDateString("es-ES").toLowerCase();
        return patient.includes(q) || doctor.includes(q) || phone.includes(q) || dateStr.includes(q);
      });
    }
    if (filter.fecha) list = list.filter(c => new Date(c.FECHA_CITA).toISOString().split("T")[0] === filter.fecha);
    if (filter.tipo) list = list.filter(c => c.TIPO_CITA === filter.tipo);
    if (!list.length) {
      target.innerHTML = `<div class="ctsin-citas"><i class="fas fa-notes-medical"></i><h3>No hay citas</h3><p>Usa los filtros para encontrar citas.</p></div>`;
      return;
    }
    let html = `<div class="cttabla-consulta"><table class="table"><thead><tr><th>ID</th><th>Fecha</th><th>Paciente</th><th>Doctor</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>`;
    list.forEach(c => {
      const fecha = new Date(c.FECHA_CITA).toLocaleDateString("es-ES");
      const hora = c.HORA_CITA || new Date(c.FECHA_CITA).toLocaleTimeString("es-ES",{hour:"2-digit",minute:"2-digit"});
      const estadoClass = safeEstadoClass(c.ESTADO || "");
      const hasConsulta = !!consultasMap[c.ID_CITA];
      // Si la cita está CANCELADA o NO_ASISTIO no mostramos botones
      const estadoUpper = String(c.ESTADO || "").toUpperCase();
      const accionesPermitidas = (estadoUpper !== "CANCELADA" && estadoUpper !== "NO_ASISTIO");
      html += `<tr data-id="${c.ID_CITA}"><td>#${c.ID_CITA}</td><td>${fecha}<br><small>${hora}</small></td><td><strong>${escapeHtml(c.NOMBRE_PACIENTE)}</strong><br><small>${escapeHtml(c.TELEFONO || "")}</small></td><td>Dr. ${escapeHtml(c.NOMBRE_DOCTOR || "")}</td><td><span class="ctestado-badge ${estadoClass}">${escapeHtml(c.ESTADO || "")}</span></td><td><div class="ctacciones-consulta">`;
      if (accionesPermitidas) {
        html += `<button class="ctbtn-accion" data-action="abrirConsulta" data-id="${c.ID_CITA}"><i class="fas fa-user-md"></i> Abrir</button>`;
        if (hasConsulta) html += ` <button class="ctbtn-accion edit" data-action="editarConsulta" data-id="${c.ID_CITA}"><i class="fas fa-edit"></i> Editar</button>`;
        html += ` ${ c.ESTADO !== 'CANCELADA' ? `<button class="ctbtn-accion ctbtn-cancelar" data-action="cancelar" data-id="${c.ID_CITA}"><i class="fas fa-times"></i> Cancelar</button>` : "" }`;
        html += ` ${ c.ESTADO !== 'NO_ASISTIO' ? `<button class="ctbtn-accion ctbtn-no-asistio" data-action="no_asistio" data-id="${c.ID_CITA}"><i class="fas fa-user-times"></i> No Asistió</button>` : "" }`;
      } else {
        html += `<span class="text-muted">Sin acciones</span>`;
      }
      html += `</div></td></tr>`;
    });
    html += `</tbody></table></div>`;
    target.innerHTML = html;
  }

  function llenarSelectCitas(filter = "") {
    const sel = $("selectCitaConsulta");
    if (!sel) return;
    sel.innerHTML = '<option value="">Seleccionar cita...</option>';
    const q = String(filter || "").trim().toLowerCase();
    citas.forEach(c => {
      const label = `#${c.ID_CITA} — ${c.NOMBRE_PACIENTE} • ${new Date(c.FECHA_CITA).toLocaleString("es-ES")}`;
      if (q && !label.toLowerCase().includes(q) && !(c.TELEFONO || "").toLowerCase().includes(q)) return;
      const opt = document.createElement("option");
      opt.value = c.ID_CITA;
      opt.textContent = label;
      opt.dataset.telefono = c.TELEFONO || "";
      opt.dataset.correo = c.CORREO_PACIENTE || "";
      // include estado to allow validation when selecting
      opt.dataset.estado = c.ESTADO || "";
      sel.appendChild(opt);
    });
  }

  function abrirModalConsulta() {
    const modal = $("modalConsulta");
    if (!modal) return;
    modal.style.display = "flex";
    modal.setAttribute("aria-hidden", "false");
    limpiarModalConsulta();
  }
  function cerrarModalConsulta() {
    const modal = $("modalConsulta");
    if (!modal) return;
    modal.style.display = "none";
    modal.setAttribute("aria-hidden", "true");
  }

  function limpiarPreclinicaFields() {
    const ids = ["pre_TEMPERATURA","pre_PRESION_SISTOLICA","pre_PRESION_DIASTOLICA","pre_PESO","pre_TALLA","pre_IMC","pre_FC","pre_FR","pre_SATURACION","pre_GLUCOSA","pre_PERIMETRO","pre_OBSERVACIONES"];
    ids.forEach(id => { const el = $(id); if (el) { if (el.tagName === "TEXTAREA" || el.tagName === "INPUT") el.value = ""; } });
    const preBox = $("preclinicaInfoConsulta"); if (preBox) preBox.style.display = "none";
    const preSummary = $("preclinicaContenidoConsulta"); if (preSummary) preSummary.style.display = "none";
  }

  function limpiarModalConsulta() {
    const safe = id => { const el = $(id); if (el) el.value = ""; };
    safe("idConsulta"); safe("motivoConsulta"); safe("sintomasConsulta"); safe("examenFisicoConsulta"); safe("diagnosticoPrincipal");
    safe("tratamiento"); safe("recomendaciones"); if ($("tipoConsulta")) $("tipoConsulta").value = "GENERAL";
    if ($("modalErrorConsulta")) $("modalErrorConsulta").style.display = "none";
    if ($("pacienteInfoConsulta")) $("pacienteInfoConsulta").textContent = "";
    limpiarPreclinicaFields();
    // clear inline validation errors
    ["selectCitaConsulta","diagnosticoPrincipal","sintomasConsulta","tratamiento"].forEach(id => {
      const el = $(id); if (!el) return; el.classList.remove("field-error"); const err = $(id + "-error"); if (err) { err.textContent = ""; err.style.display = "none"; }
    });
  }

  function llenarModalConConsulta(c) {
    if (!c) return;
    if ($("idConsulta")) $("idConsulta").value = c.ID_CONSULTA || "";
    if ($("motivoConsulta")) $("motivoConsulta").value = c.MOTIVO_CONSULTA || "";
    if ($("sintomasConsulta")) $("sintomasConsulta").value = Array.isArray(c.SINTOMAS) ? c.SINTOMAS.join("\n") : (typeof c.SINTOMAS === "string" ? c.SINTOMAS : JSON.stringify(c.SINTOMAS || ""));
    if ($("examenFisicoConsulta")) $("examenFisicoConsulta").value = Array.isArray(c.EXAMEN_FISICO) ? c.EXAMEN_FISICO.join("\n") : (typeof c.EXAMEN_FISICO === "string" ? c.EXAMEN_FISICO : JSON.stringify(c.EXAMEN_FISICO || ""));
    if ($("diagnosticoPrincipal")) $("diagnosticoPrincipal").value = c.DIAGNOSTICO_PRINCIPAL || "";
    if ($("tratamiento")) $("tratamiento").value = c.TRATAMIENTO || "";
    if ($("recomendaciones")) $("recomendaciones").value = c.RECOMENDACIONES || "";
    if ($("tipoConsulta")) $("tipoConsulta").value = c.TIPO_CONSULTA || "GENERAL";
  }

  async function cargarPreclinicaYMostrar(idCita) {
    try {
      const r2 = await fetch(`/preclinica/por-cita/${idCita}`, { credentials: "same-origin" });
      if (!r2.ok) {
        if (r2.status === 404) { limpiarPreclinicaFields(); return; }
        throw new Error("HTTP " + r2.status);
      }
      const pj = await r2.json();
      if (pj && pj.success && pj.preclinica) {
        const p = pj.preclinica;
        const set = (id,val) => { const el = $(id); if (!el) return; el.value = val == null ? "" : String(val); };
        set("pre_TEMPERATURA", p.TEMPERATURA ?? "");
        set("pre_PRESION_SISTOLICA", p.PRESION_SISTOLICA ?? "");
        set("pre_PRESION_DIASTOLICA", p.PRESION_DIASTOLICA ?? "");
        set("pre_PESO", p.PESO ?? "");
        set("pre_TALLA", p.TALLA ?? "");
        set("pre_IMC", p.IMC ?? (p.PESO && p.TALLA ? (Number(p.PESO)/(Number(p.TALLA)*Number(p.TALLA))).toFixed(2) : ""));
        set("pre_FC", p.FRECUENCIA_CARDIACA ?? "");
        set("pre_FR", p.FRECUENCIA_RESPIRATORIA ?? "");
        set("pre_SATURACION", p.SATURACION_OXIGENO ?? "");
        set("pre_GLUCOSA", p.GLUCOSA ?? "");
        set("pre_PERIMETRO", p.PERIMETRO_ABDOMINAL ?? "");
        set("pre_OBSERVACIONES", p.OBSERVACIONES ?? "");
        const preBox = $("preclinicaInfoConsulta"); if (preBox) preBox.style.display = "block";
        const preSummary = $("preclinicaContenidoConsulta"); if (preSummary) preSummary.style.display = "none";
      } else { limpiarPreclinicaFields(); }
    } catch (err) {
      console.warn("No se pudo cargar preclinica:", err);
      limpiarPreclinicaFields();
      const preSummary = $("preclinicaContenidoConsulta");
      if (preSummary) { preSummary.style.display = "block"; preSummary.innerHTML = `<em>No se pudo cargar resumen de preclinica: ${escapeHtml(err.message)}</em>`; }
    }
  }

  async function cargarConsultaEnModal(idCita) {
    if (!idCita) return;
    // check state of cita to avoid opening for CANCELADA/NO_ASISTIO
    const cita = citas.find(x => String(x.ID_CITA) === String(idCita));
    const estado = cita ? String(cita.ESTADO || "").toUpperCase() : "";
    if (estado === "CANCELADA" || estado === "NO_ASISTIO") {
      mostrarAlerta("error", `No se permite abrir una cita con estado ${estado}.`);
      return;
    }

    try {
      const res = await fetch(`/consultaMedica/por-cita/${idCita}`, { credentials: "same-origin" });
      if (res.status === 404) {
        abrirModalConsulta();
        if ($("selectCitaConsulta")) { $("selectCitaConsulta").value = idCita; $("selectCitaConsulta").dispatchEvent(new Event("change")); }
        cargarPreclinicaYMostrar(idCita);
        return;
      }
      if (!res.ok) throw new Error("HTTP " + res.status);
      const j = await res.json();
      if (j && j.success && j.consulta) {
        abrirModalConsulta();
        if ($("selectCitaConsulta")) { $("selectCitaConsulta").value = idCita; $("selectCitaConsulta").dispatchEvent(new Event("change")); }
        llenarModalConConsulta(j.consulta);
        cargarPreclinicaYMostrar(idCita);
        setTimeout(()=>{ const d = $("diagnosticoPrincipal"); if (d) d.focus(); }, 200);
      } else {
        abrirModalConsulta();
        if ($("selectCitaConsulta")) { $("selectCitaConsulta").value = idCita; $("selectCitaConsulta").dispatchEvent(new Event("change")); }
        cargarPreclinicaYMostrar(idCita);
      }
    } catch (err) {
      console.error("Error cargando consulta por cita:", err);
      if ($("modalErrorConsulta")) { $("modalErrorConsulta").textContent = "Error cargando datos de la consulta: " + err.message; $("modalErrorConsulta").style.display = "flex"; }
    }
  }

  async function onSelectCitaChange() {
    const id = $("selectCitaConsulta")?.value;
    if ($("pacienteInfoConsulta")) $("pacienteInfoConsulta").textContent = "";
    const preBox = $("preclinicaInfoConsulta"); const preContent = $("preclinicaContenidoConsulta");
    if (preBox) preBox.style.display = "none";
    if (preContent) preContent.innerHTML = "";
    if (!id) { limpiarModalConsulta(); return; }
    const opt = $("selectCitaConsulta").selectedOptions[0];
    if (opt) {
      const info = [];
      if (opt.dataset.telefono) info.push("Tel: " + opt.dataset.telefono);
      if (opt.dataset.correo) info.push(opt.dataset.correo);
      if ($("pacienteInfoConsulta")) $("pacienteInfoConsulta").textContent = info.join(" • ");
      // if cita is CANCELADA or NO_ASISTIO, show notice and disable form
      const estado = (opt.dataset.estado || "").toUpperCase();
      if (estado === "CANCELADA" || estado === "NO_ASISTIO") {
        mostrarAlerta("error", `La cita está en estado ${estado} y no se puede editar/crear consulta.`);
        // hide form controls to prevent accidental save
        ["motivoConsulta","sintomasConsulta","examenFisicoConsulta","diagnosticoPrincipal","tratamiento","recomendaciones","tipoConsulta","btnGuardarConsulta"].forEach(id => {
          const el = $(id); if (!el) return; el.disabled = true;
        });
      } else {
        ["motivoConsulta","sintomasConsulta","examenFisicoConsulta","diagnosticoPrincipal","tratamiento","recomendaciones","tipoConsulta","btnGuardarConsulta"].forEach(id => {
          const el = $(id); if (!el) return; el.disabled = false;
        });
      }
    }
    try {
      const res = await fetch(`/consultaMedica/por-cita/${id}`, { credentials: "same-origin" });
      if (res.status === 404) { if ($("idConsulta")) $("idConsulta").value = ""; }
      else if (!res.ok) throw new Error("HTTP " + res.status);
      else { const j = await res.json(); if (j && j.success && j.consulta) { llenarModalConConsulta(j.consulta); } }
    } catch (err) {
      console.error("Error cargando consulta por cita:", err);
      if ($("modalErrorConsulta")) { $("modalErrorConsulta").textContent = "Error cargando datos de la consulta: " + err.message; $("modalErrorConsulta").style.display = "flex"; }
    }
    cargarPreclinicaYMostrar(id);
  }

  function textAreaToArray(value) { if (!value) return []; return value.split("\n").map(s=>s.trim()).filter(Boolean); }

  // Validación antes de guardar: exige cita seleccionada y campos obligatorios:
  // - diagnóstico principal (no vacio)
  // - tratamiento (no vacio)
  // - síntomas o examen físico (al menos uno)
  function validateConsultaFormAndShowErrors() {
    const clearErrors = () => {
      ["selectCitaConsulta","diagnosticoPrincipal","tratamiento","sintomasConsulta","examenFisicoConsulta"].forEach(id => {
        const el = $(id); if (el) el.classList.remove("field-error");
        const err = $(id + "-error"); if (err) { err.textContent = ""; err.style.display = "none"; }
      });
      if ($("modalErrorConsulta")) { $("modalErrorConsulta").style.display = "none"; $("modalErrorConsulta").textContent = ""; }
    };
    clearErrors();
    const idCita = $("selectCitaConsulta")?.value;
    const diag = $("diagnosticoPrincipal")?.value?.trim() || "";
    const trat = $("tratamiento")?.value?.trim() || "";
    const sintomas = $("sintomasConsulta")?.value?.trim() || "";
    const examen = $("examenFisicoConsulta")?.value?.trim() || "";

    const errors = [];
    if (!idCita) errors.push({ field: "selectCitaConsulta", message: "Seleccione la cita." });
    if (!diag) errors.push({ field: "diagnosticoPrincipal", message: "Diagnóstico principal es obligatorio." });
    if (!trat) errors.push({ field: "tratamiento", message: "Tratamiento es obligatorio." });
    if (!sintomas && !examen) errors.push({ field: "sintomasConsulta", message: "Registre síntomas o examen físico (al menos uno)." });

    if (errors.length) {
      errors.forEach(e => {
        const el = $(e.field); if (el) el.classList.add("field-error");
        const errEl = $(e.field + "-error"); if (errEl) { errEl.textContent = e.message; errEl.style.display = "block"; }
      });
      const topMsg = errors.map(e => e.message).join(" ");
      if ($("modalErrorConsulta")) { $("modalErrorConsulta").textContent = topMsg; $("modalErrorConsulta").style.display = "block"; }
      return false;
    }
    return true;
  }

  async function guardarConsultaHandler() {
    if (saving) return;
    // Validate form
    if (!validateConsultaFormAndShowErrors()) return;

    const idConsulta = $("idConsulta")?.value || null;
    const idCita = $("selectCitaConsulta")?.value;
    if (!idCita) { mostrarModalError("Seleccione la cita antes de guardar."); return; }
    const payload = {
      idCita: Number(idCita),
      motivoConsulta: $("motivoConsulta")?.value || null,
      sintomas: textAreaToArray($("sintomasConsulta")?.value || ""),
      examenFisico: textAreaToArray($("examenFisicoConsulta")?.value || ""),
      diagnosticoPrincipal: $("diagnosticoPrincipal")?.value || null,
      tratamiento: $("tratamiento")?.value || null,
      recomendaciones: $("recomendaciones")?.value || null,
      tipoConsulta: $("tipoConsulta")?.value || "GENERAL",
    };
    if (idConsulta) payload.idConsulta = Number(idConsulta);
    const btn = $("btnGuardarConsulta");
    if (btn) btn.disabled = true;
    saving = true;
    try {
      const url = idConsulta ? "/consultaMedica/actualizar" : "/consultaMedica/nueva";
      const res = await fetch(url, { method: "POST", headers: { "Content-Type": "application/json" }, credentials: "same-origin", body: JSON.stringify(payload) });
      const ct = res.headers.get("content-type") || "";
      const j = ct.includes("application/json") ? await res.json().catch(()=>null) : null;
      if (!res.ok) {
        if (res.status === 409) mostrarModalError((j && j.message) || "Ya existe una consulta para esta cita.");
        else mostrarModalError((j && j.message) || `Error ${res.status}`);
        return;
      }
      mostrarAlerta("success", (j && j.message) || "Consulta guardada correctamente");
      cerrarModalConsulta();
      await cargarDatos();
      try { const bc = new BroadcastChannel("citas_channel"); bc.postMessage({ type: "consulta_saved", idCita: Number(idCita), idConsulta: j && j.idConsulta ? j.idConsulta : null, nuevoEstado: "FINALIZADA" }); bc.postMessage({ type: "estado_cita", id: Number(idCita), nuevoEstado: "FINALIZADA" }); bc.close(); } catch (e) {}
    } catch (err) {
      console.error("Error guardando consulta:", err);
      mostrarModalError("Error de conexión: " + err.message);
    } finally {
      saving = false;
      if (btn) btn.disabled = false;
    }
  }

  function imprimirListado() {
    const contenido = document.querySelector(".cttabla-consulta") || $("tablaContenidoConsulta");
    if (!contenido) { alert("No hay contenido para imprimir."); return; }
    const now = new Date().toLocaleString();
    const header = `<div style="display:flex;align-items:center;gap:12px;margin-bottom:12px;"><img src="/roca-maya-oct.jpg" style="height:64px;object-fit:contain"/><div><div style="font-size:18px;font-weight:700;">Clínicas Roca Maya</div><div style="font-size:13px;color:#666;">Listado de Consultas</div><div style="font-size:12px;color:#666;margin-top:6px;">Generado: ${now}</div></div></div>`;
    const w = window.open("", "_blank", "width=900,height=700,scrollbars=yes");
    w.document.write(`<html><head><meta charset="utf-8"><title>Imprimir - Consultas</title><style>body{font-family:Arial,Helvetica,sans-serif;padding:20px;color:#222;}table{width:100%;border-collapse:collapse;font-size:12px;}th,td{text-align:left;padding:8px;border:1px solid #e6e6e6;vertical-align:top;}th{background:#f7f7f7;font-weight:700;}</style></head><body>${header}${contenido.outerHTML}</body></html>`);
    w.document.close();
    setTimeout(()=>{ try { w.print(); w.close(); } catch (e) {} }, 600);
  }

  function mostrarAlerta(tipo, texto) {
    try {
      if (tipo === "success") {
        const el = $("alertSuccessConsulta");
        if (!el) return alert(texto);
        $("successMessageConsulta").textContent = texto;
        el.style.display = "flex";
        setTimeout(()=>el.style.display = "none", 3500);
      } else {
        const el = $("alertErrorConsulta");
        if (!el) return alert(texto);
        $("errorMessageConsulta").textContent = texto;
        el.style.display = "flex";
        setTimeout(()=>el.style.display = "none", 5000);
      }
    } catch (e) { console.warn("mostrarAlerta", e); }
  }
  function mostrarModalError(txt) { const el = $("modalErrorConsulta"); if (!el) return alert(txt); el.textContent = txt; el.style.display = "flex"; }

  document.addEventListener("click", (ev) => {
    const btn = ev.target.closest("button, a");
    if (!btn) return;
    const action = btn.dataset.action || "";
    if (btn.id === "btnCancelarConsulta" || action === "cancelarConsulta") { ev.preventDefault(); cerrarModalConsulta(); return; }
    if (btn.id === "btnGuardarConsulta" || action === "guardarConsulta") { ev.preventDefault(); guardarConsultaHandler(); return; }
    if (btn.id === "btnImprimir" || action === "imprimir") { ev.preventDefault(); imprimirListado(); return; }
    if (action === "abrirConsulta") {
      ev.preventDefault();
      const id = btn.dataset.id;
      if (id) cargarConsultaEnModal(id);
      return;
    }
    if (action === "editarConsulta") {
      ev.preventDefault();
      const id = btn.dataset.id;
      if (id) cargarConsultaEnModal(id);
      return;
    }
    if (action === "cancelar") {
      ev.preventDefault();
      const id = btn.dataset.id;
      if (!id) return;
      if (!confirm("¿Cancelar la cita?")) return;
      cambiarEstado(id, "CANCELADA");
      return;
    }
    if (action === "no_asistio") {
      ev.preventDefault();
      const id = btn.dataset.id;
      if (!id) return;
      if (!confirm("¿Marcar como NO ASISTIÓ?")) return;
      cambiarEstado(id, "NO_ASISTIO");
      return;
    }
  }, { passive: false });

  async function cambiarEstado(idCita, nuevoEstado) {
    try {
      const res = await fetch("/citas/cambiar-estado", { method: "POST", headers: { "Content-Type": "application/json" }, credentials: "same-origin", body: JSON.stringify({ idCita: Number(idCita), nuevoEstado }) });
      const ct = res.headers.get("content-type") || "";
      const j = ct.includes("application/json") ? await res.json().catch(()=>null) : null;
      if (!res.ok) { mostrarAlerta("error", (j && j.message) || "Error al cambiar estado"); return; }
      mostrarAlerta("success", (j && j.message) || "Estado actualizado");
      await cargarDatos();
      try { const bc = new BroadcastChannel("citas_channel"); bc.postMessage({ type: "estado_cita", id: Number(idCita), nuevoEstado }); bc.close(); } catch (e) {}
    } catch (err) {
      console.error("Error cambiar estado:", err);
      mostrarModalError("Error de conexión: " + err.message);
    }
  }

  document.addEventListener("DOMContentLoaded", () => {
    ["btnGuardarConsulta","btnCancelarConsulta","btnNuevaConsulta","btnImprimir","btnCerrarModalConsulta"].forEach(id=>{ const el = $(id); if (el && el.tagName === "BUTTON") el.type = "button"; });
    const logoBtn = $("logoBtn"); if (logoBtn) { logoBtn.type = "button"; logoBtn.addEventListener("click", e => { e.preventDefault(); window.location.href = "/"; }); }
    $("searchConsulta")?.addEventListener("input", debounce((e)=>{ renderTabla({ q: e.target.value }); llenarSelectCitas(e.target.value); }, 200));
    $("filtroFechaConsulta")?.addEventListener("change", (e)=>renderTabla({ fecha: e.target.value }));
    $("filtroTipoConsulta")?.addEventListener("change", (e)=>renderTabla({ tipo: e.target.value }));
    const sel = $("selectCitaConsulta"); if (sel) sel.addEventListener("change", onSelectCitaChange);
    $("btnNuevaConsulta")?.addEventListener("click", ()=>abrirModalConsulta());
    $("btnCerrarModalConsulta")?.addEventListener("click", cerrarModalConsulta);
    $("btnCancelarConsulta")?.addEventListener("click", cerrarModalConsulta);
    $("btnGuardarConsulta")?.addEventListener("click", guardarConsultaHandler);
    $("btnImprimir")?.addEventListener("click", imprimirListado);

    window.cargarDatos = cargarDatos;
    window.guardarConsultaHandler = guardarConsultaHandler;

    cargarDatos();
  });
})();