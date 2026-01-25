import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/main.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/models/task/task_light.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/services/api/data/task_service.dart';
import 'package:taskflow_mobile/views/task_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/filter_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/sort_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/card_task.dart';
import 'package:taskflow_mobile/widgets/skeleton/list_skeleton.dart';

class TasksList extends ConsumerStatefulWidget {
  const TasksList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TasksListState();
}

class TasksListState extends ConsumerState<TasksList> with RouteAware {
  LoadState tasksState = LoadState.loading;
  List<TaskLight> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // unsubscribe from route changes
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped back to
    refreshTasks();
  }

  Future<void> fetchTasks() async {
    final taskService = TaskService();
    try {
      final dataTasks = await taskService.getTasks();
      setState(() {
        tasks = dataTasks.data;
        tasksState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        tasksState = LoadState.error;
      });
    }
  }

  Future<void> refreshTasks() async {
    setState(() {
      tasksState = LoadState.loading;
    });
    await fetchTasks();
  }

  Future<void> _onFiltersPressed() async {
    final filters = await showModalBottomSheet<TaskFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterTaskBottomSheet(),
    );
    if(filters != null){
      ref.read(TasksListProvider.notifier).setFilters(filters);
    }
  }

  Future<void> _onSortPressed() async {
    final sort = await showModalBottomSheet<TaskSort>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SortTaskBottomSheet(),
    );
    if(sort != null){
      ref.read(TasksListProvider.notifier).setSort(sort);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
    final filters = ref.watch(TasksListProvider).filters;
    return Scaffold(
      appBar: AppBarCurrentView(
        title: 'Mes tâches',
        actions: isUserManager
            ? [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskForm(),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.circlePlus,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ]
            : [],
      ),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'task'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshTasks,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _onFiltersPressed,
                        icon: Icon(
                          FontAwesomeIcons.filter,
                          size: 16,
                        ),
                        label: Text('Filtrer'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _onSortPressed,
                        icon: Icon(
                          FontAwesomeIcons.sort,
                          size: 16,
                        ),
                        label: Text('Trier'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  tasksState == LoadState.loading
                  ? ListSkeleton(itemCount: 10)
                  : tasksState == LoadState.error
                  ? Text(
                      'Erreur lors du chargement des tâches',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : tasks.isEmpty
                  ? Text(
                      "Vous n'avez à aucune tâche",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) =>
                          CardTask(task: tasks[index])),
                      itemCount: tasks.length,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
