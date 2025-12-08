import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/src/ui/core/theme/app_theme.dart';
import 'src/routing/app_router.dart';

import 'src/ui/core/widgets/app_title_bar.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Seu App Azul',

      // TEMA FIXO: Não depende mais de 'systemColor'
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // Ainda respeita Claro/Escuro do sistema

      routerConfig: goRouter,

      // Configuração da Barra de Título Customizada (Spotify Style)
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: child ?? const SizedBox(),
              ),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: AppTitleBar.height,
                child: AppTitleBar(),
              ),
            ],
          ),
        );
      },
    );
  }
}