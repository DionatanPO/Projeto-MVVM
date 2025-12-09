// lib/src/ui/dashboard/domain/entities/financial_summary.dart
import 'package:equatable/equatable.dart';

class FinancialSummary extends Equatable {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double netChange;
  final List<TransactionItem> recentTransactions;
  final List<QuickActionItem> quickActions;

  const FinancialSummary({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.netChange,
    required this.recentTransactions,
    required this.quickActions,
  });

  @override
  List<Object?> get props => [
    totalBalance,
    monthlyIncome,
    monthlyExpenses,
    netChange,
    recentTransactions,
    quickActions,
  ];
}

class TransactionItem extends Equatable {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isExpense;

  const TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
  });

  @override
  List<Object?> get props => [id, title, category, amount, date, isExpense];
}

class QuickActionItem extends Equatable {
  final String id;
  final String title;
  final String icon;

  const QuickActionItem({
    required this.id,
    required this.title,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, icon];
}