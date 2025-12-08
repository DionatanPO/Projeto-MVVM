import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class AppTitleBar extends StatefulWidget {
  // Altura fixa para podermos alinhar coisas depois se precisar
  static const double height = 40.0;

  const AppTitleBar({super.key});

  @override
  State<AppTitleBar> createState() => _AppTitleBarState();
}

class _AppTitleBarState extends State<AppTitleBar> with WindowListener {
  bool isMaximized = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      windowManager.addListener(this);
      _checkMaximized();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  void _checkMaximized() async {
    final max = await windowManager.isMaximized();
    if (mounted) setState(() => isMaximized = max);
  }

  @override
  void onWindowMaximize() => setState(() => isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => isMaximized = false);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux)) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: AppTitleBar.height,
      child: Row(
        children: [
          // 1. ÁREA DE ARRASTAR (Drag Area)
          // Ocupa todo o espaço vazio à esquerda. É invisível, mas se clicar, arrasta.
          const Expanded(
            child: DragToMoveArea(
              child: SizedBox.expand(), // Ocupa todo o espaço disponível
            ),
          ),

          // 2. BOTÕES DO WINDOWS (Fixos na direita)
          _WindowsButton(
            icon: Icons.remove,
            onPressed: () => windowManager.minimize(),
          ),
          _WindowsButton(
            icon: isMaximized ? Icons.filter_none : Icons.crop_square,
            tooltip: isMaximized ? "Restaurar" : "Maximizar",
            onPressed: () {
              if (isMaximized) {
                windowManager.unmaximize();
              } else {
                windowManager.maximize();
              }
            },
          ),
          _WindowsButton(
            icon: Icons.close,
            isCloseButton: true,
            onPressed: () => windowManager.close(),
          ),
        ],
      ),
    );
  }
}

// --- BOTÃO ESTILO NATIVO (IDÊNTICO AO ANTERIOR) ---
class _WindowsButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isCloseButton;
  final String? tooltip;

  const _WindowsButton({
    required this.icon,
    required this.onPressed,
    this.isCloseButton = false,
    this.tooltip,
  });

  @override
  State<_WindowsButton> createState() => _WindowsButtonState();
}

class _WindowsButtonState extends State<_WindowsButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Para ficar igual ao Spotify: Fundo transparente quando normal, cor quando hover.
    Color backgroundColor = Colors.transparent;
    // Spotify usa ícones brancos/cinzas dependendo do tema.
    Color iconColor = theme.colorScheme.onSurface;

    if (isHovered) {
      if (widget.isCloseButton) {
        backgroundColor = const Color(0xFFC42B1C);
        iconColor = Colors.white;
      } else {
        backgroundColor = theme.colorScheme.onSurface.withOpacity(0.1);
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: double.infinity,
          color: backgroundColor,
          alignment: Alignment.center,
          child: Icon(widget.icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}