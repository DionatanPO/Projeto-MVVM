import '../../domain/entities/role_entity.dart';

class RoleModel {
  final RoleType type;
  final List<String> permissions;
  final String description;

  const RoleModel({
    required this.type,
    required this.permissions,
    required this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      type: _stringToRoleType(json['type'] as String? ?? 'employee'),
      permissions: List<String>.from(json['permissions'] ?? []),
      description: json['description'] ?? 'Role sem descrição',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'permissions': permissions,
      'description': description,
    };
  }

  RoleEntity toEntity() {
    return RoleEntity(
      type: type,
      permissions: permissions,
      description: description,
    );
  }

  factory RoleModel.fromEntity(RoleEntity entity) {
    return RoleModel(
      type: entity.type,
      permissions: entity.permissions,
      description: entity.description,
    );
  }

  static RoleType _stringToRoleType(String value) {
    switch (value) {
      case 'admin':
        return RoleType.admin;
      case 'manager':
        return RoleType.manager;
      case 'employee':
        return RoleType.employee;
      case 'guest':
        return RoleType.guest;
      default:
        return RoleType.employee;
    }
  }
}