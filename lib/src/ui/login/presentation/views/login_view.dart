import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../viewmodel/login_vm.dart';
import '../widgets/login_form.dart';



class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ESCUTAR EVENTOS (AQUI É O LUGAR CERTO DA NAVEGAÇÃO)
    // Isso roda fora da renderização visual. É seguro.
    ref.listen(loginVmProvider, (previous, next) {
      next.whenOrNull(
        data: (result) {
          if (result != null && result.isSuccess) {
            // Navega para a home imediatamente
            context.go('/home');
          }
        },
      );
    });

    // 2. OBSERVAR ESTADO PARA A UI
    final state = ref.watch(loginVmProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Padding para Desktop (opcional, baseado na nossa conversa anterior)
    final bool isDesktop = !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
    final double topPadding = isDesktop ? 40.0 : 0.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout(context, state);
          } else {
            return _buildMobileLayout(context, state, topPadding);
          }
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LAYOUT DESKTOP
  // ---------------------------------------------------------------------------
  Widget _buildDesktopLayout(BuildContext context, AsyncValue state) {
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
                // Passamos o estado para o widget de conteúdo desenhar o feedback
                child: _LoginFormContent(state: state),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LAYOUT MOBILE
  // ---------------------------------------------------------------------------
  Widget _buildMobileLayout(BuildContext context, AsyncValue state, double topPadding) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, topPadding + 40, 24, 40),
        child: Column(
          children: [
            const Icon(Icons.rocket_launch_rounded, size: 64, color: Colors.blue),
            const SizedBox(height: 32),
            _LoginFormContent(state: state),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CONTEÚDO DO FORMULÁRIO (PURAMENTE VISUAL AGORA)
// -----------------------------------------------------------------------------
class _LoginFormContent extends ConsumerWidget {
  final AsyncValue state;

  const _LoginFormContent({required this.state});

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
          onSubmit: (email, password) {
            ref.read(loginVmProvider.notifier).submit(email, password);
          },
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton(
              onPressed: () {},
              child: const Text("Esqueceu a senha?"),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // FEEDBACK VISUAL
        // Note: Removemos a lógica de navegação daqui.
        // Aqui só decidimos O QUE MOSTRAR na tela.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: state.when(
            data: (res) {
              if (res == null) return const SizedBox.shrink();

              // Se deu sucesso, mostramos feedback visual enquanto o ref.listen navega
              if (res.isSuccess) {
                return _FeedbackTile(
                  color: Colors.green.shade100,
                  icon: Icons.check_circle,
                  iconColor: Colors.green.shade800,
                  text: "Redirecionando...",
                );
              }

              // Se deu erro, mostramos o erro
              if (res.error != null) {
                return _FeedbackTile(
                  color: colorScheme.errorContainer,
                  icon: Icons.error_outline,
                  iconColor: colorScheme.error,
                  text: res.error!,
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
            error: (err, stack) => _FeedbackTile(
              color: colorScheme.errorContainer,
              icon: Icons.dangerous,
              iconColor: colorScheme.error,
              text: "Ocorreu um erro inesperado.",
            ),
          ),
        ),

        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Não tem uma conta?", style: TextStyle(color: colorScheme.onSurfaceVariant)),
            TextButton(
              onPressed: () {},
              child: const Text("Criar conta", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}

// Widget auxiliar de Feedback
class _FeedbackTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String text;

  const _FeedbackTile({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: iconColor, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}