// lib/src/ui/dashboard/presentation/widgets/financial_chart_widget.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../domain/entities/financial_summary.dart';

class FinancialChartWidget extends StatelessWidget {
  final List<TransactionItem> transactions;

  const FinancialChartWidget({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Agrupar transações por categoria para o gráfico
    final categoryTotals = <String, double>{};
    for (final transaction in transactions) {
      final currentTotal = categoryTotals[transaction.category] ?? 0.0;
      categoryTotals[transaction.category] = currentTotal + transaction.amount.abs();
    }

    final chartData = categoryTotals.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição de Gastos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            SfCircularChart(
              palette: [
                colorScheme.primary,
                colorScheme.secondary,
                colorScheme.tertiary,
                colorScheme.error,
                colorScheme.outline,
              ],
              series: [
                PieSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.category,
                  yValueMapper: (ChartData data, _) => data.amount,
                  dataLabelMapper: (ChartData data, _) =>
                      'R\$${data.amount.toStringAsFixed(2)}',
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  enableTooltip: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final double amount;

  ChartData(this.category, this.amount);
}