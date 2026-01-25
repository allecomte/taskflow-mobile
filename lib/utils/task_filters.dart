import 'package:taskflow_mobile/enums/task_priority.dart';
import 'package:taskflow_mobile/enums/task_state.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/utils/format_date.dart';

class ActiveFilter {
  final String key;
  final String label;
  ActiveFilter({required this.key, required this.label});
}

List<ActiveFilter> getActiveFilters(TaskFilters filters) {
  final active = <ActiveFilter>[];

  if (filters.state != null && filters.state!.isNotEmpty) {
    active.add(ActiveFilter(key: 'state', label: 'État : ${TaskState.values.firstWhere((e) => e.value == filters.state).label}'));
  }
  if (filters.priority != null && filters.priority!.isNotEmpty) {
    active.add(ActiveFilter(key: 'priority', label: 'Priorité : ${TaskPriority.values.firstWhere((e) => e.value == filters.priority).label}'));
  }
  if (filters.tagId != null && filters.tagId!.isNotEmpty) {
    active.add(ActiveFilter(key: 'tag', label: 'Tag : ${filters.tagId}'));
  }
  if (filters.assigneeId != null && filters.assigneeId!.isNotEmpty) {
    active.add(ActiveFilter(key: 'assignee', label: 'Assignée à : ${filters.assigneeId}'));
  }
  if (filters.dueBefore != null) {
    active.add(ActiveFilter(key: 'dueBefore', label: 'Avant : ${formatDateTimeToString(filters.dueBefore!)}'));
  }
  if (filters.dueAfter != null) {
    active.add(ActiveFilter(key: 'dueAfter', label: 'Après : ${formatDateTimeToString(filters.dueAfter!)}'));
  }
  if (filters.onlyNotClosed) {
    active.add(ActiveFilter(key: 'onlyNotClosed', label: 'Uniquement non clôturées'));
  }
  if (filters.onlyMine) {
    active.add(ActiveFilter(key: 'onlyMine', label: 'Uniquement mes tâches'));
  }

  return active;
}