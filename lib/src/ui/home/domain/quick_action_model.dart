import 'package:flutter/material.dart';

class QuickActionModel {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // O que acontece ao clicar

  const QuickActionModel({
    required this.icon,
    required this.label,
    this.onTap,
  });
}