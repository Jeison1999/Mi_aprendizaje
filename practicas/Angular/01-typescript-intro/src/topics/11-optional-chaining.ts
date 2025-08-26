

export interface Passenger {
    name: string;
    children?: string[];
}

const passanger1: Passenger = {
    name: 'Jeison',
    children: []
}

const passanger2: Passenger = {
    name: 'Andrea',
    children: ['indira','lizy']
}

const printChildren = (passager: Passenger) =>{
    const howManyChildren = passager.children?.length;

    console.log (howManyChildren);
}

printChildren(passanger1);