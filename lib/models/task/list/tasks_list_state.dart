import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';

class TasksListState {
  final TaskFilters filters;
  final TaskSort? sort;

  TasksListState({
    required this.filters,
    this.sort,
  });
}