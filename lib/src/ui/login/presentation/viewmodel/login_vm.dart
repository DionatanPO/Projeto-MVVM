import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/login_repository.dart';
import '../../domain/login_result.dart';
import '../../data/login_repository_impl.dart';

part 'login_vm.g.dart';

/// Provider simples para o repositório (pode ser trocado por injeção real depois)
final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepositoryImpl();
});

@riverpod
class LoginVm extends _$LoginVm {
  @override
  AsyncValue<LoginResult?> build() {
    // Estado inicial: nenhum resultado ainda
    return const AsyncValue.data(null);
  }

  Future<void> submit(String email, String password) async {
    state = const AsyncLoading();
    final repo = ref.read(loginRepositoryProvider);

    final result = await AsyncValue.guard(() {
      return repo.login(email: email, password: password);
    });

    state = result;
  }
}
