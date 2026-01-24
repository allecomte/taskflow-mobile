class TaskFilters {
  final String? state;
  final String? priority;
   final DateTime? dueAfter;
  final DateTime? dueBefore;
  final String? assigneeId;
  final String? tagId;
  final bool onlyNotClosed;
  final bool onlyMine;
  
  const TaskFilters({
    this.state,
    this.priority,
    this.dueAfter,
    this.dueBefore,
    this.assigneeId,
    this.tagId,
    this.onlyNotClosed = true,
    this.onlyMine = false,
  });

  bool get hasFilters {
    return state != null ||
        priority != null ||
        dueAfter != null ||
        dueBefore != null ||
        assigneeId != null ||
        tagId != null ||
        onlyNotClosed ||
        onlyMine;
  }
}