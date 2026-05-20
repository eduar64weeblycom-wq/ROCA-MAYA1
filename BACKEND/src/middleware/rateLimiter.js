const rateLimit = require('express-rate-limit');
module.exports = rateLimit({
windowMs: 60 * 1000, // 1 minuto
max: 100,
standardHeaders: true,
legacyHeaders: false,
});