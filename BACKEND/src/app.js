const express = require("express");
const path = require("path");
const helmet = require("helmet");
const cors = require("cors");
const morgan = require("morgan");
const cookieParser = require("cookie-parser");
const rateLimit = require("express-rate-limit");
const errorHandler = require("./middleware/errorHandler");
const fs = require("fs");
// Cambio 1: Importar el router de recibos
const reciboRoutes = require('./routes/recibo.routes'); 
const EventEmitter = require("events");
const emitter = new EventEmitter();

const pool = require("./database/db");
const { registrarBitacora } = require("./services/bitacora.service");
const { enviarCorreo } = require("./services/email.service");

const app = express();

app.use(helmet());
app.use(cors());
app.use(morgan("dev"));
app.use(cookieParser());

app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: "Demasiadas solicitudes. Intenta más tarde.",
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(express.static(path.join(__dirname, "public")));

app.set("emitter", emitter);

// RUTA para descargar backup (ajusta la ruta según tu PC)
app.get("/descargar-backup", (req, res) => {
  try {
    const filePath = "C:/Users/esthe/Desktop/BACKEND/src/Roca_Maya.sql";
    if (fs.existsSync(filePath)) {
      res.setHeader("Content-Type", "application/sql");
      res.setHeader(
        "Content-Disposition",
        'attachment; filename="Roca_Maya.sql"'
      );
      res.sendFile(filePath);
    } else {
      const backupContent = `-- Backup Clínicas Roca Maya\n-- Fecha: ${new Date().toLocaleString()}\n-- Backup temporal`;
      res.setHeader("Content-Type", "application/sql");
      res.setHeader(
        "Content-Disposition",
        'attachment; filename="Backup_Temporal.sql"'
      );
      res.send(backupContent);
    }
  } catch (error) {
    console.error("Error:", error);
    res.status(500).send("Error: " + error.message);
  }
});

