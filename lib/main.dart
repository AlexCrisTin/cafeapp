import 'package:flutter/material.dart';
import 'package:cafeproject/data/data/product_data.dart';
import 'package:cafeproject/data/data/cart_service.dart';
import 'package:cafeproject/data/data/orders_service.dart';
import 'package:cafeproject/data/auth/navigation_helper.dart';
import 'package:cafeproject/data/auth/auth_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load dữ liệu khi khởi động app
  await _initializeData();
  
  runApp(const MyApp());
}

Future<void> _initializeData() async {
  try {
    // Load dữ liệu sản phẩm trước
    await ProductData.loadFromFile();
    
    // Load dữ liệu giỏ hàng
    await CartService.loadFromFile();
    
    // Load dữ liệu đơn hàng
    await OrdersService.loadFromFile();
    
    // Load users
    await AuthService.instance.loadFromFile();
    
    print('Dữ liệu đã được tải thành công');
  } catch (e) {
    print('Lỗi khi tải dữ liệu: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppRouter(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationHelper.getHomePage();
  }
}