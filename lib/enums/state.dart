enum State { 
  open('OPEN','Ouvert'),
  inProgress('IN_PROGRESS','En cours'), 
  closed ('CLOSED','Fermé');

  final String value;
  final String label;
  const State(this.value, this.label);
  }


  