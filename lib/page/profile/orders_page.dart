import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/orders_service.dart';
import 'package:cafeproject/page/profile/order_detail_page.dart';
import 'package:cafeproject/database/auth/auth_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    final userId = auth.currentUser?.email;
    final orders = OrdersService.orders
        .where((order) => order.status.name == 'pending')
        .where((order) => userId == null ? false : order.userId == userId)
        .toList();
    return Scaffold(
      
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
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
