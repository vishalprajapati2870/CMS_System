import 'package:flutter/material.dart';
import 'package:cms/models/user_model.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:cms/user_role.dart';
import 'package:cms/admin_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class AuthService extends ChangeNotifier {
  AuthService() {
    _initializeHardcodedUsers();
    _loadSession();
  }

  factory AuthService.of(BuildContext context) {
    return Provider.of<AuthService>(context, listen: false);
  }

  List<UserModel> _users = [];

  UserModel? _currentUser;

  List<UserModel> get users {
    return _users;
  }

  UserModel? get currentUser {
    return _currentUser;
  }

  bool get isLoggedIn {
    return _currentUser != null;
  }

  List<UserModel> get approvedAdmins {
    return _users
        .where(
          (u) => u.role == UserRole.admin && u.status == AdminStatus.approved,
        )
        .toList();
  }

  List<UserModel> get pendingAdmins {
    return _users
        .where(
          (u) => u.role == UserRole.admin && u.status == AdminStatus.pending,
        )
        .toList();
  }

  List<UserModel> get rejectedAdmins {
    return _users
        .where(
          (u) => u.role == UserRole.admin && u.status == AdminStatus.rejected,
        )
        .toList();
  }

  List<UserModel> get allAdmins {
    return _users.where((u) => u.role == UserRole.admin).toList();
  }

  void _initializeHardcodedUsers() {
    _users = [
      UserModel(
        phone: '8128262414',
        name: 'Naresh',
        role: UserRole.superAdmin,
        status: AdminStatus.approved,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      UserModel(
        phone: '8128262415',
        name: 'Hashmukh',
        role: UserRole.admin,
        status: AdminStatus.approved,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      UserModel(
        phone: '8128261416',
        name: 'Jash',
        role: UserRole.admin,
        status: AdminStatus.rejected,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('current_user_phone');
    if (phone != null) {
      try {
        _currentUser = _users.firstWhere((user) => user.phone == phone);
        notifyListeners();
      } catch (e) {
        await logout();
      }
    }
  }

  Future<void> _saveSession(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_phone', phone);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_phone');
    _currentUser = null;
    notifyListeners();
  }

  UserModel? findUserByPhone(String phone) {
    try {
      return _users.firstWhere((user) => user.phone == phone);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> login(String phone) async {
    final user = findUserByPhone(phone);
    if (user == null) {
      return {
        'success': false,
        'action': 'register',
        'message': 'User not found',
      };
    }
    if (user?.role == UserRole.superAdmin) {
      _currentUser = user;
      await _saveSession(phone);
      notifyListeners();
      return {'success': true, 'action': 'super_admin_dashboard', 'user': user};
    }
    if (user?.status == AdminStatus.approved) {
      _currentUser = user;
      await _saveSession(phone);
      notifyListeners();
      return {'success': true, 'action': 'admin_dashboard', 'user': user};
    }
    if (user?.status == AdminStatus.rejected) {
      _currentUser = user;
      await _saveSession(phone);
      notifyListeners();
      return {
        'success': false,
        'action': 'rejected',
        'message': 'Your access request has been rejected by Super Admin.',
        'user': user,
      };
    }
    return {
      'success': false,
      'action': 'pending',
      'message': 'Your request is pending approval from Super Admin.',
    };
  }

  Future<bool> registerAdmin(String phone, String name) async {
    final existingUser = findUserByPhone(phone);
    if (existingUser != null) {
      return false;
    }
    final newAdmin = UserModel(
      phone: phone,
      name: name,
      role: UserRole.admin,
      status: AdminStatus.pending,
      createdAt: DateTime.now(),
    );
    _users.add(newAdmin);
    notifyListeners();
    return true;
  }

  void approveAdmin(String phone) {
    final index = _users.indexWhere((user) => user.phone == phone);
    if (index != -1) {
      _users[index] = _users[index].copyWith(status: AdminStatus.approved);
      notifyListeners();
    }
  }

  void rejectAdmin(String phone) {
    final index = _users.indexWhere((user) => user.phone == phone);
    if (index != -1) {
      _users[index] = _users[index].copyWith(status: AdminStatus.rejected);
      notifyListeners();
    }
  }

  Future<void> removeAdmin(String phone) async {
    _users.removeWhere((user) => user.phone == phone);
    if (_currentUser?.phone == phone) {
      await logout();
    }
    notifyListeners();
  }
}
