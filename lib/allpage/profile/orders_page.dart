import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/orders_service.dart';
import 'package:cafeproject/allpage/profile/order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final orders = OrdersService.orders.where((order) => order.status.name == 'pending').toList();
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
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(order: order),
                      ),
                    );
                    // Refresh the page when returning from order detail
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
