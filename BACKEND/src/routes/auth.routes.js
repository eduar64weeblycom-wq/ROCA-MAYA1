const express = require("express");
const bcrypt = require("bcrypt");
const router = express.Router();
const db = require("../database/db");
const { registrarBitacora } = require("../services/bitacora.service");


router.get("/", (req, res) => {
  res.redirect("/login");
});

router.get("/login", (req, res) => {
  res.render("index", { error: req.query.error, success: req.query.success });
});

router.get("/register", (req, res) => {
  res.render("register", { error: req.query.error, success: req.query.success });
});

// ================================
// REGISTRO
// ================================
router.post("/register", async (req, res) => {
  try {
    const { nombre_usuario, usuario, contrasena, confirm_contrasena, correo_electronico } = req.body;
    
    if (!nombre_usuario || !usuario || !contrasena || !confirm_contrasena || !correo_electronico) {
      return res.redirect("/auth/register?error=Todos los campos son requeridos");
    }

    if (contrasena !== confirm_contrasena) {
      return res.redirect("/auth/register?error=Las contraseñas no coinciden");
    }

    if (contrasena.length !== 9) {
      return res.redirect("/auth/register?error=La contraseña debe tener exactamente 9 caracteres");
    }

    const nombreRegex = /^[A-Za-zÁÉÍÓÚáéíóúÑñÜü\s]+$/;
    if (!nombreRegex.test(nombre_usuario)) {
      return res.redirect("/auth/register?error=El nombre solo puede contener letras y espacios");
    }

    const [userExists] = await db.query("SELECT * FROM TBL_MS_USUARIO WHERE USUARIO = ?", [usuario]);
    if (userExists.length > 0) {
      return res.redirect("/auth/register?error=El usuario ya existe");
    }

    const [emailExists] = await db.query("SELECT * FROM TBL_MS_USUARIO WHERE CORREO_ELECTRONICO = ?", [correo_electronico]);
    if (emailExists.length > 0) {
      return res.redirect("/auth/register?error=El correo ya está registrado");
    }

    const hashedPassword = await bcrypt.hash(contrasena, 10);

    const ID_ROL = 1;

  await db.query(
  `INSERT INTO TBL_MS_USUARIO (USUARIO, NOMBRE_USUARIO, CONTRASENA, CORREO_ELECTRONICO, ESTADO, ID_ROL)
   VALUES (?, ?, ?, ?, 'ACTIVO', ?)`,
  [usuario, nombre_usuario, hashedPassword, correo_electronico, ID_ROL]
);


    await registrarBitacora({
      usuario,
      accion: "REGISTRO",
      descripcion: `Nuevo usuario registrado: ${usuario}`,
    });
    return res.redirect("/auth/login?success=Registro exitoso. Ahora puedes iniciar sesión");
  } catch (err) {
    console.error("Error en registro:", err);
    return res.redirect("/auth/register?error=Error interno del servidor");
  }
});

// ================================
// LOGIN
// ================================
router.post("/login", async (req, res) => {
  try {
    const { nombre_usuario, password } = req.body;

    if (!nombre_usuario || !password) {
      return res.redirect("/auth/login?error=Usuario y contraseña son requeridos");
    }

    const [rows] = await db.query(
      "SELECT * FROM TBL_MS_USUARIO WHERE USUARIO = ? AND ESTADO = 'ACTIVO'",
      [nombre_usuario]
    );

    if (rows.length === 0) {
      return res.redirect("/auth/login?error=Usuario no encontrado");
    }

    const user = rows[0];
    const validPassword = await bcrypt.compare(password, user.CONTRASENA);

    if (!validPassword) {
      return res.redirect("/auth/login?error=Contraseña incorrecta");
    }
    res.cookie("user", user.USUARIO, {
    httpOnly: false,
    maxAge: 1000 * 60 * 60 
    });


    await registrarBitacora({
      usuario: nombre_usuario,
      accion: "LOGIN",
      descripcion: "Inicio de sesión exitoso",
    });

    res.redirect("/dashboard");
  } catch (err) {
    console.error("Error en login:", err);
    res.redirect("/auth/login");
  }
});


