enum TaskState { 
  open('OPEN','Ouvert'),
  inProgress('IN_PROGRESS','En cours'), 
  closed ('CLOSED','Fermé');

  final String value;
  final String label;
  const TaskState(this.value, this.label);
  }


  