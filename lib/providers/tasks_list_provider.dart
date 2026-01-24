import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/models/task/list/tasks_list_state.dart';

final TasksListProvider = StateNotifierProvider<TasksListNotifier, TasksListState>((ref) {
  return TasksListNotifier();
});

class TasksListNotifier extends StateNotifier<TasksListState>{
  TasksListNotifier() : super(TasksListState(filters: const TaskFilters()));


  void setFilters(TaskFilters filters) {
    state = TasksListState(
      filters: filters,
      sort: state.sort,
    );
  }

  void clearFilter(String key) {
    final f = state.filters;

    state = TasksListState(
      filters: TaskFilters(
        state: key == 'state' ? null : f.state,
        priority: key == 'priority' ? null : f.priority,
        assigneeId: key == 'assignee' ? null : f.assigneeId,
        tagId: key == 'tag' ? null : f.tagId,
        dueAfter: key == 'dueAfter' ? null : f.dueAfter,
        dueBefore: key == 'dueBefore' ? null : f.dueBefore,
        onlyNotClosed: key == 'onlyNotClosed' ? false : f.onlyNotClosed,
        onlyMine: key == 'onlyMine' ? false : f.onlyMine,
      ),
      sort: state.sort,
    );
  }

  void setSort(TaskSort? sort) {
    state = TasksListState(
      filters: state.filters,
      sort: sort,
    );
  }

  void clearAllFilters() {
    state = TasksListState(
      filters: const TaskFilters(),
      sort: state.sort,
    );
  }

}