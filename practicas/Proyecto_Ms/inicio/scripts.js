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
        }, 3000); // 2000 ms = 2 segundos
    });

    const showRegister = document.getElementById('show-register');
    const showLogin = document.getElementById('show-login');
    const loginForm = document.getElementById('login-form');
    const registerForm = document.getElementById('register-form');

    if (showRegister && showLogin) { // Verifica que los elementos existen
        showRegister.addEventListener('click', function(e) {
            e.preventDefault();
            loginForm.style.display = 'none';
            registerForm.style.display = 'block';
        });

        showLogin.addEventListener('click', function(e) {
            e.preventDefault();
            registerForm.style.display = 'none';
            loginForm.style.display = 'block';
        });
    }
});