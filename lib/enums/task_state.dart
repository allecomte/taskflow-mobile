import 'package:taskflow_mobile/models/select_item.dart';

enum TaskState  implements SelectItem{ 
  open('OPEN','Ouvert'),
  inProgress('IN_PROGRESS','En cours'), 
  closed ('CLOSED','Fermé');

  @override
  final String value;
  @override
  final String label;
  const TaskState(this.value, this.label);
  }


  