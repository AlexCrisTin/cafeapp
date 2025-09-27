import 'package:cafeproject/data/product_data.dart';

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
}

class CartService {
  static final List<CartItem> _items = [];

  static List<CartItem> get items => List.unmodifiable(_items);

  static void addToCart(Product product, {int quantity = 1, String? selectedSize}) {
    final index = _items.indexWhere((it) => 
      it.product.id == product.id && it.selectedSize == selectedSize);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity, selectedSize: selectedSize));
    }
  }

  static void removeFromCart(String productId) {
    _items.removeWhere((it) => it.product.id == productId);
  }

  static void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity.clamp(1, 9999);
    }
  }

  static void increaseQuantity(String productId) {
    final index = _items.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      _items[index].quantity += 1;
    }
  }

  static void decreaseQuantity(String productId) {
    final index = _items.indexWhere((it) => it.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = (_items[index].quantity - 1).clamp(1, 9999);
    }
  }

  static int get totalQuantity => _items.fold(0, (sum, it) => sum + it.quantity);

  static double get totalPrice => _items.fold(0.0, (sum, it) => sum + it.totalPrice);

  static void clear() {
    _items.clear();
  }
}


