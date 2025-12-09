// lib/src/ui/dashboard/domain/usecases/get_dashboard_data_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../entities/financial_summary.dart';
import '../../data/repositories/dashboard_repository.dart';

abstract class GetDashboardDataUsecase {
  Future<Either<String, FinancialSummary>> call();
}

class GetDashboardDataUsecaseImpl implements GetDashboardDataUsecase {
  final DashboardRepository _repository;

  GetDashboardDataUsecaseImpl(this._repository);

  @override
  Future<Either<String, FinancialSummary>> call() async {
    return await _repository.getFinancialSummary();
  }
}