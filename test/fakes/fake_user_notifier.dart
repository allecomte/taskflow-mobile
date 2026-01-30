import 'package:taskflow_mobile/models/user/user_light.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';

class FakeUserNotifier extends UserNotifier {
  FakeUserNotifier(UserLight user) {
    state = user;
  }
}
