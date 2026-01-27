// import { name } from './bases/01-types.ts';
// import {  } from "./bases/02-objects";
// import { Jeison } from "./bases/03-classes";
// import { charmander } from "./bases/04-injections";
import { Pokemon } from "./bases/05-decorators";


const app = document.querySelector<HTMLDivElement>('#app')!;

app.innerHTML = `
<h1>Hello ${Pokemon.name}</h1>
<a href="https://vitejs.dev/guide/features.html" target="_blank">Documentation</a>
`;

