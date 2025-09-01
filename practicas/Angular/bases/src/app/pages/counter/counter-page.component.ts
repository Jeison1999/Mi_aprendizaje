import { Component, signal } from "@angular/core";

@Component({
   templateUrl: './counter-page.component.html',
   styleUrl: './counter-page.component.css'
})
export class CounterPageComponent {
    counter = 0;
    counterSingle = signal(10);

    sumaUno(value: number){
        this.counter += value;
        this.counterSingle.update(valor => valor + value);
    }

    resetcounter(){
        this.counter = 0;
        this.counterSingle.set(0);
    }

}