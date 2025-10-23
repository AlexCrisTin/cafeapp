import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfileService {
  static const String _profileKey = 'user_profile_';

  // Lưu thông tin profile của user
  static Future<void> saveUserProfile({
    required String userId,
    required String name,
    required String phone,
    required String gender,
    required DateTime? birthday,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = {
      'name': name,
      'phone': phone,
      'gender': gender,
      'birthday': birthday?.millisecondsSinceEpoch,
    };
    await prefs.setString('$_profileKey$userId', jsonEncode(profileData));
  }

  // Lấy thông tin profile của user
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('$_profileKey$userId');
    
    if (profileJson != null) {
      try {
        final data = jsonDecode(profileJson);
        // Convert birthday back to DateTime if it exists
        if (data['birthday'] != null) {
          data['birthday'] = DateTime.fromMillisecondsSinceEpoch(data['birthday']);
        }
        return data;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Xóa thông tin profile của user
  static Future<void> clearUserProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_profileKey$userId');
  }

  // Kiểm tra có thông tin profile không
  static Future<bool> hasUserProfile(String userId) async {
    final profile = await getUserProfile(userId);
    return profile != null;
  }

  // Cập nhật một trường cụ thể
  static Future<void> updateProfileField({
    required String userId,
    required String field,
    required dynamic value,
  }) async {
    final currentProfile = await getUserProfile(userId);
    if (currentProfile != null) {
      currentProfile[field] = value;
      await saveUserProfile(
        userId: userId,
        name: currentProfile['name'] ?? '',
        phone: currentProfile['phone'] ?? '',
        gender: currentProfile['gender'] ?? 'Nam',
        birthday: currentProfile['birthday'],
      );
    }
  }
}
