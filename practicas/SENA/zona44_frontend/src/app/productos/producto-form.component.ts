import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-producto-form',
  templateUrl: './producto-form.component.html',
  styleUrls: ['./producto-form.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class ProductoFormComponent {
  @Input() producto: any = { nombre: '', descripcion: '', precio: 0 };
  @Output() guardar = new EventEmitter<any>();
  @Output() cancelar = new EventEmitter<void>();
  error = '';

  submit() {
    if (!this.producto.nombre || !this.producto.descripcion || this.producto.precio <= 0) {
      this.error = 'Todos los campos son obligatorios y el precio debe ser mayor a 0';
      return;
    }
    this.error = '';
    this.guardar.emit(this.producto);
  }
}
