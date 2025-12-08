import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HighlightCard extends StatelessWidget {
  final double balance;
  final VoidCallback? onTapAction;

  const HighlightCard({
    super.key,
    required this.balance,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer, // Usa container para contraste suave
      margin: EdgeInsets.zero, // Remove margem externa padrão
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Saldo Total",
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Dica: Use o pacote 'intl' para formatar dinheiro corretamente em produção
                    "R\$ ${balance.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                      letterSpacing: -1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Botão de Ação Rápida dentro do Card
            FilledButton.icon(
              onPressed: onTapAction ?? () {},
              icon: const Icon(Icons.add),
              label: const Text("Nova Receita"),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}