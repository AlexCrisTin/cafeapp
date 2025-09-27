import 'package:cafeproject/data/cart_service.dart';
import 'package:cafeproject/data/product_data.dart';

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
}

class OrdersService {
  static final List<Order> _orders = [];

  static List<Order> get orders => List.unmodifiable(_orders);

  static Order createOrder({
    required String name,
    required String phone,
    required String address,
    required String payment,
    required List<CartItem> cartItems,
  }) {
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
    return order;
  }

  static void completeOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _orders[index].status = OrderStatus.completed;
      _orders.removeAt(index);
    }
  }

  static void clear() {
    _orders.clear();
  }
}


