import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/enums/task_priority.dart';
import 'package:taskflow_mobile/enums/task_state.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/models/task/list/task_filters.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/providers/user_provider.dart';
import 'package:taskflow_mobile/widgets/custom_elevated_button.dart';
import 'package:taskflow_mobile/widgets/form/checkbox_boolean_item.dart';
import 'package:taskflow_mobile/widgets/date_picker_field.dart';
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
  String? _assigneeId;
  String? _assigneeLabel;
  String? _tagId;
  String? _tagLabel;
  bool _onlyNotClosed = true;
  bool _onlyMine = false;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(tasksListProvider).filters;
    _state = filters.state;
    _priority = filters.priority;
    _dueBefore = filters.dueBefore;
    _dueAfter = filters.dueAfter;
    _assigneeId = filters.assigneeId;
    _assigneeLabel = filters.assigneeLabel;
    _tagId = filters.tagId;
    _tagLabel = filters.tagLabel;
    _onlyNotClosed = filters.onlyNotClosed;
    _onlyMine = filters.onlyMine;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isUserManager = user!.roles.contains('ROLE_MANAGER');
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
                initialValue: _state != null
                    ? TaskState.values
                          .where((state) => state.value == _state)
                          .cast<TaskState?>()
                          .firstOrNull
                    : null,
                items: TaskState.values,
                onSelect: (priority) {
                  setState(() {
                    _state = priority.value;
                    _onlyNotClosed = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              SelectFromEnum<TaskPriority>(
                fieldLabel: 'Priorité',
                initialValue: _priority != null
                    ? TaskPriority.values
                          .where((p) => p.value == _priority)
                          .cast<TaskPriority?>()
                          .firstOrNull
                    : null,
                items: TaskPriority.values,
                onSelect: (priority) {
                  setState(() {
                    _priority = priority.value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DatePickerField(
                label: 'Échéance avant le',
                initialDate: _dueBefore,
                onDateSelected: (date) {
                  setState(() {
                    _dueBefore = date;
                  });
                },
              ),
              const SizedBox(height: 16),
              DatePickerField(
                label: 'Échéance après le',
                initialDate: _dueAfter,
                onDateSelected: (date) {
                  setState(() {
                    _dueAfter = date;
                  });
                },
              ),
              const SizedBox(height: 16),
              SelectTags(
                initialValue: _tagId,
                onSelected: (tag) {
                  setState(() {
                    _tagId = tag.id;
                    _tagLabel = tag.name;
                  });
                },
              ),
              if (isUserManager) ...[
                const SizedBox(height: 16),
                SelectUsers(
                  userIdsToExclude: [],
                  initialValue: _assigneeId,
                  onSelected: (user) => {
                    setState(() {
                      _assigneeId = user.id;
                      _assigneeLabel = '${user.firstname} ${user.lastname}';
                      _onlyMine = false;
                    }),
                  },
                ),
              ],
              const SizedBox(height: 20),
              CheckboxBooleanItem(
                initialValue: _onlyNotClosed,
                enabled: _state == null,
                label: 'Afficher uniquement les tâches non clôturées',
                onChanged: (value) {
                  setState(() {
                    _onlyNotClosed = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxBooleanItem(
                initialValue: _onlyMine,
                enabled: _assigneeId == null,
                label: 'Afficher uniquement mes tâches',
                onChanged: (value) {
                  setState(() {
                    _onlyMine = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: const Text('Annuler'),
                        ),
                        const SizedBox(width: 12),
                        CustomElevatedButton(
                          label: 'Appliquer',
                          onPressed: () {
                            Navigator.pop(
                              context,
                              TaskFilters(
                                state: _state,
                                priority: _priority,
                                dueAfter: _dueAfter,
                                dueBefore: _dueBefore,
                                assigneeId: _assigneeId,
                                assigneeLabel: _assigneeLabel,
                                tagId: _tagId,
                                tagLabel: _tagLabel,
                                onlyNotClosed: _onlyNotClosed,
                                onlyMine: _onlyMine,
                              ),
                            );
                          },
                        ),
                      ],
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
