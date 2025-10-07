import { Routes } from '@angular/router';
import { Home } from './Pages/home/home';
import { Menu } from './Pages/menu/menu';
import { OrderComponent } from './Pages/order/order';
import { PagoComponent } from './Pages/pago/pago';
import { PerfilComponent } from './Pages/Perfil/perfil';
import { LoginComponent } from './Pages/auth/login/login';
import { RegisterComponent } from './Pages/auth/register/register';
import { AuthGuard } from './Guards/auth.guard';

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
    {
        path: 'menu',
        component: Menu,
    },
    {
        path: 'order',
        component: OrderComponent,
    },
    {
        path: 'pago',
        component: PagoComponent,
    },
    {
        path: 'perfil',
        component: PerfilComponent,
        canActivate: [AuthGuard]
    },
    {
        path: 'login',
        component: LoginComponent,
    },
    {
        path: 'register',
        component: RegisterComponent,
    }
];
