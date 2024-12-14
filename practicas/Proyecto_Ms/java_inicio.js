document.querySelector('.logo').addEventListener('animationend', () => {
    const screen = document.querySelector('.screen');
    screen.style.display = 'block';

    setTimeout(() => {
        window.location.href = '';
    }, 1500);
});