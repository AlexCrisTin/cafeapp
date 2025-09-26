import 'package:flutter/material.dart';
import 'package:cafeproject/data/orders_service.dart';
import 'package:cafeproject/profile/order_success_page.dart';

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
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Khách hàng: ' + order.customerName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text('SĐT: ' + order.phone),
            SizedBox(height: 6),
            Text('Địa chỉ: ' + order.address),
            SizedBox(height: 6),
            Text('Thanh toán: ' + order.paymentMethod),
            SizedBox(height: 12),
            Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: order.items.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final it = order.items[index];
                  return ListTile(
                    title: Text(it.product.name),
                    subtitle: Text('x${it.quantity}'),
                    trailing: Text(_formatPrice(it.product.price * it.quantity)),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng cộng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(_formatPrice(order.totalPrice), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  OrdersService.completeOrder(order.id);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const OrderSuccessPage()),
                  );
                },
                child: const Text('Giao thành công'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


