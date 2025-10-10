import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AdminOrdersService, Order, OrderItem } from '../admin-orders.service';

// Alias para mantener compatibilidad con el template
type Pedido = Order;

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

  constructor(private adminOrdersService: AdminOrdersService) {}

  ngOnInit() {
    this.loadPedidos();
  }

  loadPedidos() {
    this.loading = true;
    this.error = null;
    
    this.adminOrdersService.getOrders().subscribe({
      next: (orders) => {
        this.pedidos = orders;
        this.applyFilters();
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading orders:', error);
        this.error = 'Error al cargar los pedidos';
        this.loading = false;
      }
    });
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

    this.adminOrdersService.updateOrderStatus(pedidoId, 'delivered').subscribe({
      next: (response) => {
        if (response.success) {
          // Actualizar el estado local
          const pedido = this.pedidos.find(p => p.id === pedidoId);
          if (pedido) {
            pedido.status = 'delivered';
            this.applyFilters();
          }
        }
      },
      error: (error) => {
        console.error('Error updating order status:', error);
        alert('Error al actualizar el estado del pedido');
      }
    });
  }

  updateOrderStatus(pedidoId: number, newStatus: string) {
    const statusText = this.getStatusText(newStatus);
    if (!confirm(`¿Cambiar el estado a "${statusText}"?`)) {
      return;
    }

    this.adminOrdersService.updateOrderStatus(pedidoId, newStatus).subscribe({
      next: (response) => {
        if (response.success) {
          // Actualizar el estado local
          const pedido = this.pedidos.find(p => p.id === pedidoId);
          if (pedido) {
            pedido.status = newStatus;
            this.applyFilters();
          }
        }
      },
      error: (error) => {
        console.error('Error updating order status:', error);
        alert('Error al actualizar el estado del pedido');
      }
    });
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

  getStatusClass(status: string): string {
    const classMap: { [key: string]: string } = {
      'pending': 'status-pending',
      'paid': 'status-paid',
      'failed': 'status-failed',
      'delivered': 'status-delivered'
    };
    return classMap[status] || 'status-default';
  }

  formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-CO', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatPrice(amount: number): string {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0
    }).format(amount);
  }

  getAvailableStatuses(currentStatus: string): string[] {
    const statusFlow: { [key: string]: string[] } = {
      'pending': ['paid', 'failed'],
      'paid': ['delivered', 'failed'],
      'failed': ['pending'],
      'delivered': [] // No se puede cambiar desde entregado
    };
    return statusFlow[currentStatus] || [];
  }

  refreshOrders() {
    this.loadPedidos();
  }
}