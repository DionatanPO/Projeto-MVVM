import 'role_entity.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String? avatar;
  final RoleEntity role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerified = false,
    this.avatar,
    required this.role,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    bool? emailVerified,
    String? avatar,
    RoleEntity? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
    );
  }
}