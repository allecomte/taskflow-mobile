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

  TaskFilters copyWith({
    bool stateSet = false, String? state,
    bool prioritySet = false, String? priority,
    bool dueAfterSet = false, DateTime? dueAfter,
    bool dueBeforeSet = false, DateTime? dueBefore,
    bool assigneeIdSet = false, String? assigneeId,
    bool tagIdSet = false, String? tagId,
    bool onlyNotClosedSet = false, bool? onlyNotClosed,
    bool onlyMineSet = false, bool? onlyMine,
  }) {
    return TaskFilters(
      state: stateSet ? state : this.state,
      priority: prioritySet ? priority : this.priority,
      dueAfter: dueAfterSet ? dueAfter : this.dueAfter,
      dueBefore: dueBeforeSet ? dueBefore : this.dueBefore,
      assigneeId: assigneeIdSet ? assigneeId : this.assigneeId,
      tagId: tagIdSet ? tagId : this.tagId,
      onlyNotClosed: onlyNotClosedSet ? onlyNotClosed! : this.onlyNotClosed,
      onlyMine: onlyMineSet ? onlyMine! : this.onlyMine,
    );
  }
}
