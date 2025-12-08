import 'package:flutter/material.dart';
import '../../domain/quick_action_model.dart';

class QuickActionWidget extends StatelessWidget {
  final QuickActionModel action;

  const QuickActionWidget({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: action.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 60, // Altura do botão
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                action.icon,
                color: colorScheme.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}