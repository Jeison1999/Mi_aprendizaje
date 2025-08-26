
function addNumber (a: number, b: number) {
    return a + b;
}

const addNumbersArrow = (a: number, b: number):string => {
    return `${ a + b }`;
}

function multiply (firtsname:number, secondnumber?:number, base:number = 2){
    return firtsname * base;
}

// const result = addNumber(12, 10);
// const result2 = addNumbersArrow(12,10);
// const multiplyresult: number = multiply(5);

// console.log({
//     result,
//     result2,
//     multiplyresult,
// });


interface Character{
    name: string;
    hp: number;
    showHp: () => void;
}

const healCharacter = (character: Character, amount: number) =>{

    character.hp += amount
}

const strider: Character = {
    name: 'strider',
    hp: 50,
    showHp: function (): void {
        console.log(`puntos de vida ${ this.hp }`);
    }
}

healCharacter(strider, 10 );

strider.showHp();


