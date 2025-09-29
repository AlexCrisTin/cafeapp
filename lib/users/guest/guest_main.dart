import 'package:flutter/material.dart';
import 'package:cafeproject/users/guest/browse/guest_browse.dart';
import 'package:cafeproject/users/guest/cart/guest_cart.dart';
import 'package:cafeproject/page/menu/menu_head.dart';
import 'package:cafeproject/page/search/search_page.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/login/begin.dart';

class GuestMain extends StatefulWidget {
  const GuestMain({super.key});

  @override
  State<GuestMain> createState() => _GuestMainState();
}

class _GuestMainState extends State<GuestMain> {
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Color(0xFFDC586D),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          GuestBrowse(),
          SingleChildScrollView(child: MenuHead()),
          SearchPage(),
          GuestCart(),
        ],
      ),
    );
  }
}
