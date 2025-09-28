// No Flutter imports needed here

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

  // Demo users. In real app, replace with backend auth.
  final Map<String, Map<String, dynamic>> _users = {
    // email: { password, role }
    'admin@cafe.app': { 'password': 'admin123', 'role': UserRole.admin },
  };

  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest || _currentUser?.role == UserRole.guest;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  bool get isUser => _currentUser?.role == UserRole.user;
  AuthUser? get currentUser => _currentUser;

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
    
    return true;
  }
}


