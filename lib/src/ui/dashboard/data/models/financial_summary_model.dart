// lib/src/ui/dashboard/data/models/financial_summary_model.dart
import '../../domain/entities/financial_summary.dart';

class FinancialSummaryModel extends FinancialSummary {
  const FinancialSummaryModel({
    required double totalBalance,
    required double monthlyIncome,
    required double monthlyExpenses,
    required double netChange,
    required List<TransactionItem> recentTransactions,
    required List<QuickActionItem> quickActions,
  }) : super(
          totalBalance: totalBalance,
          monthlyIncome: monthlyIncome,
          monthlyExpenses: monthlyExpenses,
          netChange: netChange,
          recentTransactions: recentTransactions,
          quickActions: quickActions,
        );

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinancialSummaryModel(
      totalBalance: (json['total_balance'] as num?)?.toDouble() ?? 0.0,
      monthlyIncome: (json['monthly_income'] as num?)?.toDouble() ?? 0.0,
      monthlyExpenses: (json['monthly_expenses'] as num?)?.toDouble() ?? 0.0,
      netChange: (json['net_change'] as num?)?.toDouble() ?? 0.0,
      recentTransactions: (json['recent_transactions'] as List<dynamic>?)
              ?.map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      quickActions: (json['quick_actions'] as List<dynamic>?)
              ?.map((e) => QuickActionItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_balance': totalBalance,
      'monthly_income': monthlyIncome,
      'monthly_expenses': monthlyExpenses,
      'net_change': netChange,
      'recent_transactions': recentTransactions
          .map((e) => (e as TransactionItemModel).toJson())
          .toList(),
      'quick_actions': quickActions
          .map((e) => (e as QuickActionItemModel).toJson())
          .toList(),
    };
  }

  FinancialSummary toEntity() {
    return FinancialSummary(
      totalBalance: totalBalance,
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      netChange: netChange,
      recentTransactions: recentTransactions
          .map((e) => TransactionItem(
            id: e.id,
            title: e.title,
            category: e.category,
            amount: e.amount,
            date: e.date,
            isExpense: e.isExpense,
          ))
          .toList(),
      quickActions: quickActions
          .map((e) => QuickActionItem(
            id: e.id,
            title: e.title,
            icon: e.icon,
          ))
          .toList(),
    );
  }

  factory FinancialSummaryModel.fromEntity(FinancialSummary entity) {
    return FinancialSummaryModel(
      totalBalance: entity.totalBalance,
      monthlyIncome: entity.monthlyIncome,
      monthlyExpenses: entity.monthlyExpenses,
      netChange: entity.netChange,
      recentTransactions: List<TransactionItemModel>.from(
        entity.recentTransactions.map((e) => TransactionItemModel(
          id: e.id,
          title: e.title,
          category: e.category,
          amount: e.amount,
          date: e.date,
          isExpense: e.isExpense,
        )),
      ),
      quickActions: List<QuickActionItemModel>.from(
        entity.quickActions.map((e) => QuickActionItemModel(
          id: e.id,
          title: e.title,
          icon: e.icon,
        )),
      ),
    );
  }
}

class TransactionItemModel extends TransactionItem {
  const TransactionItemModel({
    required String id,
    required String title,
    required String category,
    required double amount,
    required DateTime date,
    required bool isExpense,
  }) : super(
          id: id,
          title: title,
          category: category,
          amount: amount,
          date: date,
          isExpense: isExpense,
        );

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isExpense: json['is_expense'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'is_expense': isExpense,
    };
  }
}

class QuickActionItemModel extends QuickActionItem {
  const QuickActionItemModel({
    required String id,
    required String title,
    required String icon,
  }) : super(
          id: id,
          title: title,
          icon: icon,
        );

  factory QuickActionItemModel.fromJson(Map<String, dynamic> json) {
    return QuickActionItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
    };
  }
}