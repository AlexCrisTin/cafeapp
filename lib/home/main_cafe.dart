import 'package:flutter/material.dart';
import 'package:cafeproject/home/page_cafe.dart';
import 'package:cafeproject/home/item.dart';
import 'package:cafeproject/home/bottom_page.dart';
import 'package:cafeproject/menu/menu_head.dart';
import 'package:cafeproject/search/search_page.dart';
import 'package:cafeproject/profile/profile_page.dart';
import 'package:cafeproject/home/message_page.dart';

class MainCafe extends StatefulWidget {
  const MainCafe({super.key});

  @override
  State<MainCafe> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainCafe> {
  int _currentIndex = 0;
  late PageController _pageController;

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
      bottomNavigationBar: BottomPage(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          // Tab 0: Home
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFDC586D),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.account_box_rounded),
                          title: Text('Chào mừng bạn đến với Cafe', style: TextStyle(color: Colors.white),),
                          subtitle: Text('Welcome to Cafe', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MessagePage()),
                          );
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.message, color: Colors.white, size: 20,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFFB959F)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              PageCafe(),
              Item()
            ],
          ),
          // Tab 1: Menu
          MenuHead(),
          // Tab 2: Search
          SearchPage(),
          // Tab 3: Profile
          ProfilePage(),
        ],
      ),
    );
  }
}