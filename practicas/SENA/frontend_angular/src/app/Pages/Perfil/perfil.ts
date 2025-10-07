import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService, User } from '../../Services/auth.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-perfil',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './perfil.html',
  styleUrl: './perfil.css'
})
export class PerfilComponent implements OnInit, OnDestroy {
  currentUser: User | null = null;
  isEditing = false;
  loading = false;
  error = '';
  success = '';
  
  // Form data for editing
  editForm = {
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    department: ''
  };

  private authSubscription: Subscription = new Subscription();

  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Verificar si el usuario está autenticado
    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login']);
      return;
    }

    // Suscribirse a cambios del usuario
    this.authSubscription.add(
      this.authService.currentUser$.subscribe(user => {
        this.currentUser = user;
        if (user) {
          this.populateEditForm(user);
        }
      })
    );

    // Cargar perfil si no está cargado
    if (!this.currentUser) {
      this.loadUserProfile();
    }
  }

  ngOnDestroy(): void {
    this.authSubscription.unsubscribe();
  }

  private loadUserProfile(): void {
    this.loading = true;
    this.authService.loadUserProfile().subscribe({
      next: (user) => {
        this.loading = false;
        if (!user) {
          this.router.navigate(['/login']);
        }
      },
      error: (error) => {
        this.loading = false;
        this.error = 'Error al cargar el perfil';
        console.error('Profile load error:', error);
        this.router.navigate(['/login']);
      }
    });
  }

  private populateEditForm(user: User): void {
    this.editForm = {
      first_name: user.first_name || '',
      last_name: user.last_name || '',
      email: user.email || '',
      phone: user.phone || '',
      address: user.address || '',
      city: user.city || '',
      department: user.department || ''
    };
  }

  toggleEdit(): void {
    this.isEditing = !this.isEditing;
    this.error = '';
    this.success = '';
    
    if (this.isEditing && this.currentUser) {
      this.populateEditForm(this.currentUser);
    }
  }

  saveProfile(): void {
    if (!this.validateForm()) {
      return;
    }

    this.loading = true;
    this.error = '';
    this.success = '';

    // Aquí implementarías la lógica para actualizar el perfil
    // Por ahora simulamos una actualización exitosa
    setTimeout(() => {
      this.loading = false;
      this.success = 'Perfil actualizado exitosamente';
      this.isEditing = false;
      
      // Actualizar el usuario actual con los nuevos datos
      if (this.currentUser) {
        const updatedUser = { ...this.currentUser, ...this.editForm };
        // Aquí deberías actualizar el usuario en el AuthService
        // this.authService.updateCurrentUser(updatedUser);
      }
    }, 1000);
  }

  cancelEdit(): void {
    this.isEditing = false;
    this.error = '';
    this.success = '';
    if (this.currentUser) {
      this.populateEditForm(this.currentUser);
    }
  }

  private validateForm(): boolean {
    if (!this.editForm.first_name.trim()) {
      this.error = 'El nombre es requerido';
      return false;
    }
    if (!this.editForm.last_name.trim()) {
      this.error = 'El apellido es requerido';
      return false;
    }
    if (!this.editForm.email.trim()) {
      this.error = 'El email es requerido';
      return false;
    }
    if (!this.isValidEmail(this.editForm.email)) {
      this.error = 'Ingresa un email válido';
      return false;
    }
    if (!this.editForm.phone.trim()) {
      this.error = 'El teléfono es requerido';
      return false;
    }
    if (!this.editForm.address.trim()) {
      this.error = 'La dirección es requerida';
      return false;
    }
    if (!this.editForm.city.trim()) {
      this.error = 'La ciudad es requerida';
      return false;
    }
    if (!this.editForm.department.trim()) {
      this.error = 'El departamento es requerido';
      return false;
    }
    return true;
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  logout(): void {
    this.authService.logout();
    this.router.navigate(['/']);
  }

  goToHome(): void {
    this.router.navigate(['/']);
  }

  goToMenu(): void {
    this.router.navigate(['/menu']);
  }
}