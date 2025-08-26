

interface Products {
    description:string;
    price: number;
}

const phone: Products = {
    description: "Nokia A1",
    price: 150.0
}

const tablet: Products = {
    description: "iPad Air",
    price: 250.0
}

interface taxCalculationOptions {
    products: Products[],
    tax: number
}

function taxCalculation (options:taxCalculationOptions): number[] {
    let total = 0;

    options.products.forEach(product => {
        total += product.price;
    });

    return [total, total * options.tax];
}

const shoppingCart = [ phone, tablet]
const tax = 0.15;

const result =  taxCalculation ({
    products: shoppingCart,
    tax: tax,
});