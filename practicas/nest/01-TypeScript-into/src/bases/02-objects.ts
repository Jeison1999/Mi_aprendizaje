
interface Person {
    id: number,
    name: string,
    age: number
}

export const Person: Person ={
    id: 1,
    name: "Jeison",
    age: 19
}


const User1: Person ={
    id: 2,
    name: "Andrea",
    age: 18
}

export const Usuarios: Person[] = [];

Usuarios.push( Person, User1);


console.log(Usuarios);