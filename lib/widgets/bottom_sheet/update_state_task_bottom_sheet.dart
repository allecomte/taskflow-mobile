import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/task_state.dart';

class UpdateStateTaskBottomSheet extends StatefulWidget{
  final TaskState state;
  const UpdateStateTaskBottomSheet({super.key, required this.state});

  @override
  State<StatefulWidget> createState() => UpdateStateTaskBottomSheetState();
}

class UpdateStateTaskBottomSheetState extends State<UpdateStateTaskBottomSheet>{
  late TaskState _stateSelected = widget.state;

  @override
  initState() {
    super.initState();
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
                      FontAwesomeIcons.pen,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Modifier l\'état de la tâche',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskState>(
                initialValue: _stateSelected,
                decoration: InputDecoration(
                  labelText: 'Priorité',
                ),
                items: TaskState.values.map((TaskState state) {
                  return DropdownMenuItem<TaskState>(
                    value: state,
                    child: Text(state.label),
                  );
                }).toList(),
                onChanged: (TaskState? newValue) {
                  setState(() {
                    _stateSelected = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _stateSelected),
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ],
              )
            ],
          ),
          ),
      )
      );
  }

}