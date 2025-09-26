import 'package:flutter/material.dart';
import 'package:cafeproject/data/orders_service.dart';
import 'package:cafeproject/profile/order_detail_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrdersService.orders;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng'))
          : ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order.customerName),
                  subtitle: Text('Tổng: ' + order.totalPrice.toInt().toString() + ' đ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(order: order),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
