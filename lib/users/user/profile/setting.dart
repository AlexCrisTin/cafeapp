import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
                      leading: Icon(Icons.dark_mode, color: Color(0xFFDC586D)),
                      title: Text('Dark mode'),
                      subtitle: Text('Chuyển đổi chế độ tối'),
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = !_notificationsEnabled;
                          });
                        },
                        activeColor: Color(0xFFDC586D),
                      ),
                    ),
        ],
      ),
    );
  }
}