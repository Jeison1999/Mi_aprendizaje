import axios from "axios";
import type { PokeAPIResponse } from "../interfaces/pokeapi-response.interface";

export class Person {

    
    public get imageUrl() : string {
        return `https://personas.com ${ this.id }.jpg`;
    }

    //nombre en mayuscula
    Mnombre() {
        console.log(`${this.name.toUpperCase()}!!!`);
    }

    //repetir nombre
    Rnombre(){
        console.log(`${this.name} + ${this.name}`);   
    }

    //peticion del pokemon
    
    async getPokemon(){
        const { data} = await axios.get<PokeAPIResponse>('https://pokeapi.co/api/v2/pokemon/4');
        console.log( data.moves[0].move.name );
        return data.name;
    }
    
    
    

    constructor(
        //readonly solo permite lectura de esa propiedad
        public readonly id:number,
        public name: string
    ) {     
 }
}

export const Jeison = new Person( 1, "Jeison");

// Jeison.getPokemon();
// console.log(Jeison.getPokemon());

// console.log(`
//     ${Jeison.id},
//     ${Jeison.name},
//     ${Jeison.imageUrl}
// `)
// Jeison.Mnombre();
// Jeison.Rnombre();



