import 'dart:convert';
import 'dart:io';
import 'package:cafeproject/database/data/cart_service.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:path_provider/path_provider.dart';

enum OrderStatus { pending, completed }

class OrderItem {
  final Product product;
  final int quantity;
  final String? selectedSize;

  OrderItem({required this.product, required this.quantity, this.selectedSize});

  double get totalPrice {
    if (selectedSize != null && product.hasSize) {
      return product.getPriceForSize(selectedSize!) * quantity;
    }
    return product.price * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'selectedSize': selectedSize,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json, Product product) {
    return OrderItem(
      product: product,
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'],
    );
  }
}

class Order {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final String paymentMethod; // card, cash, other
  final List<OrderItem> items;
  OrderStatus status;

  Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.items,
    this.status = OrderStatus.pending,
  });

  double get totalPrice => items
      .fold(0.0, (sum, it) => sum + it.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'phone': phone,
      'address': address,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.name,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final List<OrderItem> orderItems = [];
    for (var itemJson in json['items']) {
      final productId = itemJson['productId'];
      final product = ProductData.getProductById(productId);
      if (product != null) {
        orderItems.add(OrderItem.fromJson(itemJson, product));
      }
    }

    return Order(
      id: json['id'],
      customerName: json['customerName'],
      phone: json['phone'],
      address: json['address'],
      paymentMethod: json['paymentMethod'],
      items: orderItems,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
    );
  }
}

class OrdersService {
  static final List<Order> _orders = [];
  static const String _fileName = 'orders_data.json';

  static List<Order> get orders => List.unmodifiable(_orders);

  // Lưu dữ liệu vào file
  static Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      final jsonData = _orders.map((order) => order.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Lỗi khi lưu đơn hàng: $e');
    }
  }

  // Đọc dữ liệu từ file
  static Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        
        _orders.clear();
        for (var orderJson in jsonData) {
          _orders.add(Order.fromJson(orderJson));
        }
      }
    } catch (e) {
      print('Lỗi khi đọc đơn hàng: $e');
    }
  }

  static Future<Order> createOrder({
    required String name,
    required String phone,
    required String address,
    required String payment,
    required List<CartItem> cartItems,
  }) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: name,
      phone: phone,
      address: address,
      paymentMethod: payment,
      items: cartItems
          .map((ci) => OrderItem(product: ci.product, quantity: ci.quantity, selectedSize: ci.selectedSize))
          .toList(),
    );
    _orders.add(order);
    await _saveToFile();
    return order;
  }

  static Future<void> completeOrder(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = OrderStatus.completed;
      await _saveToFile();
    }
  }

  static Future<void> clear() async {
    _orders.clear();
    await _saveToFile();
  }
}


