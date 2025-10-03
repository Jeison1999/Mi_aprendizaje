import { UpperCasePipe } from "@angular/common";
import { Component, computed, signal, Signal } from "@angular/core";

@Component({
    templateUrl: './hero-page.component.html',
    imports: [UpperCasePipe],
})
export class HeroPageComponent {
    name = signal('Iron Man');
    age = signal(45);


    //señal computalizada, solo recibe texto y no puede ser modificada
    heroDescription = computed(() => {
        const description = `Mi nombre es ${ this.name() } y tengo ${ this.age() } años`;
        return description;
    });

    //nombre computalizado
    capitalizedName = computed(() => {
        return this.name().toUpperCase();
    });

    //método normal
    // getHeroDescription(){
    //     return `Mi nombre es ${ this.name() } y tengo ${ this.age() } años`;
    // }

    changeHero(){
        this.name.set('Spiderman')
        this.age.set(22)
    }

    chageAge(){
        this.age.set(60)
    }

    resetForm(){
        this.name.set('Iron Man')
        this.age.set(45)
    }
}
