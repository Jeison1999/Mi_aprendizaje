const aniversario = "2023-12-07"

function verificarFecha() {
    const fechaUsuario = document.getElementById("fecha").value;

    if ( fechaUsuario === aniversario) {
        document.getElementById("pantallaCandado").style.display = "none";

        document.getElementById("pantallaDesbloqueada").style.display = "block";

        obtenerFrase();

    } else {
        document.getElementById("error").innerText = "Nojoda andrea enserio?, vuelve hacer esa vaina" 
    }

    function obtenerFrase() {
        fetch("https://www.positive-api.online/phrase/esp")
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta');
                }
                return response.json();
            })
            .then(data => {
                console.log('Data recibida:', data);
                // Prueba diferentes estructuras posibles
                const frase = data.phrase || data.text || data.content || data.message || JSON.stringify(data);
                document.getElementById("frase").innerText = frase;
            })
            .catch((error)=>{
                console.error('Error al obtener frase:', error);
                document.getElementById("frase").innerText = "Eres lo mejor que me ha pasado apoteila 💛";
            });
    }
}