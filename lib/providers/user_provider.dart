import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/user/user_light.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserLight?>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<UserLight?> {
  UserNotifier() : super(null);

  void setUser(UserLight user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}
