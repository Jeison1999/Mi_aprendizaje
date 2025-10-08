import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

interface OrderItem {
  id: number;
  quantity: number;
  unit_price: number;
  total_price: number;
  producto: {
    id: number;
    name: string;
    precio: number;
    descripcion: string;
  };
}

interface Pedido {
  id: number;
  order_number: string;
  customer_name: string;
  customer_email: string;
  customer_phone: string;
  total_amount: number;
  status: string;
  delivery_type: string;
  created_at: string;
  order_items?: OrderItem[];
}

@Component({
  selector: 'app-admin-pedidos',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './admin-pedidos.html',
  styleUrls: ['./admin-pedidos.css']
})
export class AdminPedidosComponent implements OnInit {
  pedidos: Pedido[] = [];
  filteredPedidos: Pedido[] = [];
  loading = false;
  error: string | null = null;
  selectedPedido: Pedido | null = null;

  // Filtros
  statusFilter = '';
  deliveryFilter = '';
  dateFilter = '';

  get hasActiveFilters(): boolean {
    return !!(this.statusFilter || this.deliveryFilter || this.dateFilter);
  }

  constructor() {}

  ngOnInit() {
    this.loadPedidos();
  }

  loadPedidos() {
    this.loading = true;
    this.error = null;
    
    // Mock data - aquí cargarías los datos reales del backend
    setTimeout(() => {
      this.pedidos = [
        {
          id: 1,
          order_number: 'ORD-20241201-A1B2',
          customer_name: 'Juan Pérez',
          customer_email: 'juan@email.com',
          customer_phone: '3001234567',
          total_amount: 45000,
          status: 'paid',
          delivery_type: 'domicilio',
          created_at: '2024-12-01T10:30:00Z',
          order_items: [
            {
              id: 1,
              quantity: 2,
              unit_price: 15000,
              total_price: 30000,
              producto: {
                id: 1,
                name: 'Hamburguesa Clásica',
                precio: 15000,
                descripcion: 'Hamburguesa con carne, lechuga, tomate y queso'
              }
            },
            {
              id: 2,
              quantity: 1,
              unit_price: 15000,
              total_price: 15000,
              producto: {
                id: 2,
                name: 'Papas Fritas',
                precio: 15000,
                descripcion: 'Papas fritas crujientes'
              }
            }
          ]
        },
        {
          id: 2,
          order_number: 'ORD-20241201-C3D4',
          customer_name: 'María García',
          customer_email: 'maria@email.com',
          customer_phone: '3007654321',
          total_amount: 32000,
          status: 'pending',
          delivery_type: 'recoger',
          created_at: '2024-12-01T14:15:00Z',
          order_items: [
            {
              id: 3,
              quantity: 1,
              unit_price: 32000,
              total_price: 32000,
              producto: {
                id: 3,
                name: 'Combo Familiar',
                precio: 32000,
                descripcion: '2 hamburguesas, 2 papas y 2 bebidas'
              }
            }
          ]
        },
        {
          id: 3,
          order_number: 'ORD-20241130-E5F6',
          customer_name: 'Carlos López',
          customer_email: 'carlos@email.com',
          customer_phone: '3009876543',
          total_amount: 28000,
          status: 'delivered',
          delivery_type: 'domicilio',
          created_at: '2024-11-30T18:45:00Z',
          order_items: [
            {
              id: 4,
              quantity: 1,
              unit_price: 28000,
              total_price: 28000,
              producto: {
                id: 4,
                name: 'Pizza Margherita',
                precio: 28000,
                descripcion: 'Pizza con tomate, mozzarella y albahaca'
              }
            }
          ]
        }
      ];
      
      this.applyFilters();
      this.loading = false;
    }, 1000);
  }

  applyFilters() {
    this.filteredPedidos = this.pedidos.filter(pedido => {
      let matches = true;

      if (this.statusFilter && pedido.status !== this.statusFilter) {
        matches = false;
      }

      if (this.deliveryFilter && pedido.delivery_type !== this.deliveryFilter) {
        matches = false;
      }

      if (this.dateFilter) {
        const pedidoDate = new Date(pedido.created_at).toDateString();
        const filterDate = new Date(this.dateFilter).toDateString();
        if (pedidoDate !== filterDate) {
          matches = false;
        }
      }

      return matches;
    });
  }

  clearFilters() {
    this.statusFilter = '';
    this.deliveryFilter = '';
    this.dateFilter = '';
    this.applyFilters();
  }

  viewPedido(pedido: Pedido) {
    this.selectedPedido = pedido;
  }

  closeModal() {
    this.selectedPedido = null;
  }

  markAsDelivered(pedidoId: number) {
    if (!confirm('¿Marcar este pedido como entregado?')) {
      return;
    }

    // Mock update - aquí harías la llamada al backend
    const pedido = this.pedidos.find(p => p.id === pedidoId);
    if (pedido) {
      pedido.status = 'delivered';
      this.applyFilters();
    }
  }

  getStatusText(status: string): string {
    const statusMap: { [key: string]: string } = {
      'pending': 'Pendiente',
      'paid': 'Pagado',
      'failed': 'Fallido',
      'delivered': 'Entregado'
    };
    return statusMap[status] || status;
  }

  getDeliveryTypeText(deliveryType: string): string {
    const typeMap: { [key: string]: string } = {
      'domicilio': 'Domicilio',
      'recoger': 'Recoger en tienda'
    };
    return typeMap[deliveryType] || deliveryType;
  }
}