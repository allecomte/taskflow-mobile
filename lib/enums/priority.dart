enum Priority { 
  low('LOW','Basse'),
  medium('MEDIUM','Moyenne'), 
  high ('HIGH','Haute');

  final String value;
  final String label;
  const Priority(this.value, this.label);
  }
