import 'package:flutter/material.dart';
import 'package:cafeproject/home/main_cafe.dart';
import 'package:cafeproject/data/product_data.dart';
import 'package:cafeproject/data/cart_service.dart';
import 'package:cafeproject/data/orders_service.dart';
import 'package:cafeproject/login/begin.dart';
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
      home: Begin(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
      ),
    );
  }
}