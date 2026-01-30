import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_mobile/models/user/user_light.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';

void main() {
  test('setUser', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final user = UserLight(
      id: '1',
      email: 'jdoe@test.com',
      firstname: 'John',
      lastname: 'Doe',
    );
    container.read(userProvider.notifier).setUser(user);
    expect(container.read(userProvider), user);
  });
}
