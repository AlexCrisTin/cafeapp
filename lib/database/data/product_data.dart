import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;
  final bool hasSize;
  final Map<String, double>? sizePrices;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    this.hasSize = false,
    this.sizePrices,
  });

  double getPriceForSize(String size) {
    if (!hasSize || sizePrices == null) return price;
    return sizePrices![size] ?? price;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'category': category,
      'hasSize': hasSize,
      'sizePrices': sizePrices,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imagePath: json['imagePath'],
      category: json['category'],
      hasSize: json['hasSize'] ?? false,
      sizePrices: json['sizePrices'] != null 
          ? Map<String, double>.from(json['sizePrices'])
          : null,
    );
  }
}

class ProductData {
  static List<Product> products = [];
  static const String _fileName = 'products_data.json';

  // Helper function để tạo UUID cho sản phẩm mặc định
  static String _generateDefaultId() {
    return const Uuid().v4();
  }

  // Dữ liệu sản phẩm mặc định
  static final List<Product> _defaultProducts = [
    Product(
      id: _generateDefaultId(),
      name: 'Cà phê đen',
      description: 'Cà phê đen truyền thống, đậm đà và thơm ngon. Pha từ hạt cà phê Robusta chất lượng cao.',
      price: 25000,
      imagePath: 'assets/img/Ca-Phe-Den-scaled.jpg',
      category: 'Cafe',
      hasSize: true,
      sizePrices: {'S': 25000, 'M': 30000, 'L': 35000},
    ),
    Product(
      id: _generateDefaultId(),
      name: 'Cà phê sữa',
      description: 'Cà phê sữa ngọt ngào, kết hợp hoàn hảo giữa vị đắng của cà phê và vị ngọt của sữa.',
      price: 30000,
      imagePath: 'assets/img/ca_phe_sua.png',
      category: 'Cafe',
      hasSize: true,
      sizePrices: {'S': 30000, 'M': 35000, 'L': 40000},
    ),
    Product(
      id: _generateDefaultId(),
      name: 'Trà sữa trân châu',
      description: 'Trà sữa thơm ngon với trân châu dai dai, một thức uống yêu thích của giới trẻ.',
      price: 35000,
      imagePath: 'assets/img/Tra_sua.jpg',
      category: 'Trà sữa',
      hasSize: true,
      sizePrices: {'S': 35000, 'M': 40000, 'L': 45000},
    ),
    Product(
      id: _generateDefaultId(),
      name: 'Bánh mì sandwich',
      description: 'Bánh mì sandwich tươi ngon với thịt nguội, rau xanh và sốt mayonnaise.',
      price: 40000,
      imagePath: 'assets/img/banh-mi-thit-sai-gon.jpg',
      category: 'Đồ ăn ngọt',
    ),
    Product(
      id: _generateDefaultId(),
      name: 'Bánh ngọt',
      description: 'Bánh ngọt tươi ngon, được làm từ nguyên liệu cao cấp, thích hợp cho bữa sáng.',
      price: 20000,
      imagePath: 'assets/img/banh-ngot-1.jpeg',
      category: 'Đồ ăn ngọt',
    ),
    Product(
      id: _generateDefaultId(),
      name: 'Xúc xích',
      description: 'Xúc xích tươi ngon, được làm từ nguyên liệu cao cấp, thích hợp cho ăn vặt.',
      price: 20000,
      imagePath: 'assets/img/xuc_xich.jpg',
      category: 'Đồ ăn mặn',
    ),
    Product(
      id: _generateDefaultId(),
      name: 'Matcha',
      description: 'Matcha ngọt ngào, kết hợp hoàn hảo giữa vị đắng của trà và vị ngọt của sữa',
      price: 20000,
      imagePath: 'assets/img/Matcha.jpg',
      category: 'Trà',
      hasSize: true,
      sizePrices: {'S': 20000, 'M': 25000, 'L': 30000},
    ),
  ];

  // Lưu dữ liệu vào file
  static Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      final jsonData = products.map((product) => product.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Lỗi khi lưu sản phẩm: $e');
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
        
        products.clear();
        for (var productJson in jsonData) {
          products.add(Product.fromJson(productJson));
        }
      } else {
        // Nếu file không tồn tại, khởi tạo với dữ liệu mặc định
        products = List<Product>.from(_defaultProducts);
        await _saveToFile();
      }
    } catch (e) {
      print('Lỗi khi đọc sản phẩm: $e');
      // Nếu có lỗi, khởi tạo với dữ liệu mặc định
      products = List<Product>.from(_defaultProducts);
    }
  }

  // Thêm sản phẩm mới
  static Future<void> addProduct(Product product) async {
    products.add(product);
    await _saveToFile();
  }

  // Cập nhật sản phẩm
  static Future<void> updateProduct(Product product) async {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      products[index] = product;
      await _saveToFile();
    }
  }

  // Xóa sản phẩm
  static Future<void> deleteProduct(String productId) async {
    products.removeWhere((p) => p.id == productId);
    await _saveToFile();
  }

  static Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Product> getProductsByCategory(String category) {
    return products.where((product) => product.category == category).toList();
  }

  static List<Product> getAllProducts() {
    return List<Product>.from(products);
  }
}
