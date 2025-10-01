import 'package:flutter/material.dart';
import 'package:cafeproject/data/auth/auth_service.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final AuthService _auth = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    final users = _auth.getAllUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        backgroundColor: const Color(0xFFDC586D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(flex: 2, child: Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Vai trò', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 120),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final u = users[index];
                  final username = u['username'] as String;
                  final role = u['role'] as UserRole;
                  final isAdmin = username == 'admin';

                  return Row(
                    children: [
                      Expanded(flex: 2, child: Text(username)),
                      Expanded(child: Text(role.name)),
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'Đặt lại mật khẩu',
                            icon: const Icon(Icons.password, color: Colors.orange),
                            onPressed: isAdmin ? null : () => _onResetPassword(username),
                          ),
                          IconButton(
                            tooltip: 'Đổi vai trò',
                            icon: const Icon(Icons.switch_account, color: Colors.blue),
                            onPressed: isAdmin ? null : () => _onChangeRole(username, role),
                          ),
                          IconButton(
                            tooltip: 'Xóa người dùng',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: isAdmin ? null : () => _onDeleteUser(username),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onResetPassword(String username) async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đặt lại mật khẩu'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
          obscureText: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC586D), foregroundColor: Colors.white),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final pw = controller.text.trim();
      if (pw.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu không được rỗng')));
        return;
      }
      final success = _auth.resetPassword(username, pw);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? 'Đặt lại mật khẩu thành công' : 'Thất bại')));
      setState(() {});
    }
  }

  Future<void> _onChangeRole(String username, UserRole current) async {
    final roles = UserRole.values.where((r) => r != UserRole.guest).toList();
    UserRole selected = current;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đổi vai trò'),
        content: StatefulBuilder(
          builder: (ctx, setStateDialog) => DropdownButton<UserRole>(
            value: selected,
            items: roles
                .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                .toList(),
            onChanged: (v) => setStateDialog(() => selected = v ?? current),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC586D), foregroundColor: Colors.white),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final success = _auth.setUserRole(username, selected);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? 'Đổi vai trò thành công' : 'Thất bại')));
      setState(() {});
    }
  }

  Future<void> _onDeleteUser(String username) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa người dùng'),
        content: Text('Bạn có chắc muốn xóa "$username"? Hành động không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final success = _auth.deleteUser(username);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? 'Đã xóa' : 'Thất bại')));
      setState(() {});
    }
  }
}
