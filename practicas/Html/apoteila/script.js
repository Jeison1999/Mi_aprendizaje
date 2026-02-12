const aniversario = "2023-12-07"

function verificarFecha() {
    const fechaUsuario = document.getElementById("fecha").value;

    if (fechaUsuario === aniversario) {
        document.getElementById("pantallaCandado").style.display = "none";
        document.getElementById("pantallaDesbloqueada").style.display = "block";
        obtenerFrase();
        iniciarCorazones();
    } else {
        document.getElementById("error").innerText = "Nojoda andrea enserio?, vuelve hacer esa vaina";
    }
}

// ⚠️ ESTA FUNCIÓN DEBE ESTAR FUERA, NO DENTRO DE verificarFecha()
function obtenerFrase() {
    fetch("https://www.positive-api.online/api/phrase/esp")
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
        .catch((error) => {
            console.error('Error al obtener frase:', error);
            document.getElementById("frase").innerText = "Eres lo mejor que me ha pasado apoteila 💛";
        });
}

function iniciarCorazones() {
    const contenedor = document.getElementById("corazones");
    if (!contenedor || contenedor.childElementCount > 0) {
        return;
    }

    contenedor.classList.add("activo");

    for (let i = 0; i < 24; i += 1) {
        const corazon = document.createElement("span");
        corazon.className = "corazon";
        corazon.textContent = "💛";
        corazon.style.left = `${Math.random() * 100}%`;
        corazon.style.animationDuration = `${4 + Math.random() * 4}s`;
        corazon.style.animationDelay = `${Math.random() * 2}s`;
        corazon.style.fontSize = `${14 + Math.random() * 14}px`;
        contenedor.appendChild(corazon);
    }
}