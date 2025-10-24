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
                            onPressed: () => _showDeleteConfirmation(context, p),
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
    
    // Biến cho loại sản phẩm và size
    String productType = 'food'; // 'food' hoặc 'drink'
    Map<String, double> sizePrices = {};
    final TextEditingController sPriceController = TextEditingController();
    final TextEditingController mPriceController = TextEditingController();
    final TextEditingController lPriceController = TextEditingController();
    
    // Khởi tạo giá trị từ product hiện tại
    if (product != null && product.hasSize) {
      productType = 'drink';
      sizePrices = product.sizePrices ?? {};
      sPriceController.text = sizePrices['S']?.toStringAsFixed(0) ?? '';
      mPriceController.text = sizePrices['M']?.toStringAsFixed(0) ?? '';
      lPriceController.text = sizePrices['L']?.toStringAsFixed(0) ?? '';
    }

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
                      decoration: InputDecoration(
                        labelText: 'Tên sản phẩm',
                        helperText: 'Tên sản phẩm phải duy nhất',
                        helperStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      onChanged: (value) {
                        // Real-time validation
                        final trimmedName = value.trim();
                        if (trimmedName.isNotEmpty) {
                          final existingProducts = ProductData.getAllProducts();
                          final isDuplicate = existingProducts.any((p) => 
                            p.name.toLowerCase() == trimmedName.toLowerCase() && 
                            p.id != idController.text
                          );
                          
                          if (isDuplicate) {
                            setStateDialog(() {
                              // Có thể thêm visual indicator ở đây nếu cần
                            });
                          }
                        }
                      },
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
                    
                    // Chọn loại sản phẩm
                    const Text(
                      'Loại sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Đồ ăn'),
                            value: 'food',
                            groupValue: productType,
                            onChanged: (String? value) {
                              setStateDialog(() {
                                productType = value!;
                                // Xóa size prices khi chọn đồ ăn
                                sizePrices.clear();
                                sPriceController.clear();
                                mPriceController.clear();
                                lPriceController.clear();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Đồ uống'),
                            value: 'drink',
                            groupValue: productType,
                            onChanged: (String? value) {
                              setStateDialog(() {
                                productType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    // Nhập size cho đồ uống
                    if (productType == 'drink') ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Giá theo size (VNĐ)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: sPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Size S',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                if (price != null) {
                                  sizePrices['S'] = price;
                                } else {
                                  sizePrices.remove('S');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: mPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Size M',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                if (price != null) {
                                  sizePrices['M'] = price;
                                } else {
                                  sizePrices.remove('M');
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: lPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Size L',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final price = double.tryParse(value);
                                if (price != null) {
                                  sizePrices['L'] = price;
                                } else {
                                  sizePrices.remove('L');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    
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
                    
                    // Kiểm tra tên sản phẩm trùng lặp
                    final existingProducts = ProductData.getAllProducts();
                    final duplicateProduct = existingProducts.firstWhere(
                      (p) => p.name.toLowerCase() == name.toLowerCase() && p.id != idController.text,
                      orElse: () => Product(
                        id: '',
                        name: '',
                        description: '',
                        price: 0,
                        imagePath: '',
                        category: '',
                      ),
                    );
                    
                    if (duplicateProduct.id.isNotEmpty) {
                      // Tìm sản phẩm tương tự để gợi ý
                      final similarProducts = existingProducts.where((p) => 
                        p.name.toLowerCase().contains(name.toLowerCase()) || 
                        name.toLowerCase().contains(p.name.toLowerCase())
                      ).take(3).toList();
                      
                      String suggestionText = 'Tên sản phẩm "$name" đã tồn tại.';
                      if (similarProducts.isNotEmpty) {
                        suggestionText += '\n\nSản phẩm tương tự:';
                        for (var similar in similarProducts) {
                          suggestionText += '\n• ${similar.name} (${similar.category})';
                        }
                        suggestionText += '\n\nVui lòng chọn tên khác.';
                      } else {
                        suggestionText += ' Vui lòng chọn tên khác.';
                      }
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(suggestionText),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'Đóng',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                      return;
                    }
                    
                    // Validation cho đồ uống
                    if (productType == 'drink' && sizePrices.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập ít nhất một size cho đồ uống')),
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
                      hasSize: productType == 'drink',
                      sizePrices: productType == 'drink' && sizePrices.isNotEmpty ? sizePrices : null,
                    );

                    if (isEdit) {
                      await ProductData.updateProduct(newProduct);
                    } else {
                      await ProductData.addProduct(newProduct);
                    }

                    if (!mounted) return;
                    Navigator.of(ctx).pop();
                    
                    // Force refresh UI
                    setState(() {});
                    
                    // Hiển thị thông báo thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Đã cập nhật sản phẩm "$name"' : 'Đã thêm sản phẩm "$name"'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Đóng',
                          textColor: Colors.white,
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
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

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa sản phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
              const SizedBox(height: 8),
              Text(
                'Tên: ${product.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Danh mục: ${product.category}'),
              Text('Giá: ${product.price.toStringAsFixed(0)} đ'),
              const SizedBox(height: 8),
              const Text(
                'Hành động này không thể hoàn tác!',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(context, product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(BuildContext context, Product product) async {
    try {
      await ProductData.deleteProduct(product.id);
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa sản phẩm "${product.name}"'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa sản phẩm: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


