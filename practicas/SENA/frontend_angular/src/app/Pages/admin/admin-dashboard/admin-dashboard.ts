import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './admin-dashboard.html',
  styleUrls: ['./admin-dashboard.css']
})
export class AdminDashboardComponent implements OnInit {
  stats = {
    totalUsers: 0,
    totalOrders: 0,
    totalProducts: 0,
    totalRevenue: 0
  };

  recentOrders: any[] = [];

  constructor() {}

  ngOnInit() {
    this.loadDashboardData();
  }

  loadDashboardData() {
    // Aquí cargarías los datos reales del backend
    // Por ahora usamos datos mock
    this.stats = {
      totalUsers: 1247,
      totalOrders: 3421,
      totalProducts: 89,
      totalRevenue: 125430
    };

    this.recentOrders = [
      {
        order_number: 'ORD-20241201-A1B2',
        customer_name: 'Juan Pérez',
        total_amount: 45000,
        status: 'paid',
        created_at: new Date()
      },
      {
        order_number: 'ORD-20241201-C3D4',
        customer_name: 'María García',
        total_amount: 32000,
        status: 'pending',
        created_at: new Date()
      },
      {
        order_number: 'ORD-20241201-E5F6',
        customer_name: 'Carlos López',
        total_amount: 28000,
        status: 'paid',
        created_at: new Date()
      }
    ];
  }

  getStatusText(status: string): string {
    const statusMap: { [key: string]: string } = {
      'pending': 'Pendiente',
      'paid': 'Pagado',
      'failed': 'Fallido'
    };
    return statusMap[status] || status;
  }
}