import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/enums/task_priority.dart';
import 'package:taskflow_mobile/enums/task_state.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/models/user/user.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/widgets/select_from_enum.dart';
import 'package:taskflow_mobile/widgets/select_tags.dart';
import 'package:taskflow_mobile/widgets/select_users.dart';

class FilterTaskBottomSheet extends ConsumerStatefulWidget {
  const FilterTaskBottomSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FilterTaskBottomSheetState();
}

class FilterTaskBottomSheetState extends ConsumerState<FilterTaskBottomSheet> {
  LoadState tagsState = LoadState.loading;
  List<Tag> tags = [];
  String? _state;
  String? _priority;
  DateTime? _dueAfter;
  DateTime? _dueBefore;
  String? assigneeId;
  String? _tagId;
  bool _onlyNotClosed = true;
  bool _onlyMine = false;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(TasksListProvider).filters;
    _state = filters.state;
    _priority = filters.priority;
    _dueAfter = filters.dueAfter;
    _dueBefore = filters.dueBefore;
    assigneeId = filters.assigneeId;
    _tagId = filters.tagId;
    _onlyNotClosed = filters.onlyNotClosed;
    _onlyMine = filters.onlyMine;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 14,
            bottom: 14,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesomeIcons.filter,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Filtrer la liste de tâches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SelectFromEnum<TaskState>(
                fieldLabel: 'État',
                initialValue: _state != null ? TaskState.values.where((state) => state.value == _state).cast<TaskState?>().firstOrNull : null,
                items: TaskState.values, 
                onSelect: (priority) {
                  setState(() {
                    _state = priority.value;
                  });
                },
                ),
              const SizedBox(height: 16),
              SelectFromEnum<TaskPriority>(
                fieldLabel: 'Priorité',
                initialValue: _priority != null ? TaskPriority.values.where((p) => p.value == _priority).cast<TaskPriority?>().firstOrNull : null,
                items: TaskPriority.values, 
                onSelect: (priority) {
                  setState(() {
                    _priority = priority.value;
                  });
                },
                ),
              const SizedBox(height: 16),
              SelectTags(
                onSelected: (tag) {
                  setState(() {
                    _tagId = tag.id;
                  });
                },
              ),
              const SizedBox(height: 16),
              SelectUsers(
                userIdsToExclude: [],
                onSelected: (user) => {
                  setState(() {
                    assigneeId = user.id;
                  }),
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //     Expanded(
                  //   child: OutlinedButton(
                  //     onPressed: () => Navigator.pop(context, false),
                  //     style: OutlinedButton.styleFrom(
                  //       side: BorderSide(
                  //         color: Theme.of(context).colorScheme.primary
                  //       )
                  //     ),
                  //     child: const Text('Annuler'),
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Theme.of(
                  //             context,
                  //           ).colorScheme.secondary,
                  //         ),
                  //         onPressed: () {},
                  //         child: Text('Appliquer',style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                  //       ),
                  // )
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          TaskFilters(
                            state: _state,
                            priority: _priority,
                            dueAfter: _dueAfter,
                            dueBefore: _dueBefore,
                            assigneeId: assigneeId,
                            tagId: _tagId,
                            onlyNotClosed: _onlyNotClosed,
                            onlyMine: _onlyMine,
                          ),
                        );
                      },
                      child: Text(
                        'Appliquer',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
