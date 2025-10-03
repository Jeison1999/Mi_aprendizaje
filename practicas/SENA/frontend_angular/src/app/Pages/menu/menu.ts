import { Component, OnInit, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Grupo, Producto, MenuService } from './menu.service';

interface CartItem {
  producto: Producto;
  cantidad: number;
}

@Component({
  selector: 'app-menu',
  imports: [CommonModule],
  templateUrl: './menu.html',
  styleUrl: './menu.css'
})
export class Menu implements OnInit {
  grupos: Grupo[] = [];
  filteredGrupos: Grupo[] = [];
  loading = true;
  selectedCategory = 'all';
  cartItems: CartItem[] = [];

  constructor(private menuService: MenuService) {}

  ngOnInit(): void {
    this.menuService.getGrupos().subscribe({
      next: (data) => {
        this.grupos = data;
        this.filteredGrupos = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error al cargar grupos', err);
        this.loading = false;
      }
    });
  }

  getTotalProductos(): number {
    return this.grupos.reduce((total, grupo) => total + grupo.productos.length, 0);
  }

  filterByCategory(categorySlug: string): void {
    this.selectedCategory = categorySlug;
    if (categorySlug === 'all') {
      this.filteredGrupos = this.grupos;
    } else {
      this.filteredGrupos = this.grupos.filter(grupo => grupo.slug === categorySlug);
    }
    
    // Scroll to the selected category
    if (categorySlug !== 'all') {
      setTimeout(() => {
        const element = document.getElementById(categorySlug);
        if (element) {
          element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      }, 100);
    }
  }

  addToCart(producto: Producto): void {
    const existingItem = this.cartItems.find(item => item.producto.id === producto.id);
    
    if (existingItem) {
      existingItem.cantidad += 1;
    } else {
      this.cartItems.push({ producto, cantidad: 1 });
    }

    // Show success message (you can implement a toast notification here)
    console.log(`Added ${producto.name} to cart`);
  }

  getTotalPrice(): number {
    return this.cartItems.reduce((total, item) => total + (item.producto.precio * item.cantidad), 0);
  }

  goToCheckout(): void {
    // Implement checkout logic
    console.log('Proceeding to checkout with items:', this.cartItems);
    // You can navigate to a checkout page or show a modal
  }
}
