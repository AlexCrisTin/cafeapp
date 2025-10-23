import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DefaultAddressService {
  static const String _addressKey = 'default_address';

  // Lưu địa chỉ mặc định
  static Future<void> saveDefaultAddress({
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
    await prefs.setString(_addressKey, jsonEncode(addressData));
  }

  // Lấy địa chỉ mặc định
  static Future<Map<String, String>?> getDefaultAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final addressJson = prefs.getString(_addressKey);
    
    if (addressJson != null) {
      try {
        return Map<String, String>.from(jsonDecode(addressJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Xóa địa chỉ mặc định
  static Future<void> clearDefaultAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_addressKey);
  }

  // Kiểm tra có địa chỉ mặc định không
  static Future<bool> hasDefaultAddress() async {
    final address = await getDefaultAddress();
    return address != null;
  }
}
