import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { GruposListComponent } from './grupos/grupos-list.component';
import { ProductosListComponent } from './productos/productos-list.component';

export const routes: Routes = [
	{ path: '', redirectTo: 'grupos', pathMatch: 'full' },
	{ path: 'login', component: LoginComponent },
	{ path: 'register', component: RegisterComponent },
	{ path: 'grupos', component: GruposListComponent },
	{ path: 'productos', component: ProductosListComponent },
];
