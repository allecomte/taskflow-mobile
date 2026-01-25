class TaskFilters {
  final String? state;
  final String? priority;
  final DateTime? dueAfter;
  final DateTime? dueBefore;
  final String? assigneeId;
  final String? assigneeLabel;
  final String? tagId;
  final String? tagLabel;
  final bool onlyNotClosed;
  final bool onlyMine;

  const TaskFilters({
    this.state,
    this.priority,
    this.dueAfter,
    this.dueBefore,
    this.assigneeId,
    this.assigneeLabel, 
    this.tagId,
    this.tagLabel,
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
    String? assigneeLabel,
    bool tagIdSet = false, String? tagId,
    String? tagLabel,
    bool onlyNotClosedSet = false, bool? onlyNotClosed,
    bool onlyMineSet = false, bool? onlyMine,
  }) {
    return TaskFilters(
      state: stateSet ? state : this.state,
      priority: prioritySet ? priority : this.priority,
      dueAfter: dueAfterSet ? dueAfter : this.dueAfter,
      dueBefore: dueBeforeSet ? dueBefore : this.dueBefore,
      assigneeId: assigneeIdSet ? assigneeId : this.assigneeId,
      assigneeLabel: assigneeIdSet ? assigneeLabel : this.assigneeLabel,
      tagId: tagIdSet ? tagId : this.tagId,
      tagLabel: tagIdSet ? tagLabel : this.tagLabel,
      onlyNotClosed: onlyNotClosedSet ? onlyNotClosed! : this.onlyNotClosed,
      onlyMine: onlyMineSet ? onlyMine! : this.onlyMine,
    );
  }
}
