function classDecorator(){

}

class SuperClass {
    public myProperty: string = '123';

    print(){
        console.log('Hola mundo');
    }
}

console.log( SuperClass );

const myClass =  new SuperClass();
console.log( myClass );