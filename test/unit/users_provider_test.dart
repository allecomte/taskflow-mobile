import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/models/user/user_detailed.dart';
import 'package:taskflow_mobile/providers/users_provider.dart';

class FakeUsersNotifier extends UsersNotifier {
  final List<UserDetailed> _result;
  FakeUsersNotifier(this._result);

  @override
  Future<List<UserDetailed>> build() async {
    return _result;
  }
}

void main() {
  test('build returns users from fake notifier', () async {
    final users = [
      UserDetailed(id: '1', email: 'a@test', firstname: 'A', lastname: 'A'),
      UserDetailed(id: '2', email: 'b@test', firstname: 'B', lastname: 'B'),
    ];

    final container = ProviderContainer(overrides: [
      usersProvider.overrideWith(() => FakeUsersNotifier(users)),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(usersProvider.notifier);

    // trigger provider creation and await its result
    final res = await container.read(usersProvider.future);
    expect(res, users);

    // notifier state should now contain users
    expect(container.read(usersProvider), isA<AsyncData<List<UserDetailed>>>());
    expect(container.read(usersProvider).value, users);

    // updating notifier.state should be reflected
    final newUsers = [
      UserDetailed(id: '3', email: 'c@test', firstname: 'C', lastname: 'C'),
    ];
    notifier.state = AsyncData(newUsers);
    expect(container.read(usersProvider).value, newUsers);
  });
}
