import 'package:flutter/material.dart';
import 'package:cafeproject/database/auth/navigation_helper.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thành công')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 12),
            Text('Đơn hàng đã giao thành công!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => NavigationHelper.getHomePage()),
                  (route) => false,
                );
              },
              child: const Text('Về trang chính'),
            )
          ],
        ),
      ),
    );
  }
}


