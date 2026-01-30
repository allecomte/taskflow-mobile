import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/services/api/data/project_service.dart';

final projectServiceProvider = Provider<ProjectService>((ref) => ProjectService());