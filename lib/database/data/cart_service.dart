import 'dart:convert';
import 'dart:io';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:path_provider/path_provider.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedSize;

  CartItem({required this.product, this.quantity = 1, this.selectedSize});

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

  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    return CartItem(
      product: product,
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'],
    );
  }
}

class CartService {
  static final List<CartItem> _items = [];
  static const String _fileName = 'cart_data.json';

  static List<CartItem> get items => List.unmodifiable(_items);

  // Lưu dữ liệu vào file
  static Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      final jsonData = _items.map((item) => item.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Lỗi khi lưu giỏ hàng: $e');
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
        
        _items.clear();
        for (var itemJson in jsonData) {
          final productId = itemJson['productId'];
          final product = ProductData.getProductById(productId);
          if (product != null) {
            _items.add(CartItem.fromJson(itemJson, product));
          }
        }
      }
    } catch (e) {
      print('Lỗi khi đọc giỏ hàng: $e');
    }
  }

  static Future<void> addToCart(Product product, {int quantity = 1, String? selectedSize}) async {
    final index = _items.indexWhere((it) => 
      it.product.id == product.id && it.selectedSize == selectedSize);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity, selectedSize: selectedSize));
    }
    await _saveToFile();
  }

  static Future<void> removeFromCart(String productId) async {
    _items.removeWhere((it) => it.product.id == productId);
    await _saveToFile();
  }

  static Future<void> updateQuantity(String productId, int quantity) async {
    final index = _items.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity.clamp(1, 9999);
      await _saveToFile();
    }
  }

  static Future<void> increaseQuantity(String productId) async {
    final index = _items.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      _items[index].quantity += 1;
      await _saveToFile();
    }
  }

  static Future<void> decreaseQuantity(String productId) async {
    final index = _items.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = (_items[index].quantity - 1).clamp(1, 9999);
      await _saveToFile();
    }
  }

  static int get totalQuantity => _items.fold(0, (sum, it) => sum + it.quantity);

  static double get totalPrice => _items.fold(0.0, (sum, it) => sum + it.totalPrice);

  static Future<void> clear() async {
    _items.clear();
    await _saveToFile();
  }
}


