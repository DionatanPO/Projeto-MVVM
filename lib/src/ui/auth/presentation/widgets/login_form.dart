import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onLogin;
  final void Function() onNavigateToRegister;
  final void Function() onNavigateToForgotPassword;
  final bool isLoading;
  final String? errorMessage;

  const LoginForm({
    Key? key,
    required this.onLogin,
    required this.onNavigateToRegister,
    required this.onNavigateToForgotPassword,
    this.isLoading = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-populate for testing purposes
    emailController.text = 'demo@email.com';
    passwordController.text = '123456';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: inputDecoration.copyWith(
              labelText: 'Email',
              hintText: 'seu@email.com',
              prefixIcon: Icon(Icons.email_outlined, color: colorScheme.onSurfaceVariant),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe seu email';
              if (!EmailValidator.validate(value)) return 'Email inválido';
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Campo Senha
          TextFormField(
            controller: passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: inputDecoration.copyWith(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe sua senha';
              if (value.length < 6) return 'Mínimo de 6 caracteres';
              return null;
            },
          ),

          const SizedBox(height: 8),

          // Esqueci a senha
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onNavigateToForgotPassword,
              child: Text("Esqueceu a senha?"),
            ),
          ),

          const SizedBox(height: 24),

          // Botão de Login
          SizedBox(
            height: 50,
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onLogin(emailController.text.trim(), passwordController.text);
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

          const SizedBox(height: 8),

          // Mensagem de erro
          if (widget.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.errorMessage!,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Navegar para registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Não tem uma conta?", style: TextStyle(color: colorScheme.onSurfaceVariant)),
              TextButton(
                onPressed: widget.onNavigateToRegister,
                child: const Text("Criar conta", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}