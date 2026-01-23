enum TaskPriority { 
  low('LOW','Basse'),
  medium('MEDIUM','Moyenne'), 
  high ('HIGH','Haute');

  final String value;
  final String label;
  const TaskPriority(this.value, this.label);
  }
