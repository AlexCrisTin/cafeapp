import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'vi';
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
                    ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Ngôn ngữ'),
                    subtitle: const Text('Chọn ngôn ngữ hiển thị'),
                    trailing: DropdownButton<String>(
                      value: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value ?? 'vi';
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'vi',
                          child: Text('Tiếng Việt'),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Phiên bản'),
                        subtitle: Text('7.2.7'),
                      ),
        ],
      ),
    );
  }
}