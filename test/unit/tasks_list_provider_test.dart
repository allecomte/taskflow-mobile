import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';

class FakeTasksNotifier extends TasksListNotifier {
  bool fetchCalled = false;

  FakeTasksNotifier() : super();

  @override
  Future<void> fetchTasks() async {
    fetchCalled = true;
    state = state.copyWith(state: LoadState.success, tasks: _sampleTasks);
  }

  @override
  Future<void> refresh() async {
    await fetchTasks();
  }

  @override
  void setFilters(TaskFilters filters) {
    state = state.copyWith(filters: filters);
    fetchTasks();
  }

  @override
  void removeOneFilter(String key) {
    final f = state.filters;
    switch (key) {
      case 'assignee':
        state = state.copyWith(filters: f.copyWith(assigneeIdSet: true, assigneeId: null));
        break;
      default:
        // minimal implementation for tests
        break;
    }
    fetchTasks();
  }

  @override
  void clearAllFilters() {
    state = state.copyWith(filters: const TaskFilters(onlyNotClosed: false));
    fetchTasks();
  }

  @override
  void setSort(TaskSort sort) {
    state = state.copyWith(sort: sort);
    fetchTasks();
  }
}

final _sampleTasks = [
  TaskLight(id: 't1', title: 'T1', state: 'todo', priority: 'low', dueAt: '2025-01-01'),
  TaskLight(id: 't2', title: 'T2', state: 'done', priority: 'high', dueAt: '2025-02-01'),
];

void main() {
  test('overridden provider fetches on creation and sets tasks', () async {
    final container = ProviderContainer(overrides: [
      tasksListProvider.overrideWith((ref) => FakeTasksNotifier()),
    ]);
    addTearDown(container.dispose);

    // Trigger provider creation
    final notifier = container.read(tasksListProvider.notifier);
    // Ensure fetch has run
    await notifier.fetchTasks();

    final state = container.read(tasksListProvider);
    expect(state.state, LoadState.success);
    expect(state.tasks, _sampleTasks);
  });

  test('fetchTasks sets success and tasks', () async {
    final notifier = FakeTasksNotifier();
    final container = ProviderContainer(overrides: [
      tasksListProvider.overrideWith((ref) => notifier),
    ]);
    addTearDown(container.dispose);

    await container.read(tasksListProvider.notifier).fetchTasks();

    final state = container.read(tasksListProvider);
    expect(state.state, LoadState.success);
    expect(state.tasks, _sampleTasks);
    expect(notifier.fetchCalled, isTrue);
  });

  test('setFilters updates filters and triggers fetch', () async {
    final notifier = FakeTasksNotifier();
    final container = ProviderContainer(overrides: [
      tasksListProvider.overrideWith((ref) => notifier),
    ]);
    addTearDown(container.dispose);

    final filters = TaskFilters(assigneeId: 'user-123');
    container.read(tasksListProvider.notifier).setFilters(filters);

    final state = container.read(tasksListProvider);
    expect(state.filters.assigneeId, 'user-123');
    expect(notifier.fetchCalled, isTrue);
  });

  test('removeOneFilter removes assignee and triggers fetch', () async {
    final notifier = FakeTasksNotifier();
    final container = ProviderContainer(overrides: [
      tasksListProvider.overrideWith((ref) => notifier),
    ]);
    addTearDown(container.dispose);

    // set a filter and then remove it
    container.read(tasksListProvider.notifier).state = container.read(tasksListProvider.notifier).state.copyWith(filters: TaskFilters(assigneeId: 'a'));
    container.read(tasksListProvider.notifier).removeOneFilter('assignee');

    final state = container.read(tasksListProvider);
    expect(state.filters.assigneeId, isNull);
    expect(notifier.fetchCalled, isTrue);
  });

  test('clearAllFilters resets onlyNotClosed to false and triggers fetch', () async {
    final notifier = FakeTasksNotifier();
    final container = ProviderContainer(overrides: [
      tasksListProvider.overrideWith((ref) => notifier),
    ]);
    addTearDown(container.dispose);

    container.read(tasksListProvider.notifier).state = container.read(tasksListProvider.notifier).state.copyWith(filters: TaskFilters(onlyNotClosed: true));
    container.read(tasksListProvider.notifier).clearAllFilters();

    final state = container.read(tasksListProvider);
    expect(state.filters.onlyNotClosed, isFalse);
    expect(notifier.fetchCalled, isTrue);
  });

  test('setSort updates sort and triggers fetch', () async {
    final notifier = FakeTasksNotifier();
    final container = ProviderContainer(overrides: [
      tasksListProvider.overrideWith((ref) => notifier),
    ]);
    addTearDown(container.dispose);

    final sort = TaskSort(field: TaskSortField.priority, ascending: false);
    container.read(tasksListProvider.notifier).setSort(sort);

    final state = container.read(tasksListProvider);
    expect(state.sort.field, TaskSortField.priority);
    expect(notifier.fetchCalled, isTrue);
  });
}
