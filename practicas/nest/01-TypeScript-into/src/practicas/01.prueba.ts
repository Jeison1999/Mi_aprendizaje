
export class Operaciones  {

    constructor(
        readonly num1 :number,
        readonly num2: number,
        readonly operacion :string,
    ){}

    sumar(){
        const resultado = this.num1 + this.num2
        return `La suma de ${this.num1} + ${this.num2} es ${resultado}`
    }
    restar(){
        const resultado = this.num1 - this.num2
        return `La resta de ${this.num1} - ${this.num2} es ${resultado}`
    }
    dividir(){
        const resultado = this.num1 / this.num2
            if (resultado % 2 === 0) {
                console.log('el resultado es par');
            }else{
                console.log('el resultado es impar');
            }
        
        return `La dividicion de ${this.num1} / ${this.num2} es ${resultado}`
    }
    multiplicar(){
        const resultado = this.num1 * this.num2
        return `La multiplicar de ${this.num1} * ${this.num2} es ${resultado}`
    }

    calcular(){
        if ( this.operacion === 's' ) {
            return console.log(this.sumar());
        }else if ( this.operacion === 'r' ) {
             return console.log(this.restar())
        }else if (this.operacion === 'm') {
             return console.log(this.multiplicar());
        }else if (this.operacion === 'd'){
            return console.log(this.dividir());
        }
    }

    prueba(numbe :number) {
        for(let i = 1; i <= numbe; i++ ){
 
        }
        return 
    }

    
}

const prueba = new Operaciones(1,2, 'd')

console.log(prueba.prueba(2));
