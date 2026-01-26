import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/models/task/list/tasks_list_state.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';

final tasksListProvider =
    StateNotifierProvider<TasksListNotifier, TasksListState>(
      (ref) => TasksListNotifier(),
    );

class TasksListNotifier extends StateNotifier<TasksListState> {
  TasksListNotifier() : super(TasksListState.initial()) {
    fetchTasks();
  }

  final _taskService = TaskService();

  Future<void> fetchTasks() async {
    state = state.copyWith(state: LoadState.loading);
    try {
      final response = await _taskService.getTasks(
        pagination: false,
        notClosed: state.filters.onlyNotClosed,
        sort: state.sort.apiValue.isNotEmpty ? state.sort.apiValue : null,
        state: state.filters.state,
        priority: state.filters.priority,
        tag: state.filters.tagId,
        assignee: state.filters.assigneeId,
        dueBefore: state.filters.dueBefore?.toIso8601String(),
        dueAfter: state.filters.dueAfter?.toIso8601String(),
      );
      state = state.copyWith(state: LoadState.success, tasks: response.data);
    } catch (e) {
      state = state.copyWith(state: LoadState.error);
    }
  }

  Future<void> refresh() async {
    await fetchTasks();
  }

  void setFilters(TaskFilters filters) {
    state = state.copyWith(filters: filters);
    fetchTasks();
  }

  void removeOneFilter(String key) {
    final f = state.filters;

    switch (key) {
      case 'state':
        state = state.copyWith(
          filters: f.copyWith(stateSet: true, state: null),
        );
        break;
      case 'priority':
        state = state.copyWith(
          filters: f.copyWith(prioritySet: true, priority: null),
        );
        break;
      case 'assignee':
        state = state.copyWith(
          filters: f.copyWith(assigneeIdSet: true, assigneeId: null),
        );
        break;
      case 'tag':
        state = state.copyWith(
          filters: f.copyWith(tagIdSet: true, tagId: null),
        );
        break;
      case 'dueAfter':
        state = state.copyWith(
          filters: f.copyWith(dueAfterSet: true, dueAfter: null),
        );
        break;
      case 'dueBefore':
        state = state.copyWith(
          filters: f.copyWith(dueBeforeSet: true, dueBefore: null),
        );
        break;
      case 'onlyNotClosed':
        state = state.copyWith(
          filters: f.copyWith(onlyNotClosedSet: true, onlyNotClosed: false),
        );
        break;
      case 'onlyMine':
        state = state.copyWith(
          filters: f.copyWith(onlyMineSet: true, onlyMine: false),
        );
        break;
    }
    fetchTasks();
  }

  void clearAllFilters() {
    state = state.copyWith(filters: const TaskFilters(onlyNotClosed: false));
    fetchTasks();
  }

  void setSort(TaskSort sort) {
    state = state.copyWith(sort: sort);
    fetchTasks();
  }
  void resetSort() {
    state = state.copyWith(sort: TaskSort.defaultSort);
    fetchTasks();
  }
}
