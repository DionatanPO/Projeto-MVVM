import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/views/dashboard_view.dart';
import '../../../../ui/core/widgets/app_title_bar.dart'; // Ajuste o import
import '../viewmodel/home_navigation_vm.dart';
import '../widgets/home_sidebar.dart';

class HomeShellView extends ConsumerWidget {
  const HomeShellView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Estado da Navegação
    final navIndex = ref.watch(homeNavigationVmProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // 2. Cálculo do Padding para Desktop (Barra de Título Customizada)
    final bool isDesktopApp = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    final double topPadding = isDesktopApp ? AppTitleBar.height : 0.0;

    // 3. Lista de Telas
    final screens = [
      const DashboardView(),        // A View complexa que criamos
      const Center(child: Text("Carteira (Em breve)")),
      const Center(child: Text("Relatórios (Em breve)")),
      const Center(child: Text("Ajustes (Em breve)")),
    ];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = width < 600;
          final isDesktop = width >= 1100;

          // --- LAYOUT MOBILE ---
          if (isMobile) {
            return Column(
              children: [
                Expanded(child: screens[navIndex]),
              ],
            );
          }

          // --- LAYOUT DESKTOP / TABLET ---
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra Lateral Isolada (Widget separado)
              HomeSidebar(
                selectedIndex: navIndex,
                onDestinationSelected: (idx) => ref.read(homeNavigationVmProvider.notifier).setIndex(idx),
                isExtended: isDesktop,
                topPadding: topPadding, // Passamos o padding para o cabeçalho
              ),

              VerticalDivider(thickness: 1, width: 1, color: colorScheme.outlineVariant),

              // Conteúdo Principal
              Expanded(
                child: Padding(
                  // Padding APENAS no topo do conteúdo, para não bater na barra de título
                  padding: EdgeInsets.only(top: topPadding),
                  child: screens[navIndex],
                ),
              ),
            ],
          );
        },
      ),

      // Barra Inferior (Mobile) - Pode extrair para Widget também se quiser
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? NavigationBar(
        selectedIndex: navIndex,
        onDestinationSelected: (idx) => ref.read(homeNavigationVmProvider.notifier).setIndex(idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.wallet_outlined), label: 'Carteira'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Relat.'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      )
          : null,
    );
  }
}