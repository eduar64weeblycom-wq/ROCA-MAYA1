const express = require('express');
const router = express.Router();
const pool = require('../database/db');
const { registrarBitacora } = require('./bitacora.routes');

// Función de validación estricta
function validarParametrosBackend(req, res, next) {
    const { parametros } = req.body;
    
    if (!parametros || !Array.isArray(parametros)) {
        return res.status(400).json({
            success: false,
            message: 'Formato de datos invalido'
        });
    }
    
    const errores = [];
    
    for (const param of parametros) {
        if (!param.id || !param.clave || param.valor === undefined || param.valor === '') {
            errores.push(`Faltan campos requeridos para ${param.clave}`);
            continue;
        }
        
        // ELIMINAR CUALQUIER CARACTER NO PERMITIDO
        let valorLimpio = String(param.valor).replace(/[^\w\s@.-]/gi, '').trim();
        
        // Validar según tipo de parámetro
        if (esParametroNumerico(param.clave)) {
            // SOLO NUMEROS
            if (!/^\d+$/.test(valorLimpio)) {
                errores.push(`El parametro ${param.clave} debe contener solo numeros`);
                continue;
            }
            
            const valorNum = parseInt(valorLimpio);
            
            // Validar rangos minimos
            if (valorNum < 1) {
                if (param.clave === 'ADMIN_PREGUNTAS') {
                    errores.push('ADMIN_PREGUNTAS debe ser al menos 1');
                } else if (param.clave === 'ADMIN_INTENTOS_INVALIDOS') {
                    errores.push('ADMIN_INTENTOS_INVALIDOS debe ser al menos 1');
                } else if (param.clave === 'SEGURIDAD_INTENTOS') {
                    errores.push('SEGURIDAD_INTENTOS debe ser al menos 1');
                } else if (param.clave === 'SEGURIDAD_LONGITUD') {
                    errores.push('SEGURIDAD_LONGITUD debe ser al menos 6');
                }
            }
            
            param.valor = valorNum; // Guardar como número
            
        } else if (esParametroTexto(param.clave)) {
            // SOLO LETRAS Y ESPACIOS
            if (!/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/.test(valorLimpio)) {
                errores.push(`El parametro ${param.clave} debe contener solo letras y espacios`);
                continue;
            }
            
        } else if (param.clave === 'CORREO_USUARIO' || param.clave === 'CORREO_DESTINATARIO') {
            // VALIDAR EMAIL
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(valorLimpio)) {
                errores.push(`El parametro ${param.clave} debe ser un email valido`);
                continue;
            }
        }
        
        param.valor = valorLimpio;
    }
    
    if (errores.length > 0) {
        return res.status(400).json({
            success: false,
            message: 'Errores de validacion',
            errors: errores
        });
    }
    
    next();
}

// Ruta para guardar parámetros
router.post('/guardar', validarParametrosBackend, async (req, res) => {
    try {
        const { parametros } = req.body;
        const usuario = req.user || { id: 1 };

        console.log('Validando parametros:', parametros);

        for (const param of parametros) {
            await pool.query(
                'UPDATE TBL_MS_PARAMETROS SET VALOR = ?, USUARIO_MODIFICACION = ?, FECHA_MODIFICACION = NOW() WHERE ID_PARAMETRO = ?',
                [param.valor, usuario.id, param.id]
            );
            
            await registrarBitacora(
                'ACTUALIZACION_PARAMETRO',
                'CONFIGURACION',
                `Parametro actualizado: ${param.clave} - Valor: ${param.valorOriginal} -> ${param.valor}`,
                usuario.id
            );
        }
        
       return res.json({ 
            success: true, 
            message: 'Parametros actualizados exitosamente' 
        });
        
    } catch (error) {
        console.error('Error:', error);
        return res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

// Ruta para obtener parámetros
router.get('/', async (req, res) => {
    try {
        const [parametros] = await pool.query(`
            SELECT * FROM TBL_MS_PARAMETROS 
            ORDER BY ID_PARAMETRO
        `);
        
        res.json({
            success: true,
            data: parametros
        });
        
    } catch (error) {
        console.error('Error obteniendo parametros:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener parametros'
        });
    }
});

// Funciones auxiliares
function esParametroNumerico(clave) {
    const parametrosNumericos = [
        'ADMIN_INTENTOS_INVALIDOS', 'ADMIN_TIEMPO_SESION', 'ADMIN_PREGUNTAS',
        'SEGURIDAD_INTENTOS', 'SEGURIDAD_LONGITUD', 'CORREO_PUERTO'
    ];
    return parametrosNumericos.includes(clave);
}

function esParametroTexto(clave) {
    const parametrosTexto = [
        'ADMIN_NOMBRE_SISTEMA', 'ADMIN_PAIS', 'ADMIN_IDIOMA'
    ];
    return parametrosTexto.includes(clave);
}

// ELIMINA LA RUTA DEL BACKUP DE AQUÍ - YA ESTÁ EN app.js

module.exports = router;