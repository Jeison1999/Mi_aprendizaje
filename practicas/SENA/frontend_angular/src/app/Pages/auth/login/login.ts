import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService, LoginRequest } from '../auth.service';
import { GoogleAuthService } from '../../../Services/google-auth.service';
import { NavbarComponent } from "../../../Components/shared/navbar/navbar";
import { FooterComponent } from "../../../Components/shared/footer/footer";

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, NavbarComponent, FooterComponent],
  templateUrl: './login.html',
  styleUrl: './login.css'
})
export class LoginComponent implements OnInit, OnDestroy {
  credentials: LoginRequest = {
    email: '',
    password: ''
  };

  loading = false;
  error = '';
  success = '';

  constructor(
    private authService: AuthService,
    private googleAuthService: GoogleAuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Si ya está autenticado, redirigir al perfil
    if (this.authService.isAuthenticated()) {
      this.router.navigate(['/perfil']);
    }

    // Configurar Google Auth
    this.setupGoogleAuth();
    
    // Escuchar eventos de Google Auth
    this.setupGoogleAuthListeners();
  }

  ngOnDestroy(): void {
    // Limpiar listeners
    window.removeEventListener('googleAuthSuccess', this.handleGoogleAuthSuccess);
    window.removeEventListener('googleAuthError', this.handleGoogleAuthError);
  }

  private setupGoogleAuth(): void {
    // Renderizar el botón de Google después de un pequeño delay
    setTimeout(() => {
      this.googleAuthService.renderGoogleButton('google-signin-button', (response: any) => {
        this.googleAuthService.handleGoogleResponse(response);
      });
    }, 500);
  }

  private setupGoogleAuthListeners(): void {
    this.handleGoogleAuthSuccess = this.handleGoogleAuthSuccess.bind(this);
    this.handleGoogleAuthError = this.handleGoogleAuthError.bind(this);
    
    window.addEventListener('googleAuthSuccess', this.handleGoogleAuthSuccess);
    window.addEventListener('googleAuthError', this.handleGoogleAuthError);
  }

  private handleGoogleAuthSuccess = (event: any): void => {
    this.loading = false;
    this.error = '';
    this.success = '¡Inicio de sesión con Google exitoso!';
    
    // Recargar el perfil del usuario
    this.authService.loadUserProfile().subscribe({
      next: () => {
        // Redirigir al perfil después de 1 segundo
        setTimeout(() => {
          this.router.navigate(['/perfil']);
        }, 1000);
      },
      error: (error) => {
        console.error('Error loading user profile:', error);
        // Aún así redirigir al perfil
        setTimeout(() => {
          this.router.navigate(['/perfil']);
        }, 1000);
      }
    });
  };

  private handleGoogleAuthError = (event: any): void => {
    this.loading = false;
    this.error = event.detail?.join(', ') || 'Error en la autenticación con Google';
    this.success = '';
  };

  onSubmit(): void {
    if (!this.validateForm()) {
      return;
    }

    this.loading = true;
    this.error = '';
    this.success = '';

    this.authService.login(this.credentials).subscribe({
      next: (response) => {
        this.loading = false;
        if (response.success) {
          this.success = '¡Inicio de sesión exitoso!';
          // Redirigir al perfil después de 1 segundo
          setTimeout(() => {
            this.router.navigate(['/perfil']);
          }, 1000);
        } else {
          this.error = response.message || 'Error al iniciar sesión';
        }
      },
      error: (error) => {
        this.loading = false;
        this.error = 'Error de conexión. Intenta nuevamente.';
        console.error('Login error:', error);
      }
    });
  }

  private validateForm(): boolean {
    if (!this.credentials.email.trim()) {
      this.error = 'El email es requerido';
      return false;
    }
    if (!this.credentials.password.trim()) {
      this.error = 'La contraseña es requerida';
      return false;
    }
    if (!this.isValidEmail(this.credentials.email)) {
      this.error = 'Ingresa un email válido';
      return false;
    }
    return true;
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  goToRegister(): void {
    this.router.navigate(['/register']);
  }

  goToHome(): void {
    this.router.navigate(['/']);
  }
}
