import 'package:flutter/material.dart';
import 'package:cafeproject/data/auth/auth_service.dart';
import 'package:cafeproject/users/user/user_main.dart';
import 'package:cafeproject/users/admin/admin_main.dart';
import 'package:cafeproject/users/guest/guest_main.dart';
import 'package:cafeproject/login/begin.dart';

class NavigationHelper {
  static Widget getHomePage() {
    final AuthService auth = AuthService.instance;
    
    // Nếu chưa đăng nhập, hiển thị trang Begin
    if (!auth.isLoggedIn && !auth.isGuest) {
      return Begin();
    }
    
    // Nếu đã đăng nhập, điều hướng theo role
    if (auth.isLoggedIn && auth.currentUser != null) {
      switch (auth.currentUser!.role) {
        case UserRole.admin:
          return AdminMain();
        case UserRole.user:
          return UserMain();
        case UserRole.guest:
          return GuestMain();
      }
    }
    
    // Nếu là guest, hiển thị GuestMain
    if (auth.isGuest) {
      return GuestMain();
    }
    
    // Fallback về Begin
    return Begin();
  }

  static void navigateAfterLogin(BuildContext context) {
    final AuthService auth = AuthService.instance;
    
    if (auth.isLoggedIn && auth.currentUser != null) {
      Widget targetPage;
      switch (auth.currentUser!.role) {
        case UserRole.admin:
          targetPage = AdminMain();
          break;
        case UserRole.user:
          targetPage = UserMain();
          break;
        case UserRole.guest:
          targetPage = GuestMain();
          break;
      }
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => targetPage)
      );
    } else if (auth.isGuest) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => GuestMain())
      );
    } else {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => Begin())
      );
    }
  }
}
