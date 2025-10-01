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
    final completedOrders = orders.where((order) => order.status == OrderStatus.completed).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng của tôi'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          if (completedOrders.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () => _showClearCompletedDialog(),
              tooltip: 'Xóa đơn hàng đã hoàn thành',
            ),
        ],
      ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (order.status == OrderStatus.completed)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteOrderDialog(order.id),
                            tooltip: 'Xóa đơn hàng',
                          ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
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
      case OrderStatus.confirmed:
        color = Colors.blue;
        statusText = 'Đang giao';
        break;
      case OrderStatus.completed:
        color = Colors.green;
        statusText = 'Hoàn thành';
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

  void _showClearCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa đơn hàng đã hoàn thành'),
          content: Text('Bạn có chắc chắn muốn xóa tất cả đơn hàng đã hoàn thành? Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearCompletedOrders();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Xóa tất cả', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearCompletedOrders() async {
    final orders = OrdersService.getCurrentUserOrders();
    final completedOrders = orders.where((order) => order.status == OrderStatus.completed).toList();
    
    for (var order in completedOrders) {
      await OrdersService.deleteOrder(order.id);
    }
    
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa ${completedOrders.length} đơn hàng đã hoàn thành')),
    );
  }

  void _showDeleteOrderDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa đơn hàng'),
          content: Text('Bạn có chắc chắn muốn xóa đơn hàng này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteOrder(orderId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(String orderId) async {
    await OrdersService.deleteOrder(orderId);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa đơn hàng')),
    );
  }
}
