// import { name } from './bases/01-types.ts';

// import {  } from "./bases/02-objects";
import { Jeison } from "./bases/03-classes";


const app = document.querySelector<HTMLDivElement>('#app')!;

(async () => {
  const pokemonName = await Jeison.getPokemon();

  app.innerHTML = `
  <h1>Hello ${pokemonName}</h1>
  <a href="https://vitejs.dev/guide/features.html" target="_blank">Documentation</a>
`;
})();
