// lib/src/ui/dashboard/presentation/widgets/quick_actions_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/financial_summary.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<QuickActionItem> actions;
  final VoidCallback? onActionPressed;

  const QuickActionsWidget({
    Key? key,
    required this.actions,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações Rápidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                IconData iconData = _getIconData(action.icon);

                return InkWell(
                  onTap: () {
                    onActionPressed?.call();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          iconData,
                          color: colorScheme.onSecondaryContainer,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action.title,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'pix':
        return Icons.pix;
      case 'qr_code':
        return Icons.qr_code;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'receipt_long':
        return Icons.receipt_long;
      default:
        return Icons.add;
    }
  }
}