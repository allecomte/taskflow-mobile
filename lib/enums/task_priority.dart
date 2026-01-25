import 'package:taskflow_mobile/models/select_item.dart';

enum TaskPriority implements SelectItem{ 
  low('LOW','Basse'),
  medium('MEDIUM','Moyenne'), 
  high ('HIGH','Haute');

  @override
  final String value;
  @override
  final String label;
  const TaskPriority(this.value, this.label);
  }
