import { Routes } from '@angular/router';
import { Home } from './Pages/home/home';
import { Menu } from './Pages/menu/menu';
import { OrderComponent } from './Pages/order/order';

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
    }
];
