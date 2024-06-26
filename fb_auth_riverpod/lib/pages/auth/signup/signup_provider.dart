import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.g.dart';

@riverpod
class Signup extends _$Signup {
  Object? _key;
  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() {
      print('[signupProvider] disposed');
      _key = null;
    });
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final key = _key;
    final newState = await AsyncValue.guard<void>(
      () => ref
          .read(authRepositoryProvider)
          .signup(name: name, email: email, password: password),
    );

    // provider가 dispose 되지 않은 경우에만 state를 업데이트 한다.
    if (key == _key) {
      state = newState;
    }
  }
}
