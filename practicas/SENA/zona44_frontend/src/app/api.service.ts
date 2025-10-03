import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

@Injectable({ providedIn: 'root' })
export class GrupoService {
  private apiUrl = 'http://localhost:3000/grupos';

  constructor(private http: HttpClient, private auth: AuthService) {}

  getGrupos(): Observable<any> {
    return this.http.get(this.apiUrl);
  }

  getGrupo(id: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/${id}`);
  }

  crearGrupo(data: any): Observable<any> {
    return this.http.post(this.apiUrl, { grupo: data }, {
      headers: this.auth.getAuthHeaders()
    });
  }

  actualizarGrupo(id: number, data: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/${id}`, { grupo: data }, {
      headers: this.auth.getAuthHeaders()
    });
  }

  eliminarGrupo(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`, {
      headers: this.auth.getAuthHeaders()
    });
  }
}

@Injectable({ providedIn: 'root' })
export class ProductoService {
  private apiUrl = 'http://localhost:3000/productos';

  constructor(private http: HttpClient, private auth: AuthService) {}

  getProductos(): Observable<any> {
    return this.http.get(this.apiUrl);
  }

  getProducto(id: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/${id}`);
  }

  crearProducto(data: any): Observable<any> {
    return this.http.post(this.apiUrl, { producto: data }, {
      headers: this.auth.getAuthHeaders()
    });
  }

  actualizarProducto(id: number, data: any): Observable<any> {
    return this.http.put(`${this.apiUrl}/${id}`, { producto: data }, {
      headers: this.auth.getAuthHeaders()
    });
  }

  eliminarProducto(id: number): Observable<any> {
    return this.http.delete(`${this.apiUrl}/${id}`, {
      headers: this.auth.getAuthHeaders()
    });
  }
}
