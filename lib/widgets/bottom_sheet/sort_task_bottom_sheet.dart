import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/models/task/list/task_sort.dart';
import 'package:taskflow_mobile/providers/tasks_list_provider.dart';
import 'package:taskflow_mobile/widgets/custom_elevated_button.dart';

class SortTaskBottomSheet extends ConsumerStatefulWidget {
  const SortTaskBottomSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SortTaskBottomSheetState();
}

class SortTaskBottomSheetState extends ConsumerState<SortTaskBottomSheet> {
  late TaskSortField _field;
  late bool _ascending;

  @override
  void initState() {
    super.initState();
    final sort = ref.read(tasksListProvider).sort;
    _field = sort.field;
    _ascending = sort.ascending;
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
                      FontAwesomeIcons.sort,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Trier la liste de tâches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskSortField>(
                initialValue: _field,
                decoration: const InputDecoration(labelText: 'Champ'),
                items: TaskSortField.values.map((field) {
                  return DropdownMenuItem(
                    value: field,
                    child: Text(TaskSort(field: field, ascending: true).label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _field = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                initialValue: _ascending,
                decoration: const InputDecoration(labelText: 'Ordre'),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Croissant')),
                  DropdownMenuItem(value: false, child: Text('Décroissant')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _ascending = value);
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
                        CustomElevatedButton(label: 'Appliquer', onPressed: () {
                            Navigator.pop(context,
                                TaskSort(field: _field, ascending: _ascending));
                          })
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
