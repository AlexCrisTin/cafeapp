// No Flutter imports needed here
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cafeproject/database/data/orders_service.dart';
import 'package:cafeproject/database/data/cart_service.dart';
import 'package:cafeproject/database/data/user_profile_service.dart';
import 'package:cafeproject/database/data/default_address_service.dart';
import 'package:cafeproject/database/data/notification_data.dart';

enum UserRole { user, admin, guest }

class AuthUser {
  final String email;
  final UserRole role;
  const AuthUser({required this.email, required this.role});
}

class AuthService {
  AuthService._internal();

  static final AuthService instance = AuthService._internal();

  bool _isLoggedIn = false;
  bool _isGuest = false;
  AuthUser? _currentUser;
  static const String _fileName = 'users_data.json';

  // In-memory users store. Persisted to file.
  Map<String, Map<String, dynamic>> _users = {
    // username/email: { password, role }
    'admin': { 'password': 'admin', 'role': UserRole.admin },
  };

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest || _currentUser?.role == UserRole.guest;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isUser => _currentUser?.role == UserRole.user;
  AuthUser? get currentUser => _currentUser;
  int get totalUsers => _users.length;
  List<Map<String, dynamic>> getAllUsers() {
    return _users.entries.map((e) => {
      'username': e.key,
      'role': e.value['role'] as UserRole,
    }).toList();
  }

  // Debug method để kiểm tra users
  void debugUsers() {
    print('📊 Total users: ${_users.length}');
    print('📋 Users list: ${_users.keys.toList()}');
    for (var entry in _users.entries) {
      print('👤 ${entry.key}: ${entry.value}');
    }
  }

  bool loginWithCredentials(String email, String password) {
    final entry = _users[email.trim().toLowerCase()];
    if (entry == null) {
      return false;
    }
    if (entry['password'] != password) {
      return false;
    }
    _currentUser = AuthUser(email: email.trim().toLowerCase(), role: entry['role'] as UserRole);
    _isLoggedIn = true;
    _isGuest = false;
    return true;
  }

  void continueAsGuest() {
    _isLoggedIn = false;
    _isGuest = true;
    _currentUser = null;
  }

  void logout() {
    _isLoggedIn = false;
    _isGuest = false;
    _currentUser = null;
  }

  // Register new user
  Future<bool> registerUser(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    
    // Check if user already exists
    if (_users.containsKey(cleanEmail)) {
      return false;
    }
    
    // Add new user
    _users[cleanEmail] = {
      'password': password,
      'role': UserRole.user,
    };
    
    // Persist to file
    await _saveToFile();
    return true;
  }

  // Admin ops
  Future<bool> deleteUser(String username) async {
    final key = username.trim().toLowerCase();
    if (!_users.containsKey(key)) return false;
    if (key == 'admin') return false; // protect default admin
    
    try {
      // Xóa toàn bộ dữ liệu liên quan đến user
      await _deleteUserRelatedData(key);
      
      // Xóa user khỏi hệ thống
      _users.remove(key);
      await _saveToFile();
      
      return true;
    } catch (e) {
      print('Lỗi khi xóa user $key: $e');
      return false;
    }
  }

  // Xóa toàn bộ dữ liệu liên quan đến user
  Future<void> _deleteUserRelatedData(String userId) async {
    // 1. Xóa đơn hàng của user
    await _deleteUserOrders(userId);
    
    // 2. Xóa giỏ hàng của user
    await _deleteUserCart(userId);
    
    // 3. Xóa thông tin profile
    await UserProfileService.clearUserProfile(userId);
    
    // 4. Xóa địa chỉ mặc định
    await DefaultAddressService.clearDefaultAddress(userId);
    
    // 5. Xóa thông báo của user
    await _deleteUserNotifications(userId);
  }

  // Xóa đơn hàng của user
  Future<void> _deleteUserOrders(String userId) async {
    try {
      // Sử dụng OrdersService để lấy và xóa đơn hàng
      final userOrders = OrdersService.getOrdersByUser(userId);
      
      for (final order in userOrders) {
        await OrdersService.deleteOrder(order.id);
      }
    } catch (e) {
      print('Lỗi khi xóa đơn hàng của user $userId: $e');
    }
  }

  // Xóa giỏ hàng của user
  Future<void> _deleteUserCart(String userId) async {
    try {
      // Sử dụng phương thức mới trong CartService
      await CartService.clearUserCart(userId);
    } catch (e) {
      print('Lỗi khi xóa giỏ hàng của user $userId: $e');
    }
  }

  // Xóa thông báo của user
  Future<void> _deleteUserNotifications(String userId) async {
    try {
      // Sử dụng phương thức mới trong NotificationData
      await NotificationData.deleteUserNotifications(userId);
    } catch (e) {
      print('Lỗi khi xóa thông báo của user $userId: $e');
    }
  }

  Future<bool> setUserRole(String username, UserRole role) async {
    final key = username.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    user['role'] = role;
    await _saveToFile();
    return true;
  }

  Future<bool> resetPassword(String username, String newPassword) async {
    final key = username.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    user['password'] = newPassword;
    await _saveToFile();
    return true;
  }

  // Persist users to file
  Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      
      // Convert UserRole enum to string for JSON serialization
      final Map<String, dynamic> serializableUsers = {};
      for (var entry in _users.entries) {
        serializableUsers[entry.key] = {
          'password': entry.value['password'],
          'role': entry.value['role'].toString().split('.').last, // Convert enum to string
        };
      }
      
      final jsonString = jsonEncode(serializableUsers);
      await file.writeAsString(jsonString);
 
    } catch (e) {

    }
  }

  // Load users from file; if not exists, seed defaults
  Future<void> loadFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonString);
        
        // Clear current users and load from file
        _users.clear();
        
        // Convert string role back to UserRole enum
        for (var entry in data.entries) {
          final roleString = entry.value['role'] as String;
          UserRole role;
          switch (roleString) {
            case 'admin':
              role = UserRole.admin;
              break;
            case 'user':
              role = UserRole.user;
              break;
            case 'guest':
              role = UserRole.guest;
              break;
            default:
              role = UserRole.user; // default fallback
          }
          
          _users[entry.key] = {
            'password': entry.value['password'],
            'role': role,
          };
        }
        

      } else {
        // seed default admin and save
        await _saveToFile();
      }
    } catch (e) {
      // keep defaults on error
    }
  }
}


