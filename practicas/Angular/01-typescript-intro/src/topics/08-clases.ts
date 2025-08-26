export class Person {
    // public name:  string;
    // private address: string;

    constructor(
        public name: string, 
        public lastName: string,
        private address: string = 'no hay address'
    ){}

}

// export class Hero extends Person {

//     constructor(
//         public alterage: string,
//         public age: number,
//         public realName: string,
//     ) {
//         super(
//             realName,
//             'new york'
//         );
//     }
// }

export class Hero{

    constructor(
        public alterage: string,
        public age: number,
        public realName: string,
        public person: Person,
    ) {}
}

const tony = new Person('Tony', 'stark','barranquilla');
const person =  new Hero('Ironman',45,'Tony', tony);

console.log(person);
