import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:get_storage/get_storage.dart';

part 'onboarding_view_model.g.dart';

@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  int build() {
    return 0; // O estado inicial é a página 0
  }

  void updatePage(int index) {
    state = index;
  }

  // Lógica para salvar que o usuário já viu o onboarding
  Future<void> completeOnboarding() async {
    final box = GetStorage();
    await box.write('hasSeenOnboarding', true);
  }
}