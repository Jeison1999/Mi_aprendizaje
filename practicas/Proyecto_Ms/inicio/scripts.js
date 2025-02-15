document.addEventListener('DOMContentLoaded', function () {
    const bola = document.querySelector('.bola');
    const logo = document.querySelector('.logo');
    const card = document.querySelector('.card');

    bola.addEventListener('animationend', function () {
        bola.style.display = 'none';
        logo.style.opacity = '1';

        setTimeout(function () {
            logo.style.opacity = '0';

            setTimeout(function () {
                card.style.top = '50%';
                card.style.transform = 'translateY(-50%)';
            }, 1000); // Tiempo para la transición de opacidad del logo
        }, 2000); // 2000 ms = 2 segundos
    });
});