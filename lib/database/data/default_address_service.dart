import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DefaultAddressService {
  static const String _addressKey = 'default_address_';

  // Lưu địa chỉ mặc định cho user cụ thể
  static Future<void> saveDefaultAddress({
    required String userId,
    required String name,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final addressData = {
      'name': name,
      'phone': phone,
      'address': address,
    };
    await prefs.setString('$_addressKey$userId', jsonEncode(addressData));
  }

  // Lấy địa chỉ mặc định của user cụ thể
  static Future<Map<String, String>?> getDefaultAddress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final addressJson = prefs.getString('$_addressKey$userId');
    
    if (addressJson != null) {
      try {
        return Map<String, String>.from(jsonDecode(addressJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Xóa địa chỉ mặc định của user cụ thể
  static Future<void> clearDefaultAddress(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_addressKey$userId');
  }

  // Kiểm tra có địa chỉ mặc định không
  static Future<bool> hasDefaultAddress(String userId) async {
    final address = await getDefaultAddress(userId);
    return address != null;
  }
}
