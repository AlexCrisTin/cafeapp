import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

enum NotificationType {
  orderConfirmed,
  orderCompleted,
  orderCancelled,
  general,
}

class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? orderId;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'orderId': orderId,
    };
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.general,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      orderId: json['orderId'],
    );
  }

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? orderId,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      orderId: orderId ?? this.orderId,
    );
  }
}

class NotificationData {
  static List<Notification> notifications = [];
  static const String _fileName = 'notifications_data.json';

  // Lưu dữ liệu vào file
  static Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      final jsonData = notifications.map((notification) => notification.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Lỗi khi lưu thông báo: $e');
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
        
        notifications.clear();
        for (var notificationJson in jsonData) {
          notifications.add(Notification.fromJson(notificationJson));
        }
      }
    } catch (e) {
      print('Lỗi khi đọc thông báo: $e');
    }
  }

  // Thêm thông báo mới
  static Future<void> addNotification(Notification notification) async {
    notifications.add(notification);
    await _saveToFile();
  }

  // Đánh dấu thông báo đã đọc
  static Future<void> markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      await _saveToFile();
    }
  }

  // Đánh dấu tất cả thông báo của user đã đọc
  static Future<void> markAllAsRead(String userId) async {
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].userId == userId) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    await _saveToFile();
  }

  // Lấy thông báo của user
  static List<Notification> getUserNotifications(String userId) {
    return notifications
        .where((n) => n.userId == userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Đếm thông báo chưa đọc
  static int getUnreadCount(String userId) {
    return notifications
        .where((n) => n.userId == userId && !n.isRead)
        .length;
  }

  // Xóa thông báo cũ (giữ lại 50 thông báo gần nhất)
  static Future<void> cleanupOldNotifications() async {
    if (notifications.length > 50) {
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifications = notifications.take(50).toList();
      await _saveToFile();
    }
  }

  // Tạo thông báo cho đơn hàng
  static Future<void> createOrderNotification({
    required String userId,
    required String orderId,
    required NotificationType type,
    required String orderNumber,
  }) async {
    String title;
    String message;

    switch (type) {
      case NotificationType.orderConfirmed:
        title = 'Đơn hàng đã được xác nhận';
        message = 'Đơn hàng #$orderNumber của bạn đã được xác nhận và đang được chuẩn bị.';
        break;
      case NotificationType.orderCompleted:
        title = 'Đơn hàng đã hoàn thành';
        message = 'Đơn hàng #$orderNumber của bạn đã được giao thành công. Cảm ơn bạn đã sử dụng dịch vụ!';
        break;
      case NotificationType.orderCancelled:
        title = 'Đơn hàng bị hủy';
        message = 'Đơn hàng #$orderNumber của bạn đã bị hủy. Vui lòng liên hệ để biết thêm chi tiết.';
        break;
      default:
        title = 'Thông báo mới';
        message = 'Bạn có thông báo mới từ hệ thống.';
    }

    final notification = Notification(
      id: const Uuid().v4(),
      userId: userId,
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      orderId: orderId,
    );

    await addNotification(notification);
  }
}
