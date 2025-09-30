import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/order_data.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String _selectedStatus = 'Tất cả';
  final List<String> _statusOptions = ['Tất cả', 'Chờ xác nhận', 'Đang chuẩn bị', 'Đang giao', 'Đã giao', 'Đã hủy'];

  @override
  Widget build(BuildContext context) {
    final totalOrders = OrderData.getAllOrders().length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng ($totalOrders)'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
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
    final orders = OrderData.getAllOrders();
    final filteredOrders = _selectedStatus == 'Tất cả' 
        ? orders 
        : orders.where((order) => order.status == _selectedStatus).toList();

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 20),
            Text(
              'Không có đơn hàng nào',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
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
            
            // Customer info
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('Khách hàng: ${order.customerName}'),
              ],
            ),
            SizedBox(height: 4),
            
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
                Text('SĐT: ${order.customerPhone}'),
              ],
            ),
            SizedBox(height: 4),
            
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(child: Text('Địa chỉ: ${order.deliveryAddress}')),
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
                  Text('${item.productName} x${item.quantity}'),
                  Text('${(item.price * item.quantity).toStringAsFixed(0)} đ'),
                ],
              ),
            )),
            SizedBox(height: 8),
            
            // Order total and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng: ${order.totalAmount.toStringAsFixed(0)} đ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFDC586D)),
                ),
                Row(
                  children: [
                    if (order.status == 'Chờ xác nhận') ...[
                      ElevatedButton(
                        onPressed: () => _updateOrderStatus(order.id, 'Đang chuẩn bị'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Xác nhận', style: TextStyle(fontSize: 12)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _updateOrderStatus(order.id, 'Đã hủy'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Hủy', style: TextStyle(fontSize: 12)),
                      ),
                    ] else if (order.status == 'Đang chuẩn bị') ...[
                      ElevatedButton(
                        onPressed: () => _updateOrderStatus(order.id, 'Đang giao'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Giao hàng', style: TextStyle(fontSize: 12)),
                      ),
                    ] else if (order.status == 'Đang giao') ...[
                      ElevatedButton(
                        onPressed: () => _updateOrderStatus(order.id, 'Đã giao'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: Text('Hoàn thành', style: TextStyle(fontSize: 12)),
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

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Chờ xác nhận':
        color = Colors.orange;
        break;
      case 'Đang chuẩn bị':
        color = Colors.blue;
        break;
      case 'Đang giao':
        color = Colors.purple;
        break;
      case 'Đã giao':
        color = Colors.green;
        break;
      case 'Đã hủy':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    OrderData.updateOrderStatus(orderId, newStatus);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã cập nhật trạng thái đơn hàng')),
    );
  }
}
