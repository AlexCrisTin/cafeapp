class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

class ProductData {
  static List<Product> products = [
    Product(
      id: '1',
      name: 'Cà phê đen',
      description: 'Cà phê đen truyền thống, đậm đà và thơm ngon. Pha từ hạt cà phê Robusta chất lượng cao.',
      price: 25000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Cafe',
    ),
    Product(
      id: '2',
      name: 'Cà phê sữa',
      description: 'Cà phê sữa ngọt ngào, kết hợp hoàn hảo giữa vị đắng của cà phê và vị ngọt của sữa.',
      price: 30000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Cafe',
    ),
    Product(
      id: '3',
      name: 'Trà sữa trân châu',
      description: 'Trà sữa thơm ngon với trân châu dai dai, một thức uống yêu thích của giới trẻ.',
      price: 35000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Trà sữa',
    ),
    Product(
      id: '4',
      name: 'Bánh mì sandwich',
      description: 'Bánh mì sandwich tươi ngon với thịt nguội, rau xanh và sốt mayonnaise.',
      price: 40000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Đồ ăn ngọt',
    ),
    Product(
      id: '5',
      name: 'Bánh ngọt',
      description: 'Bánh ngọt tươi ngon, được làm từ nguyên liệu cao cấp, thích hợp cho bữa sáng.',
      price: 20000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Đồ ăn ngọt',
    ),
    Product(
      id: '6',
      name: 'Xúc xích',
      description: 'Bánh ngọt tươi ngon, được làm từ nguyên liệu cao cấp, thích hợp cho bữa sáng.',
      price: 20000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Đồ ăn mặn',
    ),
    Product(
      id: '7',
      name: 'Matcha',
      description: 'Bánh ngọt tươi ngon, được làm từ nguyên liệu cao cấp, thích hợp cho bữa sáng.',
      price: 20000,
      imagePath: 'assets/img/coffee1.png',
      category: 'Matcha',
    ),
  ];

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
