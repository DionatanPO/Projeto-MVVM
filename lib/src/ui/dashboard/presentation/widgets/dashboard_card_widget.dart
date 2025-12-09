// lib/src/ui/dashboard/presentation/widgets/dashboard_card_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/financial_summary.dart';

class DashboardCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const DashboardCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: backgroundColor ?? colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? colorScheme.onPrimaryContainer,
                  size: 28,
                ),
                const SizedBox(height: 12),
              ],
              Text(
                title,
                style: TextStyle(
                  color: iconColor ?? colorScheme.onPrimaryContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: iconColor ?? colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: (iconColor ?? colorScheme.onPrimaryContainer).withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}