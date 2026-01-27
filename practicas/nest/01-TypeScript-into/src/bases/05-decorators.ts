
class NewPokemon {
    constructor(
        public readonly id :number = 1,
        public name: string = 'Jeison',
    ) {}

    scream() {
        console.log('NO QUIERO');
    }

    speak(){
        console.log('NO QUIERO HABLAR');
    }
}


const MyDecorator = () =>{
    return (target: Function) => {
        return NewPokemon;
    }
}

@MyDecorator()
export class Pokemon {
    constructor(
        public readonly id :number = 1,
        public name: string = 'Jeison',
    ) {}

    scream() {
        console.log(`${this.name.toUpperCase()}!!`);
    }

    speak(){
        console.log(`${this.name} + ${this.name}`);
    }
}

const charmander = new Pokemon(1, 'charmander');
charmander.scream();
charmander.speak();


