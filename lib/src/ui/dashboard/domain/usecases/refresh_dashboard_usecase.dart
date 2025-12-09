// lib/src/ui/dashboard/domain/usecases/refresh_dashboard_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../entities/financial_summary.dart';
import '../../data/repositories/dashboard_repository.dart';

abstract class RefreshDashboardUsecase {
  Future<Either<String, FinancialSummary>> call();
}

class RefreshDashboardUsecaseImpl implements RefreshDashboardUsecase {
  final DashboardRepository _repository;

  RefreshDashboardUsecaseImpl(this._repository);

  @override
  Future<Either<String, FinancialSummary>> call() async {
    return await _repository.refreshFinancialSummary();
  }
}