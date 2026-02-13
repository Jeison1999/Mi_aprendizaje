const aniversario = "2023-12-07"

const fechaInput = document.getElementById("fecha");
if (fechaInput) {
    fechaInput.addEventListener("input", () => {
        fechaInput.value = formatearFecha(fechaInput.value);
    });
}

function verificarFecha() {
    const fechaUsuario = normalizarFecha(document.getElementById("fecha").value.trim());

    if (!fechaUsuario) {
        document.getElementById("error").innerText = "Ingresa la fecha en formato DD/MM/AAAA";
        return;
    }

    if (fechaUsuario === aniversario) {
        const cartaPrincipal = document.querySelector("#pantallaCandado .carta");
        cartaPrincipal.classList.add("abierta");
        
        // Ocultar input, botón y error
        document.getElementById("fecha").style.display = "none";
        document.querySelector(".button").style.display = "none";
        document.getElementById("error").style.display = "none";
        
        // Mostrar contenido desbloqueado
        const contenidoDesbloqueado = document.getElementById("contenidoDesbloqueado");
        contenidoDesbloqueado.style.display = "block";
        
        obtenerFrase();
        iniciarCorazones();
    } else {
        document.getElementById("error").innerText = "Nojoda andrea enserio?, vuelve hacer esa vaina";
    }
}

function normalizarFecha(valor) {
    if (!valor) {
        return "";
    }

    const match = valor.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
    if (!match) {
        return "";
    }

    const [, day, month, year] = match;
    return `${year}-${month}-${day}`;
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

function formatearFecha(valor) {
    const soloNumeros = valor.replace(/\D/g, "").slice(0, 8);
    const partes = [];

    if (soloNumeros.length >= 2) {
        partes.push(soloNumeros.slice(0, 2));
    } else {
        partes.push(soloNumeros);
    }

    if (soloNumeros.length >= 4) {
        partes.push(soloNumeros.slice(2, 4));
    } else if (soloNumeros.length > 2) {
        partes.push(soloNumeros.slice(2));
    }

    if (soloNumeros.length > 4) {
        partes.push(soloNumeros.slice(4));
    }

    return partes.join("/");
}