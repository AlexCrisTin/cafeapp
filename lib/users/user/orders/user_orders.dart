import 'package:flutter/material.dart';
import 'package:cafeproject/page%20cafe/profile/orders_page.dart';

class UserOrders extends StatelessWidget {
  const UserOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrdersPage(),
    );
  }
}
