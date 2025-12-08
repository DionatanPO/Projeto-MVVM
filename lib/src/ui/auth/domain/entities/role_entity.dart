enum RoleType {
  admin('admin'),
  manager('manager'),
  employee('employee'),
  guest('guest');

  final String value;
  const RoleType(this.value);
}

class RoleEntity {
  final RoleType type;
  final List<String> permissions; // ex: ['read', 'write', 'delete']
  final String description;
  
  const RoleEntity({
    required this.type,
    required this.permissions,
    required this.description,
  });
  
  bool hasPermission(String permission) => permissions.contains(permission);
}