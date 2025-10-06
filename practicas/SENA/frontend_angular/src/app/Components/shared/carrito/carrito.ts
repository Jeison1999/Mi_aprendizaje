import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface CarritoItem {
  id: number;
  name: string;
  precio: number;
  cantidad: number;
  foto_url?: string;
}

@Component({
  selector: 'app-carrito',
  standalone: true,
  imports: [CommonModule],
  templateUrl: 'carrito.html',
  styleUrl: 'carrito.css'
})
export class CarritoComponent {
  @Input() items: CarritoItem[] = [];
  @Input() total = 0;

  @Output() increase = new EventEmitter<number>();
  @Output() decrease = new EventEmitter<number>();
  @Output() remove = new EventEmitter<number>();
  @Output() checkout = new EventEmitter<void>();

  isOpen = false;

  toggle(): void {
    this.isOpen = !this.isOpen;
  }
}


