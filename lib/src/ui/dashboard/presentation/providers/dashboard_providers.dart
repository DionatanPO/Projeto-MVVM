// lib/src/ui/dashboard/presentation/providers/dashboard_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../domain/usecases/refresh_dashboard_usecase.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) {
  return DashboardRemoteDataSourceImpl();
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final dataSource = ref.watch(dashboardRemoteDataSourceProvider);
  return DashboardRepositoryImpl(dataSource);
}

@riverpod
GetDashboardDataUsecase getDashboardDataUsecase(Ref ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetDashboardDataUsecaseImpl(repository);
}

@riverpod
RefreshDashboardUsecase refreshDashboardUsecase(Ref ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return RefreshDashboardUsecaseImpl(repository);
}