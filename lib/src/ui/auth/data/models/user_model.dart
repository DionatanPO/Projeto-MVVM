import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';
import 'role_model.dart';
import '../../domain/entities/role_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String? avatar;
  final RoleModel role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerified = false,
    this.avatar,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerified: json['email_verified'] ?? false,
      avatar: json['avatar'],
      role: json['role'] != null
        ? RoleModel.fromJson(json['role'])
        : const RoleModel(
            type: RoleType.employee,
            permissions: ['read'],
            description: 'Usuário padrão',
          ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified': emailVerified,
      'avatar': avatar,
      'role': role.toJson(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      emailVerified: emailVerified,
      avatar: avatar,
      role: role.toEntity(),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      emailVerified: entity.emailVerified,
      avatar: entity.avatar,
      role: RoleModel.fromEntity(entity.role),
    );
  }

  @override
  List<Object?> get props => [id, name, email, emailVerified, avatar, role];
}