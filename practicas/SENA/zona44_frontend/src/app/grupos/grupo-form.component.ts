import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-grupo-form',
  templateUrl: './grupo-form.component.html',
  styleUrls: ['./grupo-form.component.css'],
  standalone: true,
  imports: [CommonModule, FormsModule]
})
export class GrupoFormComponent {
  @Input() grupo: any = { nombre: '', descripcion: '' };
  @Output() guardar = new EventEmitter<any>();
  @Output() cancelar = new EventEmitter<void>();
  error = '';

  submit() {
    if (!this.grupo.nombre || !this.grupo.descripcion) {
      this.error = 'Todos los campos son obligatorios';
      return;
    }
    this.error = '';
    this.guardar.emit(this.grupo);
  }
}
