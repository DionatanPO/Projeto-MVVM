import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/src/ui/login/presentation/views/login_view.dart';

import '../ui/home/presentation/views/home_shell_view.dart';
import '../ui/onboarding/onboarding_view.dart';


part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    // 1. MUDAMOS O INÍCIO PARA ONBOARDING
    initialLocation: '/onboarding',

    debugLogDiagnostics: true,
    routes: [
      // 2. NOVA ROTA DO ONBOARDING
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        // Agora chamamos o Shell, que carrega o Menu + Dashboard
        builder: (context, state) => const HomeShellView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        // Agora chamamos o Shell, que carrega o Menu + Dashboard
        builder: (context, state) => const LoginView(),
      ),
    ],
  );
}