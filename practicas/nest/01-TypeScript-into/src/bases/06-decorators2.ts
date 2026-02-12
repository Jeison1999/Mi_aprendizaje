const Deprecated = (deprecationReason: string) => {
    return (target: any, memberName: string, propertyDescriptor: PropertyDescriptor) => {
    //   console.log({target})
      return {
        get() {
          const wrapperFn = (...args: any[]) => {
            console.warn(`Method ${ memberName } is deprecated with reason: ${ deprecationReason }`);
            //! Llamar la función propiamente con sus argumentos
            propertyDescriptor.value.apply(this, args); 
          }
          return wrapperFn;
        }
      }
    }   
}
export class Pokemon {
    constructor(
        public readonly id :number = 1,
        public name: string = 'Jeison',
    ) {}

    scream() {
        console.log(`${this.name.toUpperCase()}!!`);
    }

    @Deprecated('ya no se utilizara speak, ahora se utiliza speak2')
    speak(){
        console.log(`${this.name} + ${this.name}`);
    }

    speak2(){
        console.log(`${this.name} + ${this.name}`);
    }
}

const charmander = new Pokemon(1, 'charmander');
charmander.scream();
charmander.speak();