// lib/src/ui/dashboard/data/models/dashboard_item_model.dart
import '../../domain/entities/dashboard_item.dart';

class DashboardItemModel extends DashboardItem {
  const DashboardItemModel({
    required super.id,
    required super.type,
    required super.title,
    super.subtitle,
    super.data,
    required super.createdAt,
  });

  factory DashboardItemModel.fromJson(Map<String, dynamic> json) {
    return DashboardItemModel(
      id: json['id'] ?? '',
      type: DashboardItemType.values[json['type'] ?? 0],
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      data: json['data'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'title': title,
      'subtitle': subtitle,
      'data': data,
      'created_at': createdAt.toIso8601String(),
    };
  }

  DashboardItem toEntity() {
    return DashboardItem(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      data: data,
      createdAt: createdAt,
    );
  }

  factory DashboardItemModel.fromEntity(DashboardItem entity) {
    return DashboardItemModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      subtitle: entity.subtitle,
      data: entity.data,
      createdAt: entity.createdAt,
    );
  }
}