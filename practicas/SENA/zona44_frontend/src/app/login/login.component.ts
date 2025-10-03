import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  templateUrl: './login.component.html',
//   styleUrls: ['./login.component.css']
  imports: [CommonModule, FormsModule]
})
export class LoginComponent {
  email = '';
  password = '';
  error = '';

  constructor(private auth: AuthService) {}

  login() {
    this.auth.login(this.email, this.password).subscribe({
      next: () => {
        this.error = '';
        // Redirigir o mostrar mensaje de éxito
      },
      error: err => {
        this.error = err.error?.error || 'Error al iniciar sesión';
      }
    });
  }
}
