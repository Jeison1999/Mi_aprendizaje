function suma(a, b) {
    console.log(arguments);
    
    return a + 2 + b;
}

let resultado = suma(8, 2, 6, 7, 9, 8);
console.log(resultado);
console.log(typeof suma);
