import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, BehaviorSubject, of } from 'rxjs';
import { map, catchError } from 'rxjs/operators';

export interface User {
  id: number;
  email: string;
  first_name: string;
  last_name: string;
  phone: string;
  address: string;
  city: string;
  department: string;
  role: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  first_name: string;
  last_name: string;
  phone: string;
  address: string;
  city: string;
  department: string;
}

export interface AuthResponse {
  success: boolean;
  user_id?: number;
  token?: string;
  message?: string;
  errors?: string[];
}

export interface GoogleAuthRequest {
  id_token: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://localhost:3000/api/v1';
  private currentUserSubject = new BehaviorSubject<User | null>(null);
  private tokenSubject = new BehaviorSubject<string | null>(null);

  public currentUser$ = this.currentUserSubject.asObservable();
  public token$ = this.tokenSubject.asObservable();

  constructor(private http: HttpClient) {
    // Cargar token y usuario desde localStorage al inicializar
    const token = localStorage.getItem('auth_token');
    const user = localStorage.getItem('current_user');
    
    if (token) {
      this.tokenSubject.next(token);
    }
    
    if (user) {
      this.currentUserSubject.next(JSON.parse(user));
    }
  }

  login(credentials: LoginRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.apiUrl}/login`, credentials).pipe(
      map(response => {
        if (response.success && response.token) {
          this.setToken(response.token);
          // Cargar perfil del usuario después del login
          this.loadUserProfile().subscribe();
        }
        return response;
      }),
      catchError(error => {
        console.error('Login error:', error);
        return of({ success: false, message: 'Error al iniciar sesión' });
      })
    );
  }

  register(userData: RegisterRequest): Observable<AuthResponse> {
    const payload = { user: userData };
    return this.http.post<AuthResponse>(`${this.apiUrl}/register`, payload).pipe(
      catchError(error => {
        console.error('Register error:', error);
        return of({ success: false, message: 'Error al registrarse' });
      })
    );
  }

  loginWithGoogle(idToken: string): Observable<AuthResponse> {
    const payload: GoogleAuthRequest = { id_token: idToken };
    return this.http.post<AuthResponse>(`${this.apiUrl}/auth/google`, payload).pipe(
      map(response => {
        if (response.success && response.token) {
          this.setToken(response.token);
          // Cargar perfil del usuario después del login con Google
          this.loadUserProfile().subscribe();
        }
        return response;
      }),
      catchError(error => {
        console.error('Google login error:', error);
        return of({ success: false, message: 'Error al iniciar sesión con Google' });
      })
    );
  }

  loadUserProfile(): Observable<User | null> {
    const token = this.getToken();
    if (!token) {
      return of(null);
    }

    const headers = new HttpHeaders({
      'Authorization': token,
      'Content-Type': 'application/json'
    });

    return this.http.get<User>(`${this.apiUrl}/profile`, { headers }).pipe(
      map(user => {
        this.setCurrentUser(user);
        return user;
      }),
      catchError(error => {
        console.error('Profile load error:', error);
        this.logout();
        return of(null);
      })
    );
  }

  updateProfile(userData: Partial<User>): Observable<{ success: boolean; message?: string; errors?: string[] }> {
    const token = this.getToken();
    if (!token) {
      return of({ success: false, message: 'No autorizado' });
    }

    const headers = new HttpHeaders({
      'Authorization': token,
      'Content-Type': 'application/json'
    });

    const payload = { user: userData };

    return this.http.put<{ success: boolean; message?: string; errors?: string[] }>(`${this.apiUrl}/profile`, payload, { headers }).pipe(
      map(res => {
        // Tras actualizar, recargar el perfil para mantener el estado consistente
        if (res.success) {
          this.loadUserProfile().subscribe();
        }
        return res;
      }),
      catchError(error => {
        console.error('Profile update error:', error);
        return of({ success: false, message: 'Error al actualizar el perfil' });
      })
    );
  }

  deleteProfile(): Observable<{ success: boolean; message?: string }> {
    const token = this.getToken();
    if (!token) {
      return of({ success: false, message: 'No autorizado' });
    }

    const headers = new HttpHeaders({
      'Authorization': token,
      'Content-Type': 'application/json'
    });

    return this.http.delete<{ success: boolean; message?: string }>(`${this.apiUrl}/profile`, { headers }).pipe(
      map(res => {
        if (res.success) {
          this.logout();
        }
        return res;
      }),
      catchError(error => {
        console.error('Profile delete error:', error);
        return of({ success: false, message: 'Error al eliminar el perfil' });
      })
    );
  }

  logout(): void {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('current_user');
    this.tokenSubject.next(null);
    this.currentUserSubject.next(null);
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }

  getCurrentUser(): User | null {
    return this.currentUserSubject.value;
  }

  getToken(): string | null {
    return this.tokenSubject.value || localStorage.getItem('auth_token');
  }

  private setToken(token: string): void {
    localStorage.setItem('auth_token', token);
    this.tokenSubject.next(token);
  }

  private setCurrentUser(user: User): void {
    localStorage.setItem('current_user', JSON.stringify(user));
    this.currentUserSubject.next(user);
  }
}
