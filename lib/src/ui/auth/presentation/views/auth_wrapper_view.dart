import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled/src/ui/auth/presentation/views/register_view.dart';
import '../viewmodels/auth_vm.dart';
import 'forgot_password_view.dart';
import 'login_view.dart';


enum AuthScreen { login, register, forgotPassword }

class AuthWrapperView extends ConsumerWidget {
  const AuthWrapperView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state changes to navigate after successful authentication
    ref.listen<AuthStatus>(authVmProvider, (previous, next) {
      if (previous != AuthStatus.authenticated && next == AuthStatus.authenticated) {
        // Navigate to home after successful authentication
        context.go('/home');
      }
    });

    return const _AuthWrapperViewContent();
  }
}

class _AuthWrapperViewContent extends ConsumerStatefulWidget {

  const _AuthWrapperViewContent();

  @override
  ConsumerState<_AuthWrapperViewContent> createState() => _AuthWrapperViewState();
}

class _AuthWrapperViewState extends ConsumerState<_AuthWrapperViewContent> {
  AuthScreen _currentScreen = AuthScreen.login;

  void _navigateTo(AuthScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_currentScreen) {
        AuthScreen.login => LoginView(
            onNavigateToRegister: () => _navigateTo(AuthScreen.register),
            onNavigateToForgotPassword: () => _navigateTo(AuthScreen.forgotPassword),
          ),
        AuthScreen.register => RegisterView(
            onNavigateToLogin: () => _navigateTo(AuthScreen.login),
          ),
        AuthScreen.forgotPassword => ForgotPasswordView(
            onNavigateToLogin: () => _navigateTo(AuthScreen.login),
          ),
      },
    );
  }
}