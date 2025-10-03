import { Component, OnInit } from '@angular/core';
import { GrupoService } from '../api.service';
import { CommonModule } from '@angular/common';
import { AuthService } from '../auth.service';
import { GrupoFormComponent } from './grupo-form.component';

@Component({
  selector: 'app-grupos-list',
  standalone: true,
  templateUrl: './grupos-list.component.html',
//   styleUrls: ['./grupos-list.component.css']
  imports: [CommonModule, GrupoFormComponent]
})
export class GruposListComponent implements OnInit {
  grupos: any[] = [];
  error = '';
  role: string | null = null;
  mostrarForm = false;
  editando: any = null;

  constructor(private grupoService: GrupoService, private auth: AuthService) {}

  ngOnInit() {
    this.auth.getRole().subscribe(r => this.role = r);
    this.cargarGrupos();
  }

  cargarGrupos() {
    this.grupoService.getGrupos().subscribe({
      next: (data) => {
        this.grupos = data;
      },
      error: err => {
        if (err.status === 403) {
          this.error = 'No tienes permisos para ver los grupos.';
        } else if (err.status === 422) {
          this.error = 'Error de validación.';
        } else {
          this.error = err.error?.error || 'Error al cargar grupos';
        }
      }
    });
  }

  esAdmin(): boolean {
    return this.role === 'admin';
  }

  crearGrupo() {
    this.editando = null;
    this.mostrarForm = true;
  }

  editarGrupo(grupo: any) {
    this.editando = { ...grupo };
    this.mostrarForm = true;
  }

  eliminarGrupo(grupo: any) {
    if (confirm('¿Seguro que deseas eliminar este grupo?')) {
      this.grupoService.eliminarGrupo(grupo.id).subscribe({
        next: () => {
          this.cargarGrupos();
        },
        error: err => {
          this.error = err.error?.error || 'Error al eliminar grupo';
        }
      });
    }
  }

  guardarGrupo(grupo: any) {
    if (this.editando) {
      this.grupoService.actualizarGrupo(this.editando.id, grupo).subscribe({
        next: () => {
          this.mostrarForm = false;
          this.editando = null;
          this.cargarGrupos();
        },
        error: err => {
          this.error = err.error?.error || 'Error al actualizar grupo';
        }
      });
    } else {
      this.grupoService.crearGrupo(grupo).subscribe({
        next: () => {
          this.mostrarForm = false;
          this.cargarGrupos();
        },
        error: err => {
          this.error = err.error?.error || 'Error al crear grupo';
        }
      });
    }
  }

  cancelarForm() {
    this.mostrarForm = false;
    this.editando = null;
  }
}
