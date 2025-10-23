import 'package:flutter/material.dart';
import 'package:cafeproject/database/auth/auth_service.dart';
import 'package:cafeproject/database/data/user_profile_service.dart';
import 'package:cafeproject/page cafe/profile/default_address_page.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final AuthService _auth = AuthService.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _notificationsEnabled = true;
  String _selectedGender = 'Nam';
  DateTime? _selectedBirthday;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    _emailController.text = _auth.currentUser?.email ?? '';
    _nameController.text = 'Người dùng';
    _phoneController.text = '0123456789';
    
    // Load user profile data
    final userId = _auth.currentUser?.email;
    if (userId != null) {
      final profile = await UserProfileService.getUserProfile(userId);
      if (profile != null) {
        setState(() {
          _nameController.text = profile['name'] ?? 'Người dùng';
          _phoneController.text = profile['phone'] ?? '0123456789';
          _selectedGender = profile['gender'] ?? 'Nam';
          _selectedBirthday = profile['birthday'];
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final userId = _auth.currentUser?.email;
        if (userId != null) {
          await UserProfileService.saveUserProfile(
            userId: userId,
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            gender: _selectedGender,
            birthday: _selectedBirthday,
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thông tin đã được cập nhật'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra khi lưu thông tin'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now().subtract(Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFDC586D),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Lưu',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFDC586D),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tính năng sẽ được phát triển sớm')),
                        );
                      },
                      child: Text('Thay đổi ảnh đại diện'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Form Fields
              Text(
                'Thông tin cơ bản',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  hintText: 'Nhập họ và tên',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Nhập email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                readOnly: true, // Email cannot be changed
                style: TextStyle(color: Colors.grey[600]),
              ),

              SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  hintText: 'Nhập số điện thoại',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (value.length < 10) {
                    return 'Số điện thoại phải có ít nhất 10 số';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15),

              // Dropdown giới tính
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Giới tính',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: ['Nam', 'Nữ', 'Khác'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  }
                },
              ),

              SizedBox(height: 15),

              // Ngày sinh
              InkWell(
                onTap: _selectBirthday,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Text(
                    _selectedBirthday != null
                        ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                        : 'Chọn ngày sinh',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedBirthday != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Additional Settings
              Text(
                'Cài đặt khác',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 15),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notifications, color: Color(0xFFDC586D)),
                      title: Text('Thông báo'),
                      subtitle: Text('Nhận thông báo về đơn hàng'),
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: Color(0xFFDC586D),
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Color(0xFFDC586D)),
                      title: Text('Địa chỉ mặc định'),
                      subtitle: Text('Thiết lập địa chỉ giao hàng'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DefaultAddressPage(),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.security, color: Color(0xFFDC586D)),
                      title: Text('Bảo mật'),
                      subtitle: Text('Đổi mật khẩu'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tính năng sẽ được phát triển sớm')),
                        );
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
