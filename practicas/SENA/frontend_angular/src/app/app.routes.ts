import { Routes } from '@angular/router';
import { Home } from './Pages/home/home';
import { Menu } from './Pages/menu/menu';
import { OrderComponent } from './Pages/order/order';
import { PagoComponent } from './Pages/pago/pago';

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
    }
];
