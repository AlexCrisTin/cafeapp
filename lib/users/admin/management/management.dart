import 'package:flutter/material.dart';
import 'package:cafeproject/users/admin/management/admin_products_page.dart';
import 'package:cafeproject/users/admin/management/admin_users_page.dart';
import 'package:cafeproject/users/admin/management/admin_orders_page.dart';
 

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
      //  chuyển sang trang quản lý sản phẩm
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
              'Xem và quản lý sản phẩm',
              'Danh sách, tìm kiếm, thêm/sửa/xóa sản phẩm',
              Icons.inventory_2,
              Colors.teal,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminProductsPage()),
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminOrdersPage()),
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

  // Bảng sản phẩm đã được chuyển sang AdminProductsPage

  /*Future<void> _openProductForm(BuildContext context, {Product? product}) async {
    final isEdit = product != null;
    final idController = TextEditingController(text: product?.id ?? const Uuid().v4());
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product != null ? product.price.toStringAsFixed(0) : '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final descController = TextEditingController(text: product?.description ?? '');
    
    XFile? selectedImage;
    String? imagePath = product?.imagePath;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    SizedBox(height: 16),
                    // Image picker section
                    Text(
                      'Chọn ảnh sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _pickImage(context, (image) {
                                setState(() {
                                  selectedImage = image;
                                  imagePath = image.path;
                                });
                              });
                            },
                            icon: Icon(Icons.camera_alt),
                            label: Text('Chọn ảnh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFDC586D),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        if (selectedImage != null || (product?.imagePath != null && product!.imagePath.startsWith('/')))
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectedImage = null;
                                  imagePath = null;
                                });
                              },
                              icon: Icon(Icons.delete),
                              label: Text('Xóa ảnh'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Image preview
                    if (selectedImage != null || (product?.imagePath != null && product!.imagePath.startsWith('/')))
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: selectedImage != null
                              ? Image.file(
                                  File(selectedImage!.path),
                                  fit: BoxFit.cover,
                                )
                              : product?.imagePath != null
                                  ? product!.imagePath.startsWith('/')
                                      ? Image.file(
                                          File(product!.imagePath),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          product!.imagePath,
                                          fit: BoxFit.cover,
                                        )
                                  : Container(),
                        ),
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
                    final desc = descController.text.trim();

                    if (name.isEmpty || price <= 0 || category.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin hợp lệ')),
                      );
                      return;
                    }

                    // Use selected image path or existing image path
                    final finalImagePath = selectedImage?.path ?? imagePath ?? '';

                    final newProduct = Product(
                      id: idController.text,
                      name: name,
                      description: desc,
                      price: price,
                      imagePath: finalImagePath,
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
      },
    );
  }*/

  
}
