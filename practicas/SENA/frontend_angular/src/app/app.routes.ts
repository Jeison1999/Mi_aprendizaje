import { Routes } from '@angular/router';
import { App } from './app';
import { Home } from './Pages/home/home';
import { Menu } from './Pages/menu/menu';

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
    {
        path: 'menu',
        component: Menu,
    }
];
