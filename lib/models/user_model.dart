import 'package:cms/user_role.dart';
import 'package:cms/admin_status.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class UserModel {
  const UserModel({
    required this.phone,
    required this.name,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere((e) => e.toString() == json['role']),
      status: AdminStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String phone;

  final String name;

  final UserRole role;

  final AdminStatus status;

  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'name': name,
      'role': role.toString(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? phone,
    String? name,
    UserRole? role,
    AdminStatus? status,
    DateTime? createdAt,
  }) {
    return UserModel(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
