import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/orders_service.dart';
import 'package:cafeproject/page%20cafe/profile/order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final orders = OrdersService.getCurrentUserOrders();
    
    return Scaffold(
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 20),
                  Text(
                    'Chưa có đơn hàng nào',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Hãy đặt hàng để xem đơn hàng ở đây',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('Đơn hàng #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tổng: ${order.totalPrice.toStringAsFixed(0)} đ'),
                        SizedBox(height: 4),
                        _buildStatusChip(order.status),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String statusText;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        statusText = 'Chờ xác nhận';
        break;
      case OrderStatus.completed:
        color = Colors.green;
        statusText = 'Đã giao';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
