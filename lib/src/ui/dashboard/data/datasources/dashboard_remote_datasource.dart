// lib/src/ui/dashboard/data/datasources/dashboard_remote_datasource.dart
import 'package:fpdart/fpdart.dart';
import '../models/financial_summary_model.dart';

abstract class DashboardRemoteDataSource {
  Future<Either<String, FinancialSummaryModel>> getFinancialSummary();
  Future<Either<String, FinancialSummaryModel>> refreshFinancialSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<Either<String, FinancialSummaryModel>> getFinancialSummary() async {
    // Simulando chamada de API
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Dados simulados
      final financialSummary = FinancialSummaryModel(
        totalBalance: 12450.75,
        monthlyIncome: 8500.00,
        monthlyExpenses: 4250.25,
        netChange: 4250.50,
        recentTransactions: [
          TransactionItemModel(
            id: '1',
            title: 'Supermercado',
            category: 'Alimentação',
            amount: 120.50,
            date: DateTime(2025, 12, 8),
            isExpense: true,
          ),
          TransactionItemModel(
            id: '2',
            title: 'Salário',
            category: 'Receita',
            amount: 8500.00,
            date: DateTime(2025, 12, 1),
            isExpense: false,
          ),
          TransactionItemModel(
            id: '3',
            title: 'Netflix',
            category: 'Entretenimento',
            amount: 55.90,
            date: DateTime(2025, 12, 5),
            isExpense: true,
          ),
        ],
        quickActions: [
          QuickActionItemModel(
            id: '1',
            title: 'Pix',
            icon: 'pix',
          ),
          QuickActionItemModel(
            id: '2',
            title: 'Pagar',
            icon: 'qr_code',
          ),
          QuickActionItemModel(
            id: '3',
            title: 'Investir',
            icon: 'bar_chart',
          ),
          QuickActionItemModel(
            id: '4',
            title: 'Extrato',
            icon: 'receipt_long',
          ),
        ],
      );
      
      return right(financialSummary);
    } catch (e) {
      return left('Erro ao obter dados financeiros: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, FinancialSummaryModel>> refreshFinancialSummary() async {
    // Simulando chamada de API para atualização
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Dados simulados atualizados
      final financialSummary = FinancialSummaryModel(
        totalBalance: 13250.75, // Atualizado após novas transações
        monthlyIncome: 9500.00,
        monthlyExpenses: 4450.25,
        netChange: 5050.50,
        recentTransactions: [
          TransactionItemModel(
            id: '1',
            title: 'Supermercado',
            category: 'Alimentação',
            amount: 120.50,
            date: DateTime(2025, 12, 8),
            isExpense: true,
          ),
          TransactionItemModel(
            id: '2',
            title: 'Salário',
            category: 'Receita',
            amount: 8500.00,
            date: DateTime(2025, 12, 1),
            isExpense: false,
          ),
          TransactionItemModel(
            id: '3',
            title: 'Netflix',
            category: 'Entretenimento',
            amount: 55.90,
            date: DateTime(2025, 12, 5),
            isExpense: true,
          ),
          TransactionItemModel(
            id: '4',
            title: 'Bônus',
            category: 'Receita',
            amount: 1000.00,
            date: DateTime(2025, 12, 9),
            isExpense: false,
          ),
        ],
        quickActions: [
          QuickActionItemModel(
            id: '1',
            title: 'Pix',
            icon: 'pix',
          ),
          QuickActionItemModel(
            id: '2',
            title: 'Pagar',
            icon: 'qr_code',
          ),
          QuickActionItemModel(
            id: '3',
            title: 'Investir',
            icon: 'bar_chart',
          ),
          QuickActionItemModel(
            id: '4',
            title: 'Extrato',
            icon: 'receipt_long',
          ),
        ],
      );
      
      return right(financialSummary);
    } catch (e) {
      return left('Erro ao atualizar dados financeiros: ${e.toString()}');
    }
  }
}