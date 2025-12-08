import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_navigation_vm.g.dart';

@riverpod
class HomeNavigationVm extends _$HomeNavigationVm {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}