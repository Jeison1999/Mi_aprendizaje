import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProductoService } from '../api.service';
import { AuthService } from '../auth.service';
import { ProductoFormComponent } from './producto-form.component';

@Component({
  selector: 'app-productos-list',
  templateUrl: './productos-list.component.html',
//   styleUrls: ['./productos-list.component.css']
  standalone: true,
  imports: [CommonModule, ProductoFormComponent]
})
export class ProductosListComponent implements OnInit {
  productos: any[] = [];
  error = '';
  role: string | null = null;
  mostrarForm = false;
  editando: any = null;

  constructor(private productoService: ProductoService, private auth: AuthService) {}

  ngOnInit() {
    this.auth.getRole().subscribe(r => this.role = r);
    this.cargarProductos();
  }

  cargarProductos() {
    this.productoService.getProductos().subscribe({
      next: (data) => {
        this.productos = data;
      },
      error: err => {
        if (err.status === 403) {
          this.error = 'No tienes permisos para ver los productos.';
        } else if (err.status === 422) {
          this.error = 'Error de validación.';
        } else {
          this.error = err.error?.error || 'Error al cargar productos';
        }
      }
    });
  }

  esAdmin(): boolean {
    return this.role === 'admin';
  }

  crearProducto() {
    this.editando = null;
    this.mostrarForm = true;
  }

  editarProducto(producto: any) {
    this.editando = { ...producto };
    this.mostrarForm = true;
  }

  eliminarProducto(producto: any) {
    if (confirm('¿Seguro que deseas eliminar este producto?')) {
      this.productoService.eliminarProducto(producto.id).subscribe({
        next: () => {
          this.cargarProductos();
        },
        error: err => {
          this.error = err.error?.error || 'Error al eliminar producto';
        }
      });
    }
  }

  guardarProducto(producto: any) {
    if (this.editando) {
      this.productoService.actualizarProducto(this.editando.id, producto).subscribe({
        next: () => {
          this.mostrarForm = false;
          this.editando = null;
          this.cargarProductos();
        },
        error: err => {
          this.error = err.error?.error || 'Error al actualizar producto';
        }
      });
    } else {
      this.productoService.crearProducto(producto).subscribe({
        next: () => {
          this.mostrarForm = false;
          this.cargarProductos();
        },
        error: err => {
          this.error = err.error?.error || 'Error al crear producto';
        }
      });
    }
  }

  cancelarForm() {
    this.mostrarForm = false;
    this.editando = null;
  }
}
