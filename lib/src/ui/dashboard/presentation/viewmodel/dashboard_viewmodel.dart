// lib/src/ui/dashboard/presentation/viewmodel/dashboard_viewmodel.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart';
import '../../domain/usecases/refresh_dashboard_usecase.dart';
import '../providers/dashboard_providers.dart'; // Importar os providers

part 'dashboard_viewmodel.g.dart';

class DashboardState {
  final FinancialSummary? data;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    FinancialSummary? data,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  Future<DashboardState> build() async {
    return _loadDashboardData();
  }

  Future<DashboardState> _loadDashboardData() async {
    final usecase = ref.read(getDashboardDataUsecaseProvider);

    state = const AsyncValue.data(DashboardState(isLoading: true));

    final result = await usecase();

    return result.fold(
      (error) => DashboardState(error: error, isLoading: false),
      (data) => DashboardState(data: data, isLoading: false),
    );
  }

  Future<void> refreshDashboard() async {
    final usecase = ref.read(refreshDashboardUsecaseProvider);

    state = AsyncValue.data(state.value?.copyWith(isLoading: true) ??
        const DashboardState(isLoading: true));

    final result = await usecase();

    result.fold(
      (error) => state = AsyncValue.data(
          state.value?.copyWith(isLoading: false, error: error) ??
          DashboardState(error: error, isLoading: false)),
      (data) => state = AsyncValue.data(
          state.value?.copyWith(isLoading: false, data: data, error: null) ??
          DashboardState(data: data, isLoading: false, error: null)),
    );
  }
}