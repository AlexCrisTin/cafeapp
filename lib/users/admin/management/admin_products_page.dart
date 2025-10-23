import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/product_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = ProductData.getAllProducts();
    final query = _searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? allProducts
        : allProducts.where((p) {
            return p.name.toLowerCase().contains(query) ||
                p.category.toLowerCase().contains(query) ||
                p.description.toLowerCase().contains(query);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        backgroundColor: const Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openProductForm(context),
        backgroundColor: const Color(0xFFDC586D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Thêm sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, danh mục, mô tả...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _buildProductsTable(context, filtered),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTable(BuildContext context, List<Product> products) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(flex: 2, child: Text('Tên', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Giá', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(child: Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 80),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(p.name)),
                      Expanded(child: Text(p.price.toStringAsFixed(0))),
                      Expanded(child: Text(p.category)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _openProductForm(context, product: p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await ProductData.deleteProduct(p.id);
                              setState(() {});
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã xóa ${p.name}')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openProductForm(BuildContext context, {Product? product}) async {
    final bool isEdit = product != null;
    final TextEditingController idController = TextEditingController(text: product?.id ?? const Uuid().v4());
    final TextEditingController nameController = TextEditingController(text: product?.name ?? '');
    final TextEditingController priceController = TextEditingController(text: product != null ? product.price.toStringAsFixed(0) : '');
    final TextEditingController categoryController = TextEditingController(text: product?.category ?? '');
    final TextEditingController descController = TextEditingController(text: product?.description ?? '');

    XFile? selectedImage;
    String? imagePath = product?.imagePath;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Giá (VNĐ)'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Danh mục'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chọn ảnh sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _pickImage(context, (image) {
                                setStateDialog(() {
                                  selectedImage = image;
                                  imagePath = image.path;
                                });
                              });
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Chọn ảnh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC586D),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (selectedImage != null || (imagePath != null && imagePath!.startsWith('/')))
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setStateDialog(() {
                                  selectedImage = null;
                                  imagePath = null;
                                });
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Xóa ảnh'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (selectedImage != null || (imagePath != null && imagePath!.startsWith('/')))
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
                              : imagePath != null
                                  ? imagePath!.startsWith('/')
                                      ? Image.file(
                                          File(imagePath!),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          imagePath!,
                                          fit: BoxFit.cover,
                                        )
                                  : Container(),
                        ),
                      ),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Mô tả'),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String name = nameController.text.trim();
                    final double price = double.tryParse(priceController.text.trim()) ?? 0;
                    final String category = categoryController.text.trim();
                    final String desc = descController.text.trim();

                    if (name.isEmpty || price <= 0 || category.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin hợp lệ')),
                      );
                      return;
                    }

                    final String finalImagePath = selectedImage?.path ?? imagePath ?? '';

                    final Product newProduct = Product(
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

                    if (!mounted) return;
                    Navigator.of(ctx).pop();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC586D), foregroundColor: Colors.white),
                  child: Text(isEdit ? 'Lưu' : 'Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, Function(XFile) onImageSelected) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      onImageSelected(image);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Không thể truy cập thư viện ảnh: $e')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh mới'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      onImageSelected(image);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Không thể truy cập camera: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


