// lib/src/ui/dashboard/presentation/views/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodel/dashboard_viewmodel.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/financial_chart_widget.dart';
import '../widgets/quick_actions_widget.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final successColor = Colors.green.shade700; // More theme-friendly green

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              centerTitle: false,
              title: Text(
                "Meu Dashboard",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {}, // Placeholder for profile
                icon: const Icon(Icons.notifications_none_outlined),
                iconSize: 26,
              ),
              IconButton(
                onPressed: () {
                  ref
                      .read(dashboardViewModelProvider.notifier)
                      .refreshDashboard();
                },
                icon: const Icon(Icons.sync),
                iconSize: 26,
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                dashboardState.when(
                  data: (state) {
                    if (state.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 64.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state.error != null) {
                      return _buildErrorState(colorScheme, ref, state.error!);
                    }

                    if (state.data == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text('Nenhum dado disponível'),
                        ),
                      );
                    }

                    final data = state.data!;
                    final transactions = data.recentTransactions;
                    final quickActions = data.quickActions;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildTotalBalanceCard(
                            context, colorScheme, data.totalBalance),
                        const SizedBox(height: 24),

                        // Cards de Resumo
                        Row(
                          children: [
                            Expanded(
                              child: DashboardCardWidget(
                                title: "Receita Mensal",
                                value:
                                    "R\$ ${data.monthlyIncome.toStringAsFixed(2)}",
                                subtitle: "Últimos 30 dias",
                                backgroundColor:
                                    colorScheme.surfaceContainerHighest,
                                icon: Icons.arrow_upward,
                                iconColor: successColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DashboardCardWidget(
                                title: "Despesas Mensais",
                                value:
                                    "R\$ ${data.monthlyExpenses.toStringAsFixed(2)}",
                                subtitle: "Últimos 30 dias",
                                backgroundColor:
                                    colorScheme.surfaceContainerHighest,
                                icon: Icons.arrow_downward,
                                iconColor: colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Gráfico de Distribuição
                        _buildSectionHeader(context, "Análise Financeira"),
                        const SizedBox(height: 12),
                        FinancialChartWidget(transactions: transactions),
                        const SizedBox(height: 24),

                        // Ações Rápidas
                        _buildSectionHeader(context, "Ações Rápidas"),
                        const SizedBox(height: 12),
                        QuickActionsWidget(
                          actions: quickActions,
                          onActionPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Ação selecionada!'),
                                backgroundColor: colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Transações Recentes
                        _buildRecentTransactionsHeader(context, colorScheme),
                        const SizedBox(height: 12),

                        ...transactions.take(5).map((transaction) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 0,
                            color: colorScheme.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  transaction.isExpense
                                      ? Icons.shopping_bag_outlined
                                      : Icons.account_balance_wallet_outlined,
                                  color: transaction.isExpense
                                      ? colorScheme.error
                                      : successColor,
                                ),
                              ),
                              title: Text(
                                transaction.title,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                '${transaction.category} • ${_formatDate(transaction.date)}',
                                style: GoogleFonts.inter(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: Text(
                                transaction.isExpense
                                    ? '- R\$ ${transaction.amount.toStringAsFixed(2)}'
                                    : '+ R\$ ${transaction.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: transaction.isExpense
                                      ? colorScheme.error
                                      : successColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 64.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stack) =>
                      _buildErrorState(colorScheme, ref, error.toString()),
                ),
                const SizedBox(height: 24), // Bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBalanceCard(
      BuildContext context, ColorScheme colorScheme, double totalBalance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            Color.lerp(colorScheme.primary, colorScheme.secondary, 0.4)!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saldo Total Disponível",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "R\$ ${totalBalance.toStringAsFixed(2)}",
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildRecentTransactionsHeader(
      BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(context, "Transações Recentes"),
        TextButton(
          onPressed: () {},
          child: Text(
            "Ver todas",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme, WidgetRef ref, String error) {
    return Card(
      elevation: 0,
      color: colorScheme.errorContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.errorContainer),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: colorScheme.onErrorContainer,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Algo deu errado.',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Não foi possível carregar os dados do dashboard. Por favor, verifique sua conexão e tente novamente.',
              style: GoogleFonts.inter(
                color: colorScheme.onErrorContainer.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref
                    .read(dashboardViewModelProvider.notifier)
                    .refreshDashboard();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}