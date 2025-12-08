import 'package:flutter/material.dart'; // Precisa importar Material para os Ícones
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/transaction_model.dart';
import '../../domain/quick_action_model.dart'; // Importe o novo model

part 'dashboard_vm.g.dart';

class DashboardState {
  final double balance;
  final List<TransactionModel> transactions;
  final List<QuickActionModel> quickActions; // Adicione a lista aqui

  DashboardState({
    required this.balance,
    required this.transactions,
    required this.quickActions,
  });
}

@riverpod
class DashboardVm extends _$DashboardVm {
  @override
  Future<DashboardState> build() async {
    await Future.delayed(const Duration(seconds: 1));

    return DashboardState(
      balance: 12450.00,

      // AQUI DEFINIMOS OS BOTÕES DINAMICAMENTE
      quickActions: [
        QuickActionModel(icon: Icons.pix, label: "Pix", onTap: () => print("Pix")),
        QuickActionModel(icon: Icons.qr_code, label: "Pagar"),
        QuickActionModel(icon: Icons.bar_chart, label: "Investir"),
        QuickActionModel(icon: Icons.receipt_long, label: "Extrato"),
      ],

      transactions: [
        TransactionModel(title: "Supermercado", subtitle: "Hoje, 10:30", value: 120.00),
        TransactionModel(title: "Netflix", subtitle: "Ontem", value: 55.90),
      ],
    );
  }
}