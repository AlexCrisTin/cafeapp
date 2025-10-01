class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? size;
  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.size,
  });
}
class Order {
  final String id;
  final String userId; // ID của tài khoản người dùng
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });
}
class OrderData {
  static List<Order> _orders = [];
  static List<Order> getAllOrders() {
    return List.from(_orders);
  }
  static Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
  static void addOrder(Order order) {
    _orders.add(order);
  }
  static void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = Order(
        id: order.id,
        userId: order.userId,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        deliveryAddress: order.deliveryAddress,
        items: order.items,
        totalAmount: order.totalAmount,
        status: newStatus,
        createdAt: order.createdAt,
      );
    }
  }
  static void deleteOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
  }
  static List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }
  static int getOrderCountByStatus(String status) {
    return _orders.where((order) => order.status == status).length;
  }
  static double getTotalRevenue() {
    return _orders
        .where((order) => order.status == 'Đã giao')
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  static List<Order> getOrdersByUserId(String userId) {
    return _orders.where((order) => order.userId == userId).toList();
  }
}
