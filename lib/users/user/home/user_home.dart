import 'package:flutter/material.dart';
import 'package:cafeproject/page%20cafe/home/page_cafe.dart';
import 'package:cafeproject/page%20cafe/home/item.dart';
import 'package:cafeproject/page%20cafe/home/mostbuy.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/database/auth/login_required.dart';
import 'package:cafeproject/page%20cafe/home/voucher.dart';
import 'package:cafeproject/users/user/notifications/user_notifications.dart';
import 'package:cafeproject/database/data/notification_data.dart';
class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
  }

  Future<void> _loadNotificationCount() async {
    await NotificationData.loadFromFile();
    final AuthService _auth = AuthService.instance;
    final currentUserId = _auth.currentUser?.email ?? 'guest';
    setState(() {
      unreadCount = NotificationData.getUnreadCount(currentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService.instance;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFDC586D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20), 
                bottomRight: Radius.circular(20)
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.only(left: 10, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.person_2_outlined, size: 30, color: Colors.white),
                      title: Text(
                        'Chào mừng ${_auth.currentUser?.email ?? "User"}', 
                        style: TextStyle(color: Colors.white)
                      ),
                      subtitle: Text(
                        'Welcome to Cafe', 
                        style: TextStyle(color: Colors.white)
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_auth.isGuest || !_auth.isLoggedIn) {
                        final ok = await ensureLoggedIn(context);
                        if (!ok) return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const UserNotificationsPage()),
                      ).then((_) => _loadNotificationCount());
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          child: Icon(Icons.notifications, color: Colors.white, size: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFFB959F)
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                unreadCount > 99 ? '99+' : unreadCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          PageCafe(),
          Item(),
          Mostbuy(),
          Voucher()
        ],
      ),
    );
  }
}
