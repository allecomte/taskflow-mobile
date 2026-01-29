import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/user/user_light.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/auth_api.dart';
import 'package:taskflow_mobile/services/api/api_exception.dart';
import 'package:taskflow_mobile/services/api/data/user_service.dart';
import 'package:taskflow_mobile/services/storage/secure_storage.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(
  () => AuthNotifier(),
);

class AuthNotifier extends AsyncNotifier<String?> {
  late final Ref _ref;
  final _authApi = AuthApi();

  @override
  Future<String?> build() async {
    _ref = ref;
    final token = await SecureStorage.getToken();
    if (token != null) {
      print('TOKEN FOUND IN STORAGE: $token');
      final userService = UserService();
      final user = await userService.getUserProfile();
      _ref.read(userProvider.notifier).setUser(user);
    }
    return token;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final result = await _authApi.login(email: email, password: password);

      await SecureStorage.saveToken(result['token']);

      final userJson = result['user'] as Map<String, dynamic>;
      final user = UserLight(
        id: userJson['_id'] as String,
        firstname: userJson['firstname'] as String,
        lastname: userJson['lastname'] as String,
        email: userJson['email'] as String,
        roles: List<String>.from(userJson['roles'] ?? []),
        projectsOwned: List<String>.from(userJson['projectsOwned'] ?? []),
      );

      _ref.read(userProvider.notifier).setUser(user);

      state = AsyncData(result['token']);
    } on ApiException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    }
  }

  Future<void> register({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try{
      final result = await _authApi.register(firstname: firstname, lastname: lastname, email: email, password: password);
      await SecureStorage.saveToken(result['token']);

      final userJson = result['user'] as Map<String, dynamic>;

      final user = UserLight(
        id: userJson['_id'] as String,
        firstname: userJson['firstname'] as String,
        lastname: userJson['lastname'] as String,
        email: userJson['email'] as String,
        roles: List<String>.from(userJson['roles'] ?? []),
        projectsOwned: List<String>.from([]),
      );

      _ref.read(userProvider.notifier).setUser(user);

      state = AsyncData(result['token']);
    } on ApiException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    _ref.read(userProvider.notifier).clearUser();
    state = const AsyncData(null);
  }
}
