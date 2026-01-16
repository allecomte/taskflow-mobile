import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/services/api/data/user_service.dart';

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<UserDetailed>>(
  UsersNotifier.new,
);

class UsersNotifier extends AsyncNotifier<List<UserDetailed>> {
  bool _isRefreshing = false;
  @override
  Future<List<UserDetailed>> build() async {
    final cached = state.valueOrNull;
    if (cached != null) {
      _refreshSilently();
      return cached;
    }

    final userService = UserService();
    return await userService.getUsers();
  }

  Future<void> _refreshSilently() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    try {
      final userService = UserService();
      final users = await userService.getUsers();
      if (users != state.value) {
        state = AsyncData(users);
      }
    } finally {
      _isRefreshing = false;
    }
  }
}