// Event listener para envío de emails cuando se emita 'cita:creada'
emitter.on("cita:creada", async (payload) => {
  try {
    const {
      idCita,
      pacienteId,
      doctorId,
      fecha,
      durMin,
      canal,
      motivo,
      usuario,
    } = payload;
    const usuarioStr = usuario || "SISTEMA";

    const [pacRows] = await pool.query(
      `SELECT NOMBRES, APELLIDOS, CORREO_ELECTRONICO FROM TBL_PACIENTE WHERE ID_PACIENTE = ? LIMIT 1`,
      [pacienteId]
    );
    const pacienteRow = pacRows && pacRows[0] ? pacRows[0] : null;

    const [docRows] = await pool.query(
      `SELECT NOMBRE_USUARIO, CORREO_ELECTRONICO FROM TBL_MS_USUARIO WHERE ID_USUARIO = ? LIMIT 1`,
      [doctorId]
    );
    const doctorRow = docRows && docRows[0] ? docRows[0] : null;

    if (!pacienteRow || !pacienteRow.CORREO_ELECTRONICO) {
      await registrarBitacora({
        usuario: usuarioStr,
        accion: "ENVIO_EMAIL_CITA",
        descripcion: `No se envió email: paciente ID ${pacienteId} no tiene correo registrado`,
        modulo: "CITAS",
        idRegistro: idCita,
        tabla: "TBL_PACIENTE",
        estado: "ADVERTENCIA",
        req: null,
      });
      return;
    }

    const pacienteNombre =
      `${pacienteRow.NOMBRES} ${pacienteRow.APELLIDOS}`.trim();
    const doctorNombre =
      doctorRow && doctorRow.NOMBRE_USUARIO
        ? doctorRow.NOMBRE_USUARIO
        : "Dr/a. (sin especificar)";
    const fechaObj = fecha instanceof Date ? fecha : new Date(fecha);
    const fechaReadable = fechaObj.toLocaleDateString("es-ES", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
    const horaReadable = fechaObj.toLocaleTimeString("es-ES", {
      hour: "2-digit",
      minute: "2-digit",
    });
    const duracionReadable = `${durMin || 30} minutos`;

    const esc = (s) =>
      s === undefined || s === null
        ? ""
        : String(s)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");

    const subject = `Confirmación de cita - Clínicas Roca Maya (${fechaReadable} ${horaReadable})`;
    const html = `
      <div style="font-family:Arial,Helvetica,sans-serif;color:#222;">
        <p>Estimado(a) <strong>${esc(pacienteNombre)}</strong>,</p>
        <p>Se ha programado una cita médica en <strong>Clínicas Roca Maya</strong> con los siguientes detalles:</p>
        <ul>
          <li><strong>Fecha:</strong> ${esc(fechaReadable)}</li>
          <li><strong>Hora:</strong> ${esc(horaReadable)}</li>
          <li><strong>Doctor(a):</strong> ${esc(doctorNombre)}</li>
          <li><strong>Duración estimada:</strong> ${esc(duracionReadable)}</li>
          <li><strong>Canal:</strong> ${esc(canal || "PRESENCIAL")}</li>
          <li><strong>Motivo:</strong> ${esc(motivo || "No especificado")}</li>
        </ul>
        <p>Por favor llegue con 10 minutos de anticipación y lleve su identificación.</p>
        <p>Saludos cordiales,<br/>Clínicas Roca Maya</p>
      </div>
    `;

    let sent = false;
    try {
      const result = await enviarCorreo(
        pacienteRow.CORREO_ELECTRONICO,
        subject,
        html
      );
      sent = result === true;
    } catch (errSend) {
      console.error("Error en enviarCorreo (desde app.js):", errSend);
      sent = false;
    }

    if (sent) {
      await registrarBitacora({
        usuario: usuarioStr,
        accion: "ENVIO_EMAIL_CITA",
        descripcion: `Email de confirmación enviado a ${pacienteRow.CORREO_ELECTRONICO} para cita ID ${idCita}`,
        modulo: "CITAS",
        idRegistro: idCita,
        tabla: "TBL_MS_USUARIO",
        estado: "EXITO",
        req: null,
      });
    } else {
      await registrarBitacora({
        usuario: usuarioStr,
        accion: "ENVIO_EMAIL_CITA",
        descripcion: `Error enviando email a ${pacienteRow.CORREO_ELECTRONICO} para cita ID ${idCita}`,
        modulo: "CITAS",
        idRegistro: idCita,
        tabla: "TBL_MS_USUARIO",
        estado: "ERROR",
        detalleError: "Falló enviarCorreo()",
        req: null,
      });
    }
  } catch (err) {
    console.error("Listener cita:creada error:", err);
    try {
      await registrarBitacora({
        usuario: "SISTEMA",
        accion: "ERROR_ENVIO_EMAIL_CITA",
        descripcion: err.message || String(err),
        modulo: "CITAS",
        idRegistro: null,
        tabla: "TBL_MS_USUARIO",
        estado: "ERROR",
        detalleError: err.message || String(err),
        req: null,
      });
    } catch (inner) {
      console.error("Error registrando bitácora desde listener:", inner);
    }
  }
});

// Rutas y montaje
app.use("/bitacora", require("./routes/bitacora.routes"));
app.use("/bitacora/parametros", require("./routes/parametros.routes"));

app.get("/", (req, res) => res.redirect("/dashboard"));

app.use("/auth", require("./routes/auth.routes"));
app.use("/2fa", require("./routes/twofa.routes"));
app.use("/dashboard", require("./routes/dashboard.routes"));
app.use("/users", require("./routes/users.routes"));
app.use("/especialidades", require("./routes/especialidades.routes"));
app.use("/historial", require("./routes/historial-medico.routes"));
app.use("/citas", require("./routes/citas.routes"));
app.use("/pacientes", require("./routes/pacientes.routes"));
app.use("/preclinica", require("./routes/preclinica.routes"));
app.use("/inventario", require("./routes/inventarioMedicamentos.routes"));
// Cambio 2: Montar el router de recibos
app.use('/recibos', reciboRoutes); 

// Montamos consultaMedica router en ambos prefijos para compatibilidad con cliente antiguo/nuevo
const consultaRouter = require("./routes/consultaMedica.routes");
app.use("/consultaMedica", consultaRouter);
app.use("/consulta", consultaRouter); // alias

app.use((req, res, next) => {
  res.locals.success = req.query.success;
  res.locals.error = req.query.error;
  next();
});

app.use(errorHandler);

module.exports = app;