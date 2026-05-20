const db = require('../database/db');

const inventarioController = {
    // Método para registrar en bitácora
    registrarBitacora: async (accion, detalles, idUsuario = 1) => {
        try {
            const query = `
                INSERT INTO TBL_BITACORA (
                    ACCION, DETALLES, ID_USUARIO, USUARIO_REGISTRO, FECHA_REGISTRO
                ) VALUES (?, ?, ?, ?, NOW())
            `;
            
            await db.query(query, [
                accion,
                detalles,
                idUsuario,
                'SISTEMA_INVENTARIO' // Este valor debería ser el nombre de usuario o 'SISTEMA'
            ]);
            
            console.log(`📝 Bitácora registrada: ${accion}`);
        } catch (error) {
            console.error('❌ Error al registrar en bitácora:', error);
        }
    },

    // Método para obtener medicamentos (uso interno)
    getMedicamentosData: async () => {
        try {
            const query = `
                SELECT 
                    ID_MEDICAMENTO,
                    NOMBRE_MEDICAMENTO,
                    COALESCE(NOMBRE_GENERICO, '') as NOMBRE_GENERICO,
                    COALESCE(DESCRIPCION, '') as DESCRIPCION,
                    COALESCE(PRESENTACION, '') as PRESENTACION,
                    COALESCE(CONCENTRACION, '') as CONCENTRACION,
                    COALESCE(VIA_ADMINISTRACION, '') as VIA_ADMINISTRACION,
                    COALESCE(STOCK_ACTUAL, 0) as STOCK_ACTUAL,
                    COALESCE(STOCK_MINIMO, 10) as STOCK_MINIMO,
                    COALESCE(STOCK_MAXIMO, 100) as STOCK_MAXIMO,
                    COALESCE(PRECIO_COMPRA, 0) as PRECIO_COMPRA,
                    COALESCE(PRECIO_VENTA, 0) as PRECIO_VENTA,
                    COALESCE(LOTE, '') as LOTE,
                    DATE_FORMAT(FECHA_VENCIMIENTO, '%Y-%m-%d') as FECHA_VENCIMIENTO,
                    COALESCE(PROVEEDOR, '') as PROVEEDOR,
                    COALESCE(REQUIERE_RECETA, 0) as REQUIERE_RECETA,
                    COALESCE(ESTADO, 'ACTIVO') as ESTADO
                FROM TBL_INVENTARIO_MEDICAMENTOS 
                ORDER BY ID_MEDICAMENTO ASC
            `;
            
            const [medicamentos] = await db.query(query);
            
            const medicamentosLimpios = medicamentos.map(med => ({
                ID_MEDICAMENTO: parseInt(med.ID_MEDICAMENTO) || 0,
                NOMBRE_MEDICAMENTO: med.NOMBRE_MEDICAMENTO?.toString().trim() || 'Sin nombre',
                NOMBRE_GENERICO: med.NOMBRE_GENERICO?.toString().trim() || '',
                DESCRIPCION: med.DESCRIPCION?.toString().trim() || '',
                PRESENTACION: med.PRESENTACION?.toString().trim() || '',
                CONCENTRACION: med.CONCENTRACION?.toString().trim() || '',
                VIA_ADMINISTRACION: med.VIA_ADMINISTRACION?.toString().trim() || '',
                STOCK_ACTUAL: parseInt(med.STOCK_ACTUAL) || 0,
                STOCK_MINIMO: parseInt(med.STOCK_MINIMO) || 10,
                STOCK_MAXIMO: parseInt(med.STOCK_MAXIMO) || 100,
                PRECIO_COMPRA: parseFloat(med.PRECIO_COMPRA) || 0,
                PRECIO_VENTA: parseFloat(med.PRECIO_VENTA) || 0,
                LOTE: med.LOTE?.toString().trim() || '',
                FECHA_VENCIMIENTO: med.FECHA_VENCIMIENTO || null,
                PROVEEDOR: med.PROVEEDOR?.toString().trim() || '',
                REQUIERE_RECETA: Boolean(med.REQUIERE_RECETA),
                ESTADO: med.ESTADO?.toString() || 'ACTIVO'
            }));
            
            return {
                success: true,
                data: medicamentosLimpios,
                total: medicamentosLimpios.length
            };
            
        } catch (error) {
            console.error('Error al obtener medicamentos:', error);
            return {
                success: false,
                message: 'Error al obtener los medicamentos: ' + error.message,
                data: []
            };
        }
    },

    // Método para obtener estadísticas (uso interno)
    getEstadisticasData: async () => {
        try {
            const queryTotal = `SELECT COUNT(*) as total FROM TBL_INVENTARIO_MEDICAMENTOS`;
            const queryActivos = `SELECT COUNT(*) as activos FROM TBL_INVENTARIO_MEDICAMENTOS WHERE ESTADO = 'ACTIVO'`;
            const queryStockBajo = `
                SELECT COUNT(*) as stockBajo 
                FROM TBL_INVENTARIO_MEDICAMENTOS 
                WHERE STOCK_ACTUAL <= STOCK_MINIMO AND ESTADO = 'ACTIVO'
            `;
            const queryProximoVencer = `
                SELECT COUNT(*) as proximoVencer 
                FROM TBL_INVENTARIO_MEDICAMENTOS 
                WHERE FECHA_VENCIMIENTO BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
                AND ESTADO = 'ACTIVO'
            `;

            const [[totalResult]] = await db.query(queryTotal);
            const [[activosResult]] = await db.query(queryActivos);
            const [[stockBajoResult]] = await db.query(queryStockBajo);
            const [[proximoVencerResult]] = await db.query(queryProximoVencer);

            const estadisticas = {
                totalMedicamentos: parseInt(totalResult.total) || 0,
                activos: parseInt(activosResult.activos) || 0,
                stockBajo: parseInt(stockBajoResult.stockBajo) || 0,
                proximoVencer: parseInt(proximoVencerResult.proximoVencer) || 0
            };

            return {
                success: true,
                data: estadisticas
            };
            
        } catch (error) {
            console.error('Error al obtener estadísticas:', error);
            return {
                success: false,
                message: 'Error al obtener las estadísticas: ' + error.message,
                data: {
                    totalMedicamentos: 0,
                    activos: 0,
                    stockBajo: 0,
                    proximoVencer: 0
                }
            };
        }
    },

    // API Methods
    getMedicamentos: async (req, res) => {
        try {
            const result = await inventarioController.getMedicamentosData();
            res.json(result);
        } catch (error) {
            console.error('Error en API getMedicamentos:', error);
            res.status(500).json({
                success: false,
                message: 'Error al obtener los medicamentos: ' + error.message,
                data: []
            });
        }
    },

    getEstadisticas: async (req, res) => {
        try {
            const result = await inventarioController.getEstadisticasData();
            res.json(result);
        } catch (error) {
            console.error('Error en API getEstadisticas:', error);
            res.status(500).json({
                success: false,
                message: 'Error al obtener las estadísticas: ' + error.message,
                data: {
                    totalMedicamentos: 0,
                    activos: 0,
                    stockBajo: 0,
                    proximoVencer: 0
                }
            });
        }
    },

    getMedicamentoById: async (req, res) => {
        try {
            const { id } = req.params;            
            const query = `
                SELECT 
                    ID_MEDICAMENTO,
                    NOMBRE_MEDICAMENTO,
                    COALESCE(NOMBRE_GENERICO, '') as NOMBRE_GENERICO,
                    COALESCE(DESCRIPCION, '') as DESCRIPCION,
                    COALESCE(PRESENTACION, '') as PRESENTACION,
                    COALESCE(CONCENTRACION, '') as CONCENTRACION,
                    COALESCE(VIA_ADMINISTRACION, '') as VIA_ADMINISTRACION,
                    COALESCE(STOCK_ACTUAL, 0) as STOCK_ACTUAL,
                    COALESCE(STOCK_MINIMO, 10) as STOCK_MINIMO,
                    COALESCE(STOCK_MAXIMO, 100) as STOCK_MAXIMO,
                    COALESCE(PRECIO_COMPRA, 0) as PRECIO_COMPRA,
                    COALESCE(PRECIO_VENTA, 0) as PRECIO_VENTA,
                    COALESCE(LOTE, '') as LOTE,
                    DATE_FORMAT(FECHA_VENCIMIENTO, '%Y-%m-%d') as FECHA_VENCIMIENTO,
                    COALESCE(PROVEEDOR, '') as PROVEEDOR,
                    COALESCE(REQUIERE_RECETA, 0) as REQUIERE_RECETA,
                    COALESCE(ESTADO, 'ACTIVO') as ESTADO
                FROM TBL_INVENTARIO_MEDICAMENTOS 
                WHERE ID_MEDICAMENTO = ?
            `;
            
            const [medicamento] = await db.query(query, [id]);
            
            if (medicamento.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Medicamento no encontrado'
                });
            }
            
            const medicamentoLimpio = {
                ...medicamento[0],
                STOCK_ACTUAL: parseInt(medicamento[0].STOCK_ACTUAL) || 0,
                STOCK_MINIMO: parseInt(medicamento[0].STOCK_MINIMO) || 10,
                STOCK_MAXIMO: parseInt(medicamento[0].STOCK_MAXIMO) || 100,
                PRECIO_VENTA: parseFloat(medicamento[0].PRECIO_VENTA) || 0,
                REQUIERE_RECETA: Boolean(medicamento[0].REQUIERE_RECETA)
            };
            
            res.json({
                success: true,
                data: medicamentoLimpio
            });
            
        } catch (error) {
            console.error('Error al obtener medicamento:', error);
            res.status(500).json({
                success: false,
                message: 'Error al obtener el medicamento: ' + error.message
            });
        }
    },

    createMedicamento: async (req, res) => {
        try {
            // 💡 CORRECCIÓN: Definir la variable 'usuario'.
            // Cambia 'ADMIN_TEMPORAL' por req.usuario o req.user si usas autenticación.
            const usuario = 'ADMIN_TEMPORAL'; 
            
            const {
                NOMBRE_MEDICAMENTO,
                NOMBRE_GENERICO,
                DESCRIPCION,
                PRESENTACION,
                CONCENTRACION,
                VIA_ADMINISTRACION,
                STOCK_ACTUAL,
                STOCK_MINIMO,
                STOCK_MAXIMO,
                PRECIO_COMPRA,
                PRECIO_VENTA,
                LOTE,
                FECHA_VENCIMIENTO,
                PROVEEDOR,
                REQUIERE_RECETA,
                ESTADO
            } = req.body;

            if (!NOMBRE_MEDICAMENTO || NOMBRE_MEDICAMENTO.trim() === '') {
                return res.status(400).json({
                    success: false,
                    message: 'El nombre del medicamento es requerido'
                });
            }

            const query = `
                INSERT INTO TBL_INVENTARIO_MEDICAMENTOS (
                    NOMBRE_MEDICAMENTO, NOMBRE_GENERICO, DESCRIPCION, PRESENTACION,
                    CONCENTRACION, VIA_ADMINISTRACION, STOCK_ACTUAL, STOCK_MINIMO,
                    STOCK_MAXIMO, PRECIO_COMPRA, PRECIO_VENTA, LOTE, FECHA_VENCIMIENTO,
                    PROVEEDOR, REQUIERE_RECETA, ESTADO, ID_USUARIO_REGISTRO, USUARIO_CREACION
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `;

            const [result] = await db.query(query, [
                NOMBRE_MEDICAMENTO.trim(),
                NOMBRE_GENERICO ? NOMBRE_GENERICO.trim() : null,
                DESCRIPCION ? DESCRIPCION.trim() : null,
                PRESENTACION ? PRESENTACION.trim() : null,
                CONCENTRACION ? CONCENTRACION.trim() : null,
                VIA_ADMINISTRACION ? VIA_ADMINISTRACION.trim() : null,
                STOCK_ACTUAL || 0,
                STOCK_MINIMO || 10,
                STOCK_MAXIMO || 100,
                PRECIO_COMPRA || 0,
                PRECIO_VENTA || 0,
                LOTE ? LOTE.trim() : null,
                FECHA_VENCIMIENTO || null,
                PROVEEDOR ? PROVEEDOR.trim() : null,
                REQUIERE_RECETA !== undefined ? REQUIERE_RECETA : true,
                ESTADO || 'ACTIVO',
                1,
                usuario, // 'usuario' ya está definida.
            ]);

            // Registrar en bitácora
            await inventarioController.registrarBitacora(
                'CREAR_MEDICAMENTO',
                `Se creó el medicamento: ${NOMBRE_MEDICAMENTO} (ID: ${result.insertId})`,
                1
            );

            res.status(201).json({
                success: true,
                message: 'Medicamento creado exitosamente',
                data: { id: result.insertId }
            });
            
        } catch (error) {
            console.error('Error al crear medicamento:', error);
            res.status(500).json({
                success: false,
                message: 'Error al crear el medicamento: ' + error.message
            });
        }
    },

    updateMedicamento: async (req, res) => {
        try {
            const { id } = req.params;
            
            // 💡 CORRECCIÓN: Definir la variable 'usuario'.
            // Cambia 'ADMIN_TEMPORAL' por req.usuario o req.user si usas autenticación.
            const usuario = 'ADMIN_TEMPORAL'; 
            
            const {
                NOMBRE_MEDICAMENTO,
                NOMBRE_GENERICO,
                DESCRIPCION,
                PRESENTACION,
                CONCENTRACION,
                VIA_ADMINISTRACION,
                STOCK_ACTUAL,
                STOCK_MINIMO,
                STOCK_MAXIMO,
                PRECIO_COMPRA,
                PRECIO_VENTA,
                LOTE,
                FECHA_VENCIMIENTO,
                PROVEEDOR,
                REQUIERE_RECETA,
                ESTADO
            } = req.body;

            if (!NOMBRE_MEDICAMENTO || NOMBRE_MEDICAMENTO.trim() === '') {
                return res.status(400).json({
                    success: false,
                    message: 'El nombre del medicamento es requerido'
                });
            }

            // Obtener datos actuales para la bitácora
            const querySelect = 'SELECT NOMBRE_MEDICAMENTO FROM TBL_INVENTARIO_MEDICAMENTOS WHERE ID_MEDICAMENTO = ?';
            const [medicamentoActual] = await db.query(querySelect, [id]);
            const nombreAnterior = medicamentoActual[0]?.NOMBRE_MEDICAMENTO || 'Desconocido';

            const query = `
                UPDATE TBL_INVENTARIO_MEDICAMENTOS SET
                    NOMBRE_MEDICAMENTO = ?,
                    NOMBRE_GENERICO = ?,
                    DESCRIPCION = ?,
                    PRESENTACION = ?,
                    CONCENTRACION = ?,
                    VIA_ADMINISTRACION = ?,
                    STOCK_ACTUAL = ?,
                    STOCK_MINIMO = ?,
                    STOCK_MAXIMO = ?,
                    PRECIO_COMPRA = ?,
                    PRECIO_VENTA = ?,
                    LOTE = ?,
                    FECHA_VENCIMIENTO = ?,
                    PROVEEDOR = ?,
                    REQUIERE_RECETA = ?,
                    ESTADO = ?,
                    USUARIO_MODIFICACION = ?
                WHERE ID_MEDICAMENTO = ?
            `;

            const [result] = await db.query(query, [
                NOMBRE_MEDICAMENTO.trim(),
                NOMBRE_GENERICO ? NOMBRE_GENERICO.trim() : null,
                DESCRIPCION ? DESCRIPCION.trim() : null,
                PRESENTACION ? PRESENTACION.trim() : null,
                CONCENTRACION ? CONCENTRACION.trim() : null,
                VIA_ADMINISTRACION ? VIA_ADMINISTRACION.trim() : null,
                STOCK_ACTUAL || 0,
                STOCK_MINIMO || 10,
                STOCK_MAXIMO || 100,
                PRECIO_COMPRA || 0,
                PRECIO_VENTA || 0,
                LOTE ? LOTE.trim() : null,
                FECHA_VENCIMIENTO || null,
                PROVEEDOR ? PROVEEDOR.trim() : null,
                REQUIERE_RECETA !== undefined ? REQUIERE_RECETA : true,
                ESTADO || 'ACTIVO',
                usuario, // 'usuario' ya está definida.
                id
            ]);

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Medicamento no encontrado'
                });
            }

            // Registrar en bitácora
            await inventarioController.registrarBitacora(
                'ACTUALIZAR_MEDICAMENTO',
                `Se actualizó el medicamento: ${nombreAnterior} -> ${NOMBRE_MEDICAMENTO} (ID: ${id})`,
                1
            );

            res.json({
                success: true,
                message: 'Medicamento actualizado exitosamente'
            });
            
        } catch (error) {
            console.error('Error al actualizar medicamento:', error);
            res.status(500).json({
                success: false,
                message: 'Error al actualizar el medicamento: ' + error.message
            });
        }
    },

    deleteMedicamento: async (req, res) => {
        try {
            const { id } = req.params;

            // Obtener datos para la bitácora
            const querySelect = 'SELECT NOMBRE_MEDICAMENTO FROM TBL_INVENTARIO_MEDICAMENTOS WHERE ID_MEDICAMENTO = ?';
            const [medicamento] = await db.query(querySelect, [id]);
            
            if (medicamento.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Medicamento no encontrado'
                });
            }

            const nombreMedicamento = medicamento[0].NOMBRE_MEDICAMENTO;

            const query = `
                UPDATE TBL_INVENTARIO_MEDICAMENTOS 
                SET ESTADO = 'INACTIVO', USUARIO_MODIFICACION = ?
                WHERE ID_MEDICAMENTO = ?
            `;

            const [result] = await db.query(query, ['ADMIN', id]);

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Medicamento no encontrado'
                });
            }

            // Registrar en bitácora
            await inventarioController.registrarBitacora(
                'ELIMINAR_MEDICAMENTO',
                `Se eliminó (inactivó) el medicamento: ${nombreMedicamento} (ID: ${id})`,
                1
            );

            res.json({
                success: true,
                message: 'Medicamento eliminado exitosamente'
            });
            
        } catch (error) {
            console.error('Error al eliminar medicamento:', error);
            res.status(500).json({
                success: false,
                message: 'Error al eliminar el medicamento: ' + error.message
            });
        }
    },

    actualizarStock: async (req, res) => {
        try {
            const { id } = req.params;
            const { accion, cantidad } = req.body;

            if (!accion || !cantidad || cantidad <= 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Acción y cantidad válida son requeridas'
                });
            }

            const querySelect = `
                SELECT NOMBRE_MEDICAMENTO, STOCK_ACTUAL 
                FROM TBL_INVENTARIO_MEDICAMENTOS 
                WHERE ID_MEDICAMENTO = ?
            `;
            const [medicamento] = await db.query(querySelect, [id]);
            
            if (medicamento.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Medicamento no encontrado'
                });
            }

            const nombreMedicamento = medicamento[0].NOMBRE_MEDICAMENTO;
            const stockActual = parseInt(medicamento[0].STOCK_ACTUAL) || 0;
            let nuevoStock = stockActual;

            if (accion === 'agregar') {
                nuevoStock = stockActual + parseInt(cantidad);
            } else if (accion === 'quitar') {
                nuevoStock = stockActual - parseInt(cantidad);
                if (nuevoStock < 0) nuevoStock = 0;
            } else {
                return res.status(400).json({
                    success: false,
                    message: 'Acción no válida. Use "agregar" o "quitar"'
                });
            }

            const queryUpdate = `
                UPDATE TBL_INVENTARIO_MEDICAMENTOS 
                SET STOCK_ACTUAL = ?, USUARIO_MODIFICACION = ?
                WHERE ID_MEDICAMENTO = ?
            `;

            const [result] = await db.query(queryUpdate, [
                nuevoStock,
                'ADMIN', // Valor temporal
                id
            ]);

            if (result.affectedRows === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Medicamento no encontrado'
                });
            }

            // Registrar en bitácora
            await inventarioController.registrarBitacora(
                'AJUSTAR_STOCK',
                `Stock ${accion === 'agregar' ? 'aumentado' : 'disminuido'} para ${nombreMedicamento}: ${stockActual} -> ${nuevoStock} (${accion === 'agregar' ? '+' : '-'}${cantidad}) (ID: ${id})`,
                1
            );

            res.json({
                success: true,
                message: 'Stock actualizado exitosamente',
                data: { nuevoStock }
            });
            
        } catch (error) {
            console.error('Error al actualizar stock:', error);
            res.status(500).json({
                success: false,
                message: 'Error al actualizar el stock: ' + error.message
            });
        }
    }
};

module.exports = inventarioController;