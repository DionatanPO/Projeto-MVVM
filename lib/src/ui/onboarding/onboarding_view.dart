import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/src/ui/onboarding/onboarding_view_model.dart';
import 'data/onboarding_items.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema e Cores
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Estado Riverpod
    final currentIndex = ref.watch(onboardingViewModelProvider);
    final item = OnboardingItem.items[currentIndex];
    final isLastPage = currentIndex == OnboardingItem.items.length - 1;

    // Ações
    void next() {
      if (isLastPage) {
        ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
        context.go('/login');
      } else {
        ref
            .read(onboardingViewModelProvider.notifier)
            .updatePage(currentIndex + 1);
      }
    }

    return Scaffold(
      // Fundo atrás da imagem (caso a imagem demore a carregar)
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: Stack(
        children: [
          // ---------------------------------------------------------
          // CAMADA 1: A IMAGEM (Ocupa 65% superior da tela)
          // ---------------------------------------------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.35,
            // Deixa 35% para o texto
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) {
                // Efeito de Scale sutil + Fade na imagem
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 1.05,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey<String>(item.imageUrl),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item.imageUrl),
                    fit: BoxFit.cover, // Preenche tudo
                  ),
                ),
              ),
            ),
          ),

          // ---------------------------------------------------------
          // CAMADA 2: O "SHEET" DE CONTEÚDO (Ocupa a base)
          // ---------------------------------------------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.45, // Sobe um pouco sobre a imagem
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface, // Cor do tema (Branco/Preto)
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- INDICADORES (DOTS) ---
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(OnboardingItem.items.length, (
                          index,
                        ) {
                          final isActive = index == currentIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 6,
                            width: isActive ? 32 : 6,
                            // Estica se ativo
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 24),

                      // --- TÍTULO ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.2, 0),
                                    // Vem da direita
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                item.title,
                                key: ValueKey<String>(item.title),
                                style: textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  // Poppins ExtraBold
                                  color: colorScheme.onSurface,
                                  height: 1.1,
                                  letterSpacing: -1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // --- DESCRIÇÃO ---
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: Text(
                                item.description,
                                key: ValueKey<String>(item.description),
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- BOTÕES DE NAVEGAÇÃO ---
                      Row(
                        children: [
                          // Botão Pular (Visível se não for o último)
                          if (!isLastPage)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(onboardingViewModelProvider.notifier)
                                    .completeOnboarding();
                                context.go('/login');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: colorScheme.secondary,
                              ),
                              child: const Text("Pular"),
                            ),

                          const Spacer(),

                          // Botão Principal (FAB ou Botão Grande)
                          FloatingActionButton.extended(
                            onPressed: next,
                            elevation: 0,
                            // Flat design
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            label: Row(
                              children: [
                                Text(
                                  isLastPage ? "Vamos lá" : "Próximo",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isLastPage
                                      ? Icons.rocket_launch
                                      : Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
