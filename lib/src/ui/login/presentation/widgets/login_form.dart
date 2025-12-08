import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;

  const LoginForm({super.key, required this.onSubmit});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Já deixei preenchido para facilitar seu teste
  final emailCtrl = TextEditingController(text: 'demo@email.com');
  final passCtrl = TextEditingController(text: '123456');

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Estilo comum para os campos
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo Email
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: inputDecoration.copyWith(
              labelText: 'Email',
              hintText: 'seu@email.com',
              prefixIcon: Icon(Icons.email_outlined, color: colorScheme.onSurfaceVariant),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe seu email';
              if (!value.contains('@')) return 'Email inválido';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Campo Senha
          TextFormField(
            controller: passCtrl,
            obscureText: _obscureText,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: inputDecoration.copyWith(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe sua senha';
              if (value.length < 6) return 'Mínimo de 6 caracteres';
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Botão de Login
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit(emailCtrl.text.trim(), passCtrl.text);
                }
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Entrar',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}