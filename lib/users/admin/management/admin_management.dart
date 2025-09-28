import 'package:flutter/material.dart';

class AdminManagement extends StatelessWidget {
  const AdminManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý hệ thống'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quản lý sản phẩm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildManagementCard(
              'Thêm sản phẩm mới',
              'Tạo sản phẩm mới cho menu',
              Icons.add_circle,
              Colors.green,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở form thêm sản phẩm')),
                );
              },
            ),
            _buildManagementCard(
              'Chỉnh sửa sản phẩm',
              'Cập nhật thông tin sản phẩm',
              Icons.edit,
              Colors.blue,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở danh sách sản phẩm')),
                );
              },
            ),
            _buildManagementCard(
              'Xóa sản phẩm',
              'Loại bỏ sản phẩm khỏi menu',
              Icons.delete,
              Colors.red,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở danh sách sản phẩm để xóa')),
                );
              },
            ),

            SizedBox(height: 30),

            Text(
              'Quản lý đơn hàng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildManagementCard(
              'Xem tất cả đơn hàng',
              'Danh sách đơn hàng trong hệ thống',
              Icons.list_alt,
              Colors.orange,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở danh sách đơn hàng')),
                );
              },
            ),
            _buildManagementCard(
              'Đơn hàng chờ xử lý',
              'Xử lý đơn hàng mới',
              Icons.pending_actions,
              Colors.amber,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở đơn hàng chờ xử lý')),
                );
              },
            ),

            SizedBox(height: 30),

            Text(
              'Quản lý người dùng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildManagementCard(
              'Danh sách người dùng',
              'Quản lý tài khoản người dùng',
              Icons.people,
              Colors.purple,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở danh sách người dùng')),
                );
              },
            ),
            _buildManagementCard(
              'Thống kê người dùng',
              'Phân tích hành vi người dùng',
              Icons.analytics,
              Colors.teal,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mở thống kê người dùng')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
