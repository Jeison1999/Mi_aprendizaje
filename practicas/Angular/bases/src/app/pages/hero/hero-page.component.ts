import { Component, signal, Signal } from "@angular/core";

@Component({
    templateUrl: './hero-page.component.html',
})
export class HeroPageComponent {
    name = signal('Iron Man');
    age = signal(45);

    getHeroDescription(){
        return `Mi nombre es ${ this.name() } y tengo ${ this.age() } años`;
    }

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
