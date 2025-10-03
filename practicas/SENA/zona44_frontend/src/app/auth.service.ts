import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private apiUrl = 'http://localhost:3000/usuarios';
  private tokenKey = 'auth_token';
  private userRole = new BehaviorSubject<string | null>(null);

  constructor(private http: HttpClient) {}

  login(email: string, password: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/sign_in`, {
      usuario: { email, password }
    }, { observe: 'response' }).pipe(
      tap(response => {
        const token = response.headers.get('Authorization');
        if (token) {
          localStorage.setItem(this.tokenKey, token);
        }
        const body = response.body as { role?: string };
        if (body && body.role) {
          this.userRole.next(body.role);
        }
      })
    );
  }

  register(email: string, password: string, role: string): Observable<any> {
    return this.http.post(`${this.apiUrl}`, {
      usuario: { email, password, role }
    }, { observe: 'response' }).pipe(
      tap(response => {
        const token = response.headers.get('Authorization');
        if (token) {
          localStorage.setItem(this.tokenKey, token);
        }
        const body = response.body as { role?: string };
        if (body && body.role) {
          this.userRole.next(body.role);
        }
      })
    );
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  getRole(): Observable<string | null> {
    return this.userRole.asObservable();
  }

  logout(): void {
    localStorage.removeItem(this.tokenKey);
    this.userRole.next(null);
  }

  getAuthHeaders(): HttpHeaders {
    const token = this.getToken();
    return new HttpHeaders({
      'Authorization': token ? token : ''
    });
  }
}