const speakeasy = require("speakeasy");
const QRCode = require("qrcode");

router.get("/setup/:userId", async (req, res) => {
  const { userId } = req.params;
  const secret = speakeasy.generateSecret({ name: `Roca Maya (${userId})`, issuer: "Sistema Roca Maya" });

  await pool.query("UPDATE TBL_MS_USUARIO SET SECRET_2FA=?, ACTIVO_2FA=1 WHERE USUARIO=?", [secret.base32, userId]);

  const qr = await QRCode.toDataURL(secret.otpauth_url);
  res.render("setup-2fa", { userId, data_url: qr, secret: secret.base32 });
});

router.post("/verify", async (req, res) => {
  const { userId, token } = req.body;
  const [rows] = await pool.query("SELECT SECRET_2FA FROM TBL_MS_USUARIO WHERE USUARIO=?", [userId]);
  if (!rows.length) return res.render("login-2fa", { userId, error: "Usuario no encontrado" });

  const valid = speakeasy.totp.verify({ secret: rows[0].SECRET_2FA, encoding: "base32", token, window: 1 });
  if (valid) return res.redirect("/dashboard");
  res.render("login-2fa", { userId, error: "Código incorrecto" });
});

router.get("/forgot-password", (req, res) => {
  res.render("forgot-password", { error: null, success: null });
});
const crypto = require("crypto");
const { enviarCorreo } = require("../services/email.service");

router.post("/forgot-password", async (req, res) => {
  try {
    const { correo } = req.body;

    const [rows] = await db.query("SELECT * FROM TBL_MS_USUARIO WHERE CORREO_ELECTRONICO=?", [correo]);

    if (rows.length === 0) {
      return res.render("forgot-password", { error: "El correo no existe", success: null });
    }

    const codigo = crypto.randomInt(100000, 999999);
    const usuario = rows[0].USUARIO;

    await db.query(
      "UPDATE TBL_MS_USUARIO SET CODIGO_RECUPERACION=?, EXPIRA_CODIGO=DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE USUARIO=?",
      [codigo, usuario]
    );

    await enviarCorreo(
      correo,
      "Código de recuperación - Sistema Roca Maya",
      `<h2>Tu código de recuperación es:</h2>
       <h1>${codigo}</h1>
       <p>Este código expira en 10 minutos.</p>`
    );

    res.render("verify-code", { userId: usuario, error: null });
  } catch (err) {
    console.error("Error en forgot-password:", err);
    res.render("forgot-password", { error: "Error interno del servidor", success: null });
  }
});

router.post("/verify-code", async (req, res) => {
  const { userId, codigo } = req.body;

  const [rows] = await db.query(
    "SELECT CODIGO_RECUPERACION, EXPIRA_CODIGO FROM TBL_MS_USUARIO WHERE USUARIO=?",
    [userId]
  );

  if (!rows.length) {
    return res.render("verify-code", { userId, error: "Usuario no encontrado" });
  }

  const data = rows[0];

  if (data.CODIGO_RECUPERACION != codigo) {
    return res.render("verify-code", { userId, error: "Código incorrecto" });
  }

  if (new Date() > new Date(data.EXPIRA_CODIGO)) {
    return res.render("verify-code", { userId, error: "El código ha expirado" });
  }

  res.render("reset-password", { userId, error: null });
});

router.post("/reset-password", async (req, res) => {
  const { userId, pass1, pass2 } = req.body;

  if (pass1 !== pass2) {
    return res.render("reset-password", { userId, error: "Las contraseñas no coinciden" });
  }

  if (pass1.length !== 9) {
    return res.render("reset-password", { userId, error: "La contraseña debe tener 9 caracteres" });
  }

  const hashed = await bcrypt.hash(pass1, 10);

  await db.query(
    "UPDATE TBL_MS_USUARIO SET CONTRASENA=?, CODIGO_RECUPERACION=NULL, EXPIRA_CODIGO=NULL WHERE USUARIO=?",
    [hashed, userId]
  );

  res.redirect("/auth/login?success=Contraseña actualizada correctamente");
});


module.exports = router;