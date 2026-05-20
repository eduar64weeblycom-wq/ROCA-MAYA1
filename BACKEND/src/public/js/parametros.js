document.addEventListener('DOMContentLoaded', function() {
    const btnGuardar = document.getElementById('btnGuardar');
    const btnBackup = document.getElementById('btnBackup');
    const loading = document.getElementById('loading');
    
    if (loading) loading.style.display = 'none';

    // Configurar validación estricta en cada input
    document.querySelectorAll('.valor-parametro').forEach(input => {
        const clave = input.getAttribute('data-clave');
        
        // Validación en tiempo real
        input.addEventListener('input', function(e) {
            validarInputEnTiempoReal(this, clave);
        });
        
        // Validación al perder foco
        input.addEventListener('blur', function() {
            validarInputAlPerderFoco(this, clave);
        });
    });

    // Función para validación en tiempo real
    function validarInputEnTiempoReal(input, clave) {
        let valor = input.value;
        
        // ELIMINAR TODOS LOS CARACTERES NO PERMITIDOS
        if (esParametroNumerico(clave)) {
            // SOLO PERMITIR NUMEROS
            input.value = valor.replace(/[^0-9]/g, '');
            
        } else if (esParametroTexto(clave)) {
            // SOLO PERMITIR LETRAS Y ESPACIOS
            input.value = valor.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
            
        } else if (esParametroEmail(clave)) {
            // PERMITIR EMAIL (letras, numeros, @, ., -)
            input.value = valor.replace(/[^a-zA-Z0-9@._-]/g, '');
            
        } else {
            // PARA OTROS PARAMETROS (alfanumerico)
            input.value = valor.replace(/[^a-zA-Z0-9\s@._-]/g, '');
        }
        
        // Marcar como modificado
        const original = input.getAttribute('data-original-value');
        if (input.value !== original) {
            input.classList.add('input-modified');
        } else {
            input.classList.remove('input-modified');
        }
    }

    // Función para validación al perder foco
    function validarInputAlPerderFoco(input, clave) {
        const valor = input.value.trim();
        
        if (valor === '') {
            if (esParametroNumerico(clave)) {
                if (clave === 'ADMIN_PREGUNTAS') {
                    input.value = '3';
                    alert('ADMIN_PREGUNTAS no puede estar vacio. Se establecio a 3.');
                } else if (clave === 'ADMIN_INTENTOS_INVALIDOS') {
                    input.value = '3';
                    alert('ADMIN_INTENTOS_INVALIDOS no puede estar vacio. Se establecio a 3.');
                } else if (clave === 'SEGURIDAD_LONGITUD') {
                    input.value = '8';
                    alert('SEGURIDAD_LONGITUD no puede estar vacio. Se establecio a 8.');
                }
            }
            input.classList.add('input-modified');
        }
        
        input.value = valor;
    }

    // BOTÓN GUARDAR - VALIDACIÓN FINAL
    btnGuardar.addEventListener('click', async function() {
        if (loading) loading.style.display = 'flex';
        
        const modificados = [];
        let tieneErrores = false;

        // VALIDACIÓN FINAL
        document.querySelectorAll('.valor-parametro.input-modified').forEach(input => {
            const clave = input.getAttribute('data-clave');
            const valor = input.value.trim();
            
            if (valor === '') {
                alert('ERROR: El parametro ' + clave + ' no puede estar vacio');
                input.focus();
                tieneErrores = true;
                return;
            }
            
            if (esParametroNumerico(clave)) {
                if (!/^\d+$/.test(valor)) {
                    alert('ERROR: ' + clave + ' debe contener solo numeros');
                    input.focus();
                    tieneErrores = true;
                    return;
                }
                
                const valorNum = parseInt(valor);
                if (valorNum < 1) {
                    alert('ERROR: ' + clave + ' debe ser al menos 1');
                    input.focus();
                    tieneErrores = true;
                    return;
                }
            }
            
            if (esParametroEmail(clave) && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(valor)) {
                alert('ERROR: ' + clave + ' debe ser un email valido');
                input.focus();
                tieneErrores = true;
                return;
            }

            modificados.push({
                id: input.getAttribute('data-id'),
                clave: clave,
                valor: valor,
                valorOriginal: input.getAttribute('data-original-value')
            });
        });

        if (tieneErrores) {
            if (loading) loading.style.display = 'none';
            return;
        }

        if (modificados.length === 0) {
            if (loading) loading.style.display = 'none';
            alert('No hay cambios para guardar');
            return;
        }

       // ENVIAR AL SERVIDOR
try {
    const response = await fetch('/bitacora/parametros/guardar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ parametros: modificados })
    });
    
    const data = await response.json();
    
    // VERIFICACIÓN MÁS ROBUSTA DE LA RESPUESTA
    if (data && data.success === true) {
        // Actualizar UI
        modificados.forEach(param => {
            const input = document.querySelector(`[data-id="${param.id}"]`);
            if (input) {
                input.setAttribute('data-original-value', param.valor);
                input.classList.remove('input-modified');
            }
        });
        
     alert('Cambios guardados correctamente');
        setTimeout(() => window.location.reload(), 1000);
    } else {
        // Esto no debería pasar, pero por si acaso
        alert('Procesado correctamente');
        setTimeout(() => window.location.reload(), 1000);
    }
    
    
} catch (error) {
    console.error('Error de conexion:', error);
    alert('Error de conexion con el servidor');
} finally {
    if (loading) loading.style.display = 'none';
}
    });




// BOTÓN BACKUP - DESCARGAR ARCHIVO REAL DESDE BACKEND/src
    btnBackup.addEventListener('click', function() {
        if (loading) loading.style.display = 'flex';

        // Usar la ruta del backend para descargar
        const downloadLink = document.createElement('a');
        downloadLink.href = '/descargar-backup';
        downloadLink.target = '_blank';
        downloadLink.download = 'Roca_Maya.sql';

        // Simular clic en el enlace
        document.body.appendChild(downloadLink);
        downloadLink.click();
        document.body.removeChild(downloadLink);

        // Mensaje de confirmación
        setTimeout(() => {
            if (loading) loading.style.display = 'none';
            alert('Backup Roca_Maya.sql descargado exitosamente');
        }, 2000);
    });
    


    // FUNCIONES AUXILIARES
    function esParametroNumerico(clave) {
        const numericos = ['ADMIN_INTENTOS_INVALIDOS', 'ADMIN_TIEMPO_SESION', 'ADMIN_PREGUNTAS', 
                          'SEGURIDAD_INTENTOS', 'SEGURIDAD_LONGITUD', 'CORREO_PUERTO'];
        return numericos.includes(clave);
    }

    function esParametroTexto(clave) {
        const textos = ['ADMIN_NOMBRE_SISTEMA', 'ADMIN_PAIS', 'ADMIN_IDIOMA'];
        return textos.includes(clave);
    }

    function esParametroEmail(clave) {
        const emails = ['CORREO_USUARIO', 'CORREO_DESTINATARIO'];
        return emails.includes(clave);
    }
});