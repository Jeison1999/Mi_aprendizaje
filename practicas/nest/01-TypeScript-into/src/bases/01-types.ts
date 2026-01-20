
export const name: string = 'Jeison';
export const age: number = 34;
export const inValid: boolean = true;



export const templateString =`
Esto es un template de múltiples líneas
que utiliza las comillas invertidas
para su creación.
Se puede meter string "${name}"
Se puede meter number ${age},
Se puede meter boolean ${ inValid},
`;

console.log(templateString)