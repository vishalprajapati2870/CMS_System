import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class SiteModel {
  const SiteModel({
    required this.id,
    required this.siteName,
    required this.createdBy,
    required this.superAdminName,
    required this.createdAt,
  });

  factory SiteModel.fromJson(Map<String, dynamic> json) {
    return SiteModel(
      id: json['id'] as String,
      siteName: json['siteName'] as String,
      createdBy: json['createdBy'] as String,
      superAdminName: json['superAdminName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String siteName;
  final String createdBy;
  final String superAdminName;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteName': siteName,
      'createdBy': createdBy,
      'superAdminName': superAdminName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  SiteModel copyWith({
    String? id,
    String? siteName,
    String? createdBy,
    String? superAdminName,
    DateTime? createdAt,
  }) {
    return SiteModel(
      id: id ?? this.id,
      siteName: siteName ?? this.siteName,
      createdBy: createdBy ?? this.createdBy,
      superAdminName: superAdminName ?? this.superAdminName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}