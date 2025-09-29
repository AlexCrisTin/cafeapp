import 'package:flutter/material.dart';
import 'package:cafeproject/users/user/home/user_home.dart';
import 'package:cafeproject/users/user/profile/user_profile.dart';
import 'package:cafeproject/users/user/bottom_navigation/user_bottom_nav.dart';
import 'package:cafeproject/page/menu/menu_head.dart';
import 'package:cafeproject/page/search/search_page.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/database/auth/login_required.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int _currentIndex = 0;
  late PageController _pageController;
  final AuthService _auth = AuthService.instance;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UserBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) async {
          // Block profile tab (index 3) if guest
          if ((_auth.isGuest || !_auth.isLoggedIn) && index == 3) {
            final ok = await ensureLoggedIn(context);
            if (!ok) return;
          }
          _onTabTapped(index);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          UserHome(),
          SingleChildScrollView(child: MenuHead()),
          SearchPage(),
          UserProfile(),
        ],
      ),
    );
  }
}
