import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterForm extends StatefulWidget {
  final void Function(String name, String email, String password) onRegister;
  final void Function() onNavigateToLogin;
  final bool isLoading;

  const RegisterForm({
    Key? key,
    required this.onRegister,
    required this.onNavigateToLogin,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          // Campo Nome
          TextFormField(
            controller: nameController,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: inputDecoration.copyWith(
              labelText: 'Nome',
              hintText: 'Seu nome completo',
              prefixIcon: Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe seu nome';
              if (value.length < 2) return 'Nome muito curto';
              return null;
            },
          ),

          const SizedBox(height: 20),

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

          const SizedBox(height: 20),

          // Campo Confirmar Senha
          TextFormField(
            controller: confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: inputDecoration.copyWith(
              labelText: 'Confirmar Senha',
              prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Confirme sua senha';
              if (value != passwordController.text) return 'As senhas não coincidem';
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Botão de Registro
          SizedBox(
            height: 50,
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onRegister(
                          nameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Criar Conta',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 24),

          // Navegar para login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Já tem uma conta?", style: TextStyle(color: colorScheme.onSurfaceVariant)),
              TextButton(
                onPressed: widget.onNavigateToLogin,
                child: const Text("Fazer login", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}