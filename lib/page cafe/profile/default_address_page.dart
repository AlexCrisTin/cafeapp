import 'package:flutter/material.dart';
import 'package:cafeproject/database/data/default_address_service.dart';
import 'package:cafeproject/database/auth/auth_service.dart';

class DefaultAddressPage extends StatefulWidget {
  const DefaultAddressPage({super.key});

  @override
  State<DefaultAddressPage> createState() => _DefaultAddressPageState();
}

class _DefaultAddressPageState extends State<DefaultAddressPage> {
  final AuthService _auth = AuthService.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  bool _isLoading = false;
  bool _hasDefaultAddress = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultAddress() async {
    final userId = _auth.currentUser?.email;
    if (userId != null) {
      final address = await DefaultAddressService.getDefaultAddress(userId);
      if (address != null) {
        setState(() {
          _nameController.text = address['name'] ?? '';
          _phoneController.text = address['phone'] ?? '';
          _addressController.text = address['address'] ?? '';
          _hasDefaultAddress = true;
        });
      }
    }
  }

  Future<void> _saveAddress() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đủ thông tin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = _auth.currentUser?.email;
      if (userId != null) {
        await DefaultAddressService.saveDefaultAddress(
          userId: userId,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );
      }

      setState(() => _hasDefaultAddress = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lưu địa chỉ mặc định thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi lưu địa chỉ')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAddress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa địa chỉ mặc định?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      try {
        final userId = _auth.currentUser?.email;
        if (userId != null) {
          await DefaultAddressService.clearDefaultAddress(userId);
        }
        setState(() {
          _nameController.clear();
          _phoneController.clear();
          _addressController.clear();
          _hasDefaultAddress = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xóa địa chỉ mặc định')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi xóa địa chỉ')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Địa chỉ mặc định'),
        backgroundColor: Color(0xFFDC586D),
        foregroundColor: Colors.white,
        actions: [
          if (_hasDefaultAddress)
            IconButton(
              onPressed: _isLoading ? null : _deleteAddress,
              icon: Icon(Icons.delete),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFDC586D), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin địa chỉ mặc định',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Họ và tên',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Số điện thoại',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Địa chỉ chi tiết',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDC586D),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _hasDefaultAddress ? 'Cập nhật địa chỉ' : 'Lưu địa chỉ mặc định',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
              if (_hasDefaultAddress) ...[
                SizedBox(height: 12),
                Text(
                  'Địa chỉ này sẽ được sử dụng làm mặc định khi đặt hàng',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
