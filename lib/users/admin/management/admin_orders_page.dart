import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/orders_service.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String _selectedStatus = 'Tất cả';
  final List<String> _statusOptions = ['Tất cả', 'Chờ xác nhận', 'Đang giao', 'Hoàn thành'];


  @override
  Widget build(BuildContext context) {
    final pendingOrders = OrdersService.getPendingOrders();
    final confirmedOrders = OrdersService.getConfirmedOrders();
    final completedOrders = OrdersService.getCompletedOrders();
    final totalPending = pendingOrders.length;
    final totalConfirmed = confirmedOrders.length;
    final totalCompleted = completedOrders.length;
    

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng (Chờ: $totalPending, Đang giao: $totalConfirmed, Hoàn thành: $totalCompleted)'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          if (totalCompleted > 0)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () => _showClearCompletedDialog(),
              tooltip: 'Xóa đơn hàng đã hoàn thành',
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Text('Lọc theo trạng thái:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                    items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Orders list
          Expanded(
            child: _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    List<Order> orders;
    switch (_selectedStatus) {
      case 'Tất cả':
        orders = OrdersService.orders;
        break;
      case 'Chờ xác nhận':
        orders = OrdersService.getPendingOrders();
        break;
      case 'Đang giao':
        orders = OrdersService.getConfirmedOrders();
        break;
      case 'Hoàn thành':
        orders = OrdersService.getCompletedOrders();
        break;
      default:
        orders = OrdersService.orders;
    }
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              _getEmptyMessage(),
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng #${order.id}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.account_circle, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('Tài khoản: ${order.userId}'),
              ],
            ),
            SizedBox(height: 4),
            
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('SĐT: ${order.phone}'),
              ],
            ),
            SizedBox(height: 4),
            
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(child: Text('Địa chỉ: ${order.address}')),
              ],
            ),
            SizedBox(height: 12),
            
            // Order items
            Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            ...order.items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.product.name} x${item.quantity}${item.selectedSize != null ? ' (${item.selectedSize})' : ''}'),
                  Text('${item.totalPrice.toStringAsFixed(0)} đ'),
                ],
              ),
            )),
            SizedBox(height: 8),
            
            // Order total and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng: ${order.totalPrice.toStringAsFixed(0)} đ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFDC586D)),
                ),
                Row(
                  children: [
                    if (order.status == OrderStatus.pending) ...[
                      ElevatedButton(
                        onPressed: () => _showConfirmDialog(order.id, OrderStatus.confirmed, 'Xác nhận đơn hàng'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Xác nhận', style: TextStyle(fontSize: 12)),
                      ),
                    ] else if (order.status == OrderStatus.confirmed) ...[
                      ElevatedButton(
                        onPressed: () => _showConfirmDialog(order.id, OrderStatus.completed, 'Hoàn thành đơn hàng'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Hoàn thành', style: TextStyle(fontSize: 12)),
                      ),
                    ] else if (order.status == OrderStatus.completed) ...[
                      ElevatedButton(
                        onPressed: () => _showDeleteOrderDialog(order.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Xóa', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String statusText;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        statusText = 'Chờ xác nhận';
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        statusText = 'Đang giao';
        break;
      case OrderStatus.completed:
        color = Colors.green;
        statusText = 'Hoàn thành';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getEmptyMessage() {
    switch (_selectedStatus) {
      case 'Tất cả':
        return 'Không có đơn hàng nào';
      case 'Chờ xác nhận':
        return 'Không có đơn hàng chờ xác nhận';
      case 'Đang giao':
        return 'Không có đơn hàng đang giao';
      case 'Hoàn thành':
        return 'Không có đơn hàng đã hoàn thành';
      default:
        return 'Không có đơn hàng';
    }
  }

  void _showConfirmDialog(String orderId, OrderStatus newStatus, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Bạn có chắc chắn muốn ${title.toLowerCase()}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateOrderStatus(orderId, newStatus);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: newStatus == OrderStatus.confirmed ? Colors.blue : Colors.green,
              ),
              child: Text('Xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await OrdersService.updateOrderStatus(orderId, newStatus);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã cập nhật trạng thái đơn hàng')),
    );
  }

  void _showClearCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa đơn hàng đã hoàn thành'),
          content: Text('Bạn có chắc chắn muốn xóa tất cả đơn hàng đã hoàn thành? Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _clearCompletedOrders();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Xóa tất cả', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteOrderDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa đơn hàng'),
          content: Text('Bạn có chắc chắn muốn xóa đơn hàng này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteOrder(orderId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearCompletedOrders() async {
    await OrdersService.clearCompletedOrders();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa tất cả đơn hàng đã hoàn thành')),
    );
  }

  Future<void> _deleteOrder(String orderId) async {
    await OrdersService.deleteOrder(orderId);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa đơn hàng')),
    );
  }
}
