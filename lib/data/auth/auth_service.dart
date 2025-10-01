// No Flutter imports needed here
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
  bool registerUser(String email, String password) {
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
    
    // Persist to file (fire and forget)
    _saveToFile();
    return true;
  }

  // Admin ops
  bool deleteUser(String username) {
    final key = username.trim().toLowerCase();
    if (!_users.containsKey(key)) return false;
    if (key == 'admin') return false; // protect default admin
    _users.remove(key);
    _saveToFile();
    return true;
  }

  bool setUserRole(String username, UserRole role) {
    final key = username.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    user['role'] = role;
    _saveToFile();
    return true;
  }

  bool resetPassword(String username, String newPassword) {
    final key = username.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    user['password'] = newPassword;
    _saveToFile();
    return true;
  }

  // Persist users to file
  Future<void> _saveToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_fileName');
      await file.writeAsString(jsonEncode(_users));
    } catch (e) {
      // ignore persistence errors in demo
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
        _users = data.map((k, v) => MapEntry<String, Map<String, dynamic>>(k, Map<String, dynamic>.from(v)));
      } else {
        // seed default admin and save
        await _saveToFile();
      }
    } catch (e) {
      // keep defaults on error
    }
  }
}


