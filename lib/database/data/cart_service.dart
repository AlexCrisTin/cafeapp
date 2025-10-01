import 'dart:convert';
import 'dart:io';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
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
  static final Map<String, List<CartItem>> _userCarts = {};
  static const String _fileName = 'cart_data.json';

  static List<CartItem> get items {
    final currentUserId = _getCurrentUserId();
    return List.unmodifiable(_userCarts[currentUserId] ?? []);
  }

  // Lấy ID của user hiện tại
  static String _getCurrentUserId() {
    final auth = AuthService.instance;
    if (auth.isLoggedIn && auth.currentUser != null) {
      return auth.currentUser!.email;
    } else if (auth.isGuest) {
      return 'guest';
    }
    return 'anonymous';
  }

  // Lưu dữ liệu vào file
  static Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      final jsonData = _userCarts.map((userId, items) => 
        MapEntry(userId, items.map((item) => item.toJson()).toList()));
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
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        
        _userCarts.clear();
        for (var userId in jsonData.keys) {
          final List<dynamic> userItems = jsonData[userId];
          final List<CartItem> items = [];
          
          for (var itemJson in userItems) {
            final productId = itemJson['productId'];
            final product = ProductData.getProductById(productId);
            if (product != null) {
              items.add(CartItem.fromJson(itemJson, product));
            }
          }
          
          _userCarts[userId] = items;
        }
      }
    } catch (e) {
      print('Lỗi khi đọc giỏ hàng: $e');
    }
  }

  static Future<void> addToCart(Product product, {int quantity = 1, String? selectedSize}) async {
    final currentUserId = _getCurrentUserId();
    if (!_userCarts.containsKey(currentUserId)) {
      _userCarts[currentUserId] = [];
    }
    
    final userItems = _userCarts[currentUserId]!;
    final index = userItems.indexWhere((it) => 
      it.product.id == product.id && it.selectedSize == selectedSize);
    if (index >= 0) {
      userItems[index].quantity += quantity;
    } else {
      userItems.add(CartItem(product: product, quantity: quantity, selectedSize: selectedSize));
    }
    await _saveToFile();
  }

  static Future<void> removeFromCart(String productId) async {
    final currentUserId = _getCurrentUserId();
    if (_userCarts.containsKey(currentUserId)) {
      _userCarts[currentUserId]!.removeWhere((it) => it.product.id == productId);
      await _saveToFile();
    }
  }

  static Future<void> updateQuantity(String productId, int quantity) async {
    final currentUserId = _getCurrentUserId();
    if (_userCarts.containsKey(currentUserId)) {
      final userItems = _userCarts[currentUserId]!;
      final index = userItems.indexWhere((it) => it.product.id == productId);
      if (index >= 0) {
        userItems[index].quantity = quantity.clamp(1, 9999);
        await _saveToFile();
      }
    }
  }

  static Future<void> increaseQuantity(String productId) async {
    final currentUserId = _getCurrentUserId();
    if (_userCarts.containsKey(currentUserId)) {
      final userItems = _userCarts[currentUserId]!;
      final index = userItems.indexWhere((it) => it.product.id == productId);
      if (index >= 0) {
        userItems[index].quantity += 1;
        await _saveToFile();
      }
    }
  }

  static Future<void> decreaseQuantity(String productId) async {
    final currentUserId = _getCurrentUserId();
    if (_userCarts.containsKey(currentUserId)) {
      final userItems = _userCarts[currentUserId]!;
      final index = userItems.indexWhere((it) => it.product.id == productId);
      if (index >= 0) {
        userItems[index].quantity -= 1;
        if (userItems[index].quantity <= 0) {
          userItems.removeAt(index);
        }
        await _saveToFile();
      }
    }
  }

  // Cập nhật size cho item; nếu đã tồn tại item cùng sản phẩm + size mới thì gộp số lượng
  static Future<void> setItemSize(String productId, String newSize) async {
    final currentUserId = _getCurrentUserId();
    if (!_userCarts.containsKey(currentUserId)) return;
    
    final userItems = _userCarts[currentUserId]!;
    final index = userItems.indexWhere((it) => it.product.id == productId);
    if (index < 0) return;

    final CartItem current = userItems[index];
    // Nếu không có size hoặc sản phẩm không hỗ trợ size thì bỏ qua
    if (!current.product.hasSize) return;

    // Nếu đã có item khác cùng product + size mới, gộp số lượng
    final duplicateIndex = userItems.indexWhere((it) => it.product.id == productId && it.selectedSize == newSize);
    if (duplicateIndex >= 0 && duplicateIndex != index) {
      userItems[duplicateIndex].quantity += current.quantity;
      userItems.removeAt(index);
    } else {
      userItems[index] = CartItem(product: current.product, quantity: current.quantity, selectedSize: newSize);
    }
    await _saveToFile();
  }

  static int get totalQuantity {
    final currentUserId = _getCurrentUserId();
    final userItems = _userCarts[currentUserId] ?? [];
    return userItems.fold(0, (sum, it) => sum + it.quantity);
  }

  static double get totalPrice {
    final currentUserId = _getCurrentUserId();
    final userItems = _userCarts[currentUserId] ?? [];
    return userItems.fold(0.0, (sum, it) => sum + it.totalPrice);
  }

  static Future<void> clear() async {
    final currentUserId = _getCurrentUserId();
    if (_userCarts.containsKey(currentUserId)) {
      _userCarts[currentUserId]!.clear();
      await _saveToFile();
    }
  }
}


