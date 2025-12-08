import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/auth_vm.dart';


// Global auth state provider that can be accessed from anywhere in the app
final globalAuthProvider = Provider<GlobalAuth>((ref) {
  return GlobalAuth(ref);
});

class GlobalAuth {
  final Ref _ref;

  GlobalAuth(this._ref);

  AuthStatus get authStatus => _ref.read(authVmProvider);

  bool get isAuthenticated => _ref.read(authVmProvider) == AuthStatus.authenticated;

  void performLogin(String email, String password) {
    _ref.read(authVmProvider.notifier).login(email, password);
  }

  void performRegister(String name, String email, String password) {
    _ref.read(authVmProvider.notifier).register(name: name, email: email, password: password);
  }

  void performForgotPassword(String email) {
    _ref.read(authVmProvider.notifier).forgotPassword(email);
  }

  void performLogout() {
    _ref.read(authVmProvider.notifier).logout();
  }
}