import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/orders_service.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String _selectedStatus = 'Chờ xác nhận';
  final List<String> _statusOptions = ['Chờ xác nhận', 'Đã giao'];


  @override
  Widget build(BuildContext context) {
    final pendingOrders = OrdersService.getPendingOrders();
    final completedOrders = OrdersService.getCompletedOrders();
    final totalPending = pendingOrders.length;
    final totalCompleted = completedOrders.length;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          if (totalCompleted > 0)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () => _showClearCompletedDialog(),
              tooltip: 'Xóa đơn hàng đã giao',
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
    final orders = _selectedStatus == 'Chờ xác nhận' 
        ? OrdersService.getPendingOrders()
        : OrdersService.getCompletedOrders();

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              _selectedStatus == 'Chờ xác nhận' 
                  ? 'Không có đơn hàng chờ xử lý'
                  : 'Không có đơn hàng đã giao',
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
                        onPressed: () => _updateOrderStatus(order.id, OrderStatus.completed),
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
      case OrderStatus.completed:
        color = Colors.green;
        statusText = 'Đã giao';
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

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    OrdersService.updateOrderStatus(orderId, newStatus);
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
          title: Text('Xóa đơn hàng đã giao'),
          content: Text('Bạn có chắc chắn muốn xóa tất cả đơn hàng đã giao? Hành động này không thể hoàn tác.'),
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
      SnackBar(content: Text('Đã xóa tất cả đơn hàng đã giao')),
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
