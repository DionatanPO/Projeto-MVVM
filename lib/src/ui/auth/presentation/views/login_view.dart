import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodels/auth_vm.dart';
import '../viewmodels/login_error_provider.dart';
import '../widgets/login_form.dart';

class LoginView extends ConsumerWidget {
  final void Function() onNavigateToRegister;
  final void Function() onNavigateToForgotPassword;

  const LoginView({
    Key? key,
    required this.onNavigateToRegister,
    required this.onNavigateToForgotPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authVmProvider);
    final authVm = ref.watch(authVmProvider.notifier);

    // Padding para Desktop (opcional)
    final bool isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    final double topPadding = isDesktop ? 40.0 : 0.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout(context, authState, authVm);
          } else {
            return _buildMobileLayout(context, authState, topPadding, authVm);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AuthStatus authState, AuthVm authVm) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // LADO ESQUERDO (Branding)
        Expanded(
          flex: 5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=2070&auto=format&fit=crop",
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withOpacity(0.90),
                      const Color(0xFF003366).withOpacity(0.95),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.rocket_launch_rounded, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Transforme a\nsua gestão.",
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // LADO DIREITO (Form)
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: _LoginContent(
                  onNavigateToRegister: onNavigateToRegister,
                  onNavigateToForgotPassword: onNavigateToForgotPassword,
                  authState: authState,
                  authVm: authVm,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthStatus authState, double topPadding, AuthVm authVm) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, topPadding + 40, 24, 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: _LoginContent(
            onNavigateToRegister: onNavigateToRegister,
            onNavigateToForgotPassword: onNavigateToForgotPassword,
            authState: authState,
            authVm: authVm,
          ),
        ),
      ),
    );
  }
}

class _LoginContent extends ConsumerWidget {
  final void Function() onNavigateToRegister;
  final void Function() onNavigateToForgotPassword;
  final AuthStatus authState;
  final AuthVm authVm;

  const _LoginContent({
    required this.onNavigateToRegister,
    required this.onNavigateToForgotPassword,
    required this.authState,
    required this.authVm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bem-vindo(a)!",
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Insira seus dados para acessar sua conta.",
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 40),

        // O FORMULÁRIO
        LoginForm(
          onLogin: (email, password) async {
            await authVm.login(email, password);
          },
          onNavigateToRegister: onNavigateToRegister,
          onNavigateToForgotPassword: onNavigateToForgotPassword,
          isLoading: authState == AuthStatus.loading,
          errorMessage: ref.watch(loginErrorProvider),
        ),
      ],
    );
  }
}