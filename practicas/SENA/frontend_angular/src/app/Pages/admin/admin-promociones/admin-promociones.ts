import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

interface Promocion {
  id?: number;
  nombre: string;
  descuento: number;
  fecha_inicio: string;
  fecha_fin: string;
  descripcion?: string;
  activa: boolean;
}

@Component({
  selector: 'app-admin-promociones',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-promociones.html',
  styleUrls: ['./admin-promociones.css']
})
export class AdminPromocionesComponent implements OnInit {
  promociones: Promocion[] = [];
  loading = false;
  error: string | null = null;
  success: string | null = null;
  isEditing = false;
  currentPromocion: Promocion | null = null;

  promocionForm = {
    nombre: '',
    descuento: 0,
    fecha_inicio: '',
    fecha_fin: '',
    descripcion: '',
    activa: true
  };

  constructor() {}

  ngOnInit() {
    this.loadPromociones();
  }

  loadPromociones() {
    this.loading = true;
    this.error = null;
    
    // Mock data - aquí cargarías los datos reales del backend
    setTimeout(() => {
      this.promociones = [
        {
          id: 1,
          nombre: '2x1 en Hamburguesas',
          descuento: 50,
          fecha_inicio: '2024-12-01',
          fecha_fin: '2024-12-31',
          descripcion: 'Promoción especial de fin de año',
          activa: true
        },
        {
          id: 2,
          nombre: '20% de descuento en Bebidas',
          descuento: 20,
          fecha_inicio: '2024-12-15',
          fecha_fin: '2024-12-25',
          descripcion: 'Oferta navideña en todas las bebidas',
          activa: true
        }
      ];
      this.loading = false;
    }, 1000);
  }

  createPromocion() {
    if (!this.validateForm()) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    // Mock creation - aquí harías la llamada al backend
    setTimeout(() => {
      const newPromocion: Promocion = {
        id: Date.now(),
        ...this.promocionForm
      };
      
      this.promociones.push(newPromocion);
      this.success = 'Promoción creada exitosamente';
      this.clearForm();
      this.loading = false;
    }, 1000);
  }

  editPromocion(promocion: Promocion) {
    this.isEditing = true;
    this.currentPromocion = promocion;
    this.promocionForm = {
      nombre: promocion.nombre,
      descuento: promocion.descuento,
      fecha_inicio: promocion.fecha_inicio,
      fecha_fin: promocion.fecha_fin,
      descripcion: promocion.descripcion || '',
      activa: promocion.activa
    };
  }

  updatePromocion() {
    if (!this.validateForm() || !this.currentPromocion) return;

    this.loading = true;
    this.error = null;
    this.success = null;

    // Mock update - aquí harías la llamada al backend
    setTimeout(() => {
      const index = this.promociones.findIndex(p => p.id === this.currentPromocion!.id);
      if (index !== -1) {
        this.promociones[index] = {
          ...this.currentPromocion,
          ...this.promocionForm
        };
      }
      
      this.success = 'Promoción actualizada exitosamente';
      this.cancelEdit();
      this.loading = false;
    }, 1000);
  }

  deletePromocion(id: number) {
    if (!confirm('¿Estás seguro de que quieres eliminar esta promoción?')) {
      return;
    }

    this.loading = true;
    this.error = null;
    this.success = null;

    // Mock deletion - aquí harías la llamada al backend
    setTimeout(() => {
      this.promociones = this.promociones.filter(p => p.id !== id);
      this.success = 'Promoción eliminada exitosamente';
      this.loading = false;
    }, 1000);
  }

  cancelEdit() {
    this.isEditing = false;
    this.currentPromocion = null;
    this.clearForm();
  }

  clearForm() {
    this.promocionForm = {
      nombre: '',
      descuento: 0,
      fecha_inicio: '',
      fecha_fin: '',
      descripcion: '',
      activa: true
    };
  }

  validateForm(): boolean {
    if (!this.promocionForm.nombre.trim()) {
      this.error = 'El nombre de la promoción es requerido';
      return false;
    }
    if (!this.promocionForm.descuento || this.promocionForm.descuento <= 0 || this.promocionForm.descuento > 100) {
      this.error = 'El descuento debe estar entre 1 y 100';
      return false;
    }
    if (!this.promocionForm.fecha_inicio) {
      this.error = 'La fecha de inicio es requerida';
      return false;
    }
    if (!this.promocionForm.fecha_fin) {
      this.error = 'La fecha de fin es requerida';
      return false;
    }
    if (new Date(this.promocionForm.fecha_inicio) >= new Date(this.promocionForm.fecha_fin)) {
      this.error = 'La fecha de fin debe ser posterior a la fecha de inicio';
      return false;
    }
    return true;
  }
}