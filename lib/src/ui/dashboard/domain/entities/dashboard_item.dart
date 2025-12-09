// lib/src/ui/dashboard/domain/entities/dashboard_item.dart
import 'package:equatable/equatable.dart';

enum DashboardItemType {
  summary,
  transaction,
  chart,
  quickAction,
  notification,
}

class DashboardItem extends Equatable {
  final String id;
  final DashboardItemType type;
  final String title;
  final String? subtitle;
  final dynamic data;
  final DateTime createdAt;

  const DashboardItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.data,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, title, subtitle, data, createdAt];
}