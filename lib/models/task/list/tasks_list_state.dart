import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';

class TasksListState {
  final LoadState state;
  final List<TaskLight> tasks;
  final TaskFilters filters;
  final TaskSort sort;

  TasksListState({
    required this.state,
    required this.tasks,
    required this.filters,
    required this.sort,
  });

  factory TasksListState.initial() => TasksListState(
    state: LoadState.loading,
    tasks: const [],
    filters: TaskFilters(),
    sort: TaskSort.defaultSort,
  );

  TasksListState copyWith({
    LoadState? state,
    List<TaskLight>? tasks,
    TaskFilters? filters,
    TaskSort? sort,
  }) {
    return TasksListState(
      state: state ?? this.state,
      tasks: tasks ?? this.tasks,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
    );
  }
}
