import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:cafeproject/users/admin/management/admin_users_page.dart';

class AdminManagement extends StatefulWidget {
  const AdminManagement({super.key});

  @override
  State<AdminManagement> createState() => _AdminManagementState();
}

class _AdminManagementState extends State<AdminManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý hệ thống'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductForm(context),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('Thêm sản phẩm'),
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
            _buildProductsTable(context),

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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminUsersPage()),
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

  Widget _buildProductsTable(BuildContext context) {
    final products = ProductData.getAllProducts();
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Giá', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 80),
            ],
          ),
          Divider(),
          ...products.map((p) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(p.name)),
                Expanded(child: Text(p.price.toStringAsFixed(0))),
                Expanded(child: Text(p.category)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openProductForm(context, product: p),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await ProductData.deleteProduct(p.id);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Đã xóa ${p.name}')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Future<void> _openProductForm(BuildContext context, {Product? product}) async {
    final isEdit = product != null;
    final idController = TextEditingController(text: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString());
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product != null ? product.price.toStringAsFixed(0) : '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final imageController = TextEditingController(text: product?.imagePath ?? '');
    final descController = TextEditingController(text: product?.description ?? '');

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Giá (VNĐ)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Danh mục'),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: 'Đường dẫn ảnh (assets/...)'),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Mô tả'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? 0;
                final category = categoryController.text.trim();
                final image = imageController.text.trim();
                final desc = descController.text.trim();

                if (name.isEmpty || price <= 0 || category.isEmpty || image.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin hợp lệ')),
                  );
                  return;
                }

                final newProduct = Product(
                  id: idController.text,
                  name: name,
                  description: desc,
                  price: price,
                  imagePath: image,
                  category: category,
                );

                if (isEdit) {
                  await ProductData.updateProduct(newProduct);
                } else {
                  await ProductData.addProduct(newProduct);
                }

                if (mounted) {
                  Navigator.of(ctx).pop();
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFDC586D), foregroundColor: Colors.white),
              child: Text(isEdit ? 'Lưu' : 'Thêm'),
            ),
          ],
        );
      },
    );
  }
}
