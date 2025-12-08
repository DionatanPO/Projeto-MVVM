import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/role_entity.dart';

// Definir regras de acesso
final rolePermissionsProvider = Provider<Map<RoleType, List<String>>>((ref) {
  return {
    RoleType.admin: ['read', 'write', 'delete', 'manage_users', 'manage_system'],
    RoleType.manager: ['read', 'write', 'manage_team', 'view_reports'],
    RoleType.employee: ['read', 'write'],
    RoleType.guest: ['read'],
  };
});

final currentUserRoleProvider = StateProvider<RoleEntity?>((ref) {
  // Será atualizado quando o usuário fizer login
  return null;
});

final canAccessAdminAreaProvider = Provider<bool>((ref) {
  final currentUserRole = ref.watch(currentUserRoleProvider);
  return currentUserRole?.type == RoleType.admin;
});

final canAccessManagerAreaProvider = Provider<bool>((ref) {
  final currentUserRole = ref.watch(currentUserRoleProvider);
  return currentUserRole?.type == RoleType.admin || 
         currentUserRole?.type == RoleType.manager;
});

final hasWritePermissionProvider = Provider<bool>((ref) {
  final currentUserRole = ref.watch(currentUserRoleProvider);
  return currentUserRole?.hasPermission('write') ?? false;
});

final hasReadPermissionProvider = Provider<bool>((ref) {
  final currentUserRole = ref.watch(currentUserRoleProvider);
  return currentUserRole?.hasPermission('read') ?? false;
});

final hasDeletePermissionProvider = Provider<bool>((ref) {
  final currentUserRole = ref.watch(currentUserRoleProvider);
  return currentUserRole?.hasPermission('delete') ?? false;
});