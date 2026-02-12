import { HttpAdapter, PokeApiAdapter, PokeApiFechAdapter } from '../api/pokeApi.adapter';
import { Move, PokeAPIResponse } from '../interfaces/pokeapi-response.interface';

export class Pokemon {

    get imageUrl(): string {
        return `https://pokemon.com/${ this.id }.jpg`;
    }
  
    constructor(
        public readonly id: number, 
        public name: string,
        // Todo: inyectar dependencias
        private http :HttpAdapter

    ) {}

    scream() {
        console.log(`${ this.name.toUpperCase() }!!!`);
    }

    speak() {
        console.log(`${ this.name }, ${ this.name }`);
    }

    async getMoves(): Promise<Move[]> {
        // const { data } = await axios.get<PokeAPIResponse>('https://pokeapi.co/api/v2/pokemon/4');
        const data = await this.http.get<PokeAPIResponse>('https://pokeapi.co/api/v2/pokemon/4')
        console.log( data.moves );
        
        return data.moves;
    }
}

const pokeApi = new PokeApiAdapter();
const pokeApiFech = new PokeApiFechAdapter();
console.log(pokeApi);


export const charmander = new Pokemon( 4, 'Charmander', pokeApiFech );

charmander.getMoves();