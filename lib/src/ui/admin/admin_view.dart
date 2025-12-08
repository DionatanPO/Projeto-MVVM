import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/presentation/providers/role_provider.dart';


class AdminView extends ConsumerWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAccessAdmin = ref.watch(canAccessAdminAreaProvider);
    final hasDeletePermission = ref.watch(hasDeletePermissionProvider);
    final currentUserRole = ref.watch(currentUserRoleProvider);

    if (!canAccessAdmin) {
      return const Scaffold(
        body: Center(
          child: Text('Acesso negado. Você não tem permissão para esta área.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Área Administrativa'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, Administrador!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Perfil atual: ${currentUserRole?.type.value ?? 'Desconhecido'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: hasDeletePermission ? () => _deleteItem(context) : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir Item', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _manageUsers(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Gerenciar Usuários', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(BuildContext context) {
    // Simular exclusão
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item excluído com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _manageUsers(BuildContext context) {
    // Simular gerenciamento de usuários
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerenciar Usuários'),
        content: const Text('Funcionalidade de gerenciamento de usuários.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}