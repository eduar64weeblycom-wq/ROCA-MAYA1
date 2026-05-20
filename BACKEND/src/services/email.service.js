const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "serviciotecnico.rocamaya@gmail.com",
    pass: "tgui yfce ezjd ghxq",
  },
});

async function enviarCorreo(to, subject, html) {
  try {
    await transporter.sendMail({
      from: '"Sistema Roca Maya" <tucorreo@gmail.com>',
      to,
      subject,
      html,
    });

    return true;
  } catch (err) {
    console.error("Error enviando correo:", err);
    return false;
  }
}

module.exports = { enviarCorreo };
