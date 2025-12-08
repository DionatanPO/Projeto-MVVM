import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodel/dashboard_vm.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dashboardVmProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Gerenciamento de Estado de Carregamento (Loading/Error/Data)
    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Erro: $err")),
      data: (data) {
        return CustomScrollView(
          slivers: [
            SliverAppBar.large(
              expandedHeight: 100,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: colorScheme.surfaceTint,
              title: Text("Dashboard", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
                const SizedBox(width: 16),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Cartão de Saldo (Vindo do ViewModel)
                  _BalanceCard(balance: data.balance),

                  const SizedBox(height: 32),

                  Text("Transações Recentes", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Lista de Transações (Vindo do ViewModel)
                  ...data.transactions.map((t) => _TransactionTile(transaction: t)),

                  const SizedBox(height: 80), // Espaço final
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widgets Privados locais (ou extraia para arquivos separados se crescerem)
class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Saldo Total", style: TextStyle(color: colorScheme.onPrimaryContainer)),
            const SizedBox(height: 8),
            Text(
              "R\$ ${balance.toStringAsFixed(2)}",
              style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final dynamic transaction; // Use o tipo TransactionModel aqui
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.surfaceContainerLow,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondaryContainer,
          child: Icon(
            transaction.isNegative ? Icons.shopping_bag : Icons.attach_money,
            color: colorScheme.onSecondaryContainer,
            size: 20,
          ),
        ),
        title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(transaction.subtitle),
        trailing: Text(
          "${transaction.isNegative ? '-' : '+'} R\$ ${transaction.value}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: transaction.isNegative ? colorScheme.error : Colors.green,
          ),
        ),
      ),
    );
  }
}