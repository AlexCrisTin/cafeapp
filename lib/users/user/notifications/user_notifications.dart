import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/notification_data.dart' as notification_data;
import 'package:cafeproject/page cafe/profile/order_detail_page.dart';
import 'package:cafeproject/database/data/orders_service.dart';
import 'package:cafeproject/database/auth/auth_service.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  List<notification_data.Notification> notifications = [];
  bool isLoading = true;
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await notification_data.NotificationData.loadFromFile();
    final AuthService _auth = AuthService.instance;
    currentUserId = _auth.currentUser?.email ?? 'guest';
    setState(() {
      notifications = notification_data.NotificationData.getUserNotifications(currentUserId);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: const Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Đánh dấu tất cả đã đọc',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationCard(notification);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Chưa có thông báo nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(notification_data.Notification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead 
                                  ? FontWeight.normal 
                                  : FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(notification.createdAt),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(notification_data.NotificationType type) {
    switch (type) {
      case notification_data.NotificationType.orderConfirmed:
        return Colors.blue;
      case notification_data.NotificationType.orderCompleted:
        return Colors.green;
      case notification_data.NotificationType.orderCancelled:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getNotificationIcon(notification_data.NotificationType type) {
    switch (type) {
      case notification_data.NotificationType.orderConfirmed:
        return Icons.check_circle;
      case notification_data.NotificationType.orderCompleted:
        return Icons.delivery_dining;
      case notification_data.NotificationType.orderCancelled:
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  Future<void> _handleNotificationTap(notification_data.Notification notification) async {
    // Đánh dấu đã đọc
    if (!notification.isRead) {
      await notification_data.NotificationData.markAsRead(notification.id);
      setState(() {
        notification = notification.copyWith(isRead: true);
      });
    }

    // Nếu có orderId, chuyển đến trang chi tiết đơn hàng
    if (notification.orderId != null) {
      try {
        // Tìm order trong danh sách orders
        final orders = OrdersService.orders;
        final order = orders.firstWhere((o) => o.id == notification.orderId);
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OrderDetailPage(order: order),
            ),
          );
        }
      } catch (e) {
        print('Không tìm thấy đơn hàng: $e');
      }
    }
  }

  Future<void> _markAllAsRead() async {
    await notification_data.NotificationData.markAllAsRead(currentUserId);
    await _loadNotifications();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đánh dấu tất cả thông báo đã đọc'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
