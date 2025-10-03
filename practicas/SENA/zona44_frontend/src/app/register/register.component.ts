import { Component } from '@angular/core';
import { AuthService } from '../auth.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-register',
  standalone: true,
  templateUrl: './register.component.html',
  // styleUrls: ['./register.component.css']
  imports: [CommonModule, FormsModule]
})
export class RegisterComponent {
  email = '';
  password = '';
  nombre = '';
  error = '';

  constructor(private auth: AuthService) {}

  register() {
    this.auth.register(this.email, this.password, this.nombre).subscribe({
      next: () => {
        this.error = '';
        // Redirigir o mostrar mensaje de éxito
      },
      error: err => {
        this.error = err.error?.error || 'Error al registrarse';
      }
    });
  }
}
