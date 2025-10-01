import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/orders_service.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;
  const OrderDetailPage({super.key, required this.order});

  String _formatPrice(double price) {
    final intValue = price.toInt();
    return intValue
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},') + ' VNĐ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng #${order.id}'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order status
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getStatusColor(order.status)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _getStatusColor(order.status)),
                  SizedBox(width: 8),
                  Text(
                    'Trạng thái: ${_getStatusText(order.status)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            // Customer info
            Text('Thông tin khách hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tên: ${order.customerName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('SĐT: ${order.phone}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('Địa chỉ: ${order.address}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            
            // Order items
            Text('Sản phẩm đã đặt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: order.items.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('Số lượng: ${item.quantity}${item.selectedSize != null ? ' (Size: ${item.selectedSize})' : ''}'),
                      trailing: Text(
                        _formatPrice(item.totalPrice),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            
            // Total
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng cộng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    _formatPrice(order.totalPrice),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC586D),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đang giao';
      case OrderStatus.completed:
        return 'Hoàn thành';
    }
  }

}


