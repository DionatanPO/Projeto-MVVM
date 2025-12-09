// lib/src/ui/dashboard/data/repositories/dashboard_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/financial_summary.dart';
import '../datasources/dashboard_remote_datasource.dart';

abstract class DashboardRepository {
  Future<Either<String, FinancialSummary>> getFinancialSummary();
  Future<Either<String, FinancialSummary>> refreshFinancialSummary();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _dataSource;

  DashboardRepositoryImpl(this._dataSource);

  @override
  Future<Either<String, FinancialSummary>> getFinancialSummary() async {
    try {
      final result = await _dataSource.getFinancialSummary();
      return result.map((model) => model.toEntity());
    } catch (e) {
      return left('Erro ao obter dados do dashboard: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, FinancialSummary>> refreshFinancialSummary() async {
    try {
      final result = await _dataSource.refreshFinancialSummary();
      return result.map((model) => model.toEntity());
    } catch (e) {
      return left('Erro ao atualizar dados do dashboard: ${e.toString()}');
    }
  }
}