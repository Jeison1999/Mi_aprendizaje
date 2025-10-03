import { Component, signal } from '@angular/core';
import { NgClass } from '@angular/common';

interface Character{
  id: number;
  name: string;
  power: number;
}

@Component({
  selector: 'app-dragonball',
  templateUrl: './dragonball.html',
  styleUrl: './dragonball.css'
})
export class Dragonball {

  name = signal('Gohan');
  power = signal(0);
  

  characters = signal<Character[]>([
    {
      id: 1,
      name: 'Goku',
      power: 9001
    },
    {
      id: 2,
      name: 'Vegeta',
      power: 8000
    },
    {
      id: 3,
      name: 'Piccolo',
      power: 3000
    },
    {
      id: 4,
      name: 'Yamcha',
      power: 500
    }
  ]);

  
}
