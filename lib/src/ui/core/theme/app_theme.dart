import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // COR DA MARCA
  // Usando um Azul Profundo (Brand Blue) que fica melhor que o Colors.blue padrão
  // ---------------------------------------------------------------------------
  static const Color _brandColor = Color(0xFF0061A4); // Azul Profundo Profissional

  // ... (O bloco _buildTextTheme continua IGUAL, não precisa mexer) ...
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.poppins(textStyle: base.displayLarge, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(textStyle: base.displayMedium, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(textStyle: base.displaySmall, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.poppins(textStyle: base.headlineLarge, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.poppins(textStyle: base.headlineMedium, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppins(textStyle: base.headlineSmall, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(textStyle: base.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(textStyle: base.titleMedium, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.inter(textStyle: base.titleSmall, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(textStyle: base.bodyLarge),
      bodyMedium: GoogleFonts.inter(textStyle: base.bodyMedium),
      bodySmall: GoogleFonts.inter(textStyle: base.bodySmall),
      labelLarge: GoogleFonts.inter(textStyle: base.labelLarge, fontWeight: FontWeight.bold),
      labelMedium: GoogleFonts.inter(textStyle: base.labelMedium, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(textStyle: base.labelSmall, fontWeight: FontWeight.w500),
    );
  }

  // ---------------------------------------------------------------------------
  // TEMA CLARO (LIGHT)
  // ---------------------------------------------------------------------------
  static ThemeData get light {
    final base = ThemeData.light();

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandColor,
      brightness: Brightness.light,

      // --- CORREÇÃO AQUI ---
      // 'expressive': Mistura cores (Azul vira Verde/Roxo)
      // 'fidelity': Mantém a cor EXATA (Azul fica Azul)
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(base.textTheme),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),


      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEMA ESCURO (DARK)
  // ---------------------------------------------------------------------------
  static ThemeData get dark {
    final base = ThemeData.dark();

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _brandColor,
      brightness: Brightness.dark,

      // --- CORREÇÃO AQUI TAMBÉM ---
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(base.textTheme),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),


      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}