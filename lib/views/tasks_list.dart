import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/utils/task_filters.dart';
import 'package:taskflow_mobile/views/task_form.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/filter_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/bottom_sheet/sort_task_bottom_sheet.dart';
import 'package:taskflow_mobile/widgets/card_task.dart';
import 'package:taskflow_mobile/widgets/skeleton/list_skeleton.dart';

class TasksList extends ConsumerWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksList = ref.watch(tasksListProvider);
    final user = ref.watch(userProvider);
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
    final filters = ref.watch(tasksListProvider).filters;
    final activeFilters = getActiveFilters(filters);

    Future<void> onFiltersPressed() async {
    final filters = await showModalBottomSheet<TaskFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterTaskBottomSheet(),
    );
    if(filters != null){
      ref.read(tasksListProvider.notifier).setFilters(filters);
    }
  }

  Future<void> onSortPressed() async {
    final sort = await showModalBottomSheet<TaskSort>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SortTaskBottomSheet(),
    );
    if(sort != null){
      ref.read(tasksListProvider.notifier).setSort(sort);
    }
  }

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
          onRefresh: () async {
            await ref.read(tasksListProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // FILTER & SORT BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: onFiltersPressed,
                        icon: Icon(
                          FontAwesomeIcons.filter,
                          size: 16,
                        ),
                        label: Text('Filtrer'),
                      ),
                      ElevatedButton.icon(
                        onPressed: onSortPressed,
                        icon: Icon(
                          FontAwesomeIcons.sort,
                          size: 16,
                        ),
                        label: Text('Trier'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // CLEAR FILTERS BUTTON
                  if (filters.state != null ||
                      filters.priority != null ||
                      filters.assigneeId != null ||
                      filters.tagId != null ||
                      filters.dueAfter != null ||
                      filters.dueBefore != null ||
                      filters.onlyNotClosed ||
                      filters.onlyMine)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          ref
                              .read(tasksListProvider.notifier)
                              .clearAllFilters();
                        },
                        icon: Icon(
                          FontAwesomeIcons.xmark,
                          size: 16,
                        ),
                        label: Text('Effacer les filtres'),
                      ),
                    ),
                    // FILTERS SELECTED
                    if(filters.hasFilters)
                    SizedBox(height: 40, child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeFilters.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context,index){
                        final filter = activeFilters[index];
                        return FilterChip(
                          label: Text(filter.label), 
                          onSelected: (_){},
                          onDeleted: (){
                            ref.read(tasksListProvider.notifier).removeOneFilter(filter.key);
                          },
                          );
                      }, 
                      ),),
                  const SizedBox(height: 16),
                  tasksList.state == LoadState.loading
                  ? ListSkeleton(itemCount: 10)
                  : tasksList.state == LoadState.error
                  ? Text(
                      'Erreur lors du chargement des tâches',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : tasksList.tasks.isEmpty
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
                          CardTask(task: tasksList.tasks[index])),
                      itemCount: tasksList.tasks.length,
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
