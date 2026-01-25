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
    this.state = LoadState.loading, 
    this.tasks = const [],
    this.filters = const TaskFilters(),
    this.sort = const TaskSort(), 
  });

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