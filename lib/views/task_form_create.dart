import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';

class TaskFormCreate extends StatefulWidget {
  final ProjectDetailed? project;
  const TaskFormCreate({super.key, this.project});

  @override
  State<StatefulWidget> createState() => TaskFormCreateState();
}

class TaskFormCreateState extends State<TaskFormCreate> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueAtController = TextEditingController();
  DateTime? _selectedDueAt;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // TODO associate to project if its passed in parameters
    // if(widget.project) 
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueAtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCurrentView(title: 'Création d\'une tâche'),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'task'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 30),
                      child: TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "Titre"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le titre de la tâche est obligatoire';
                            }
                            return null;
                          },
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print('ok');
                              }
                            },
                            child: _isProcessing
                                ? CircularProgressIndicator()
                                : Text('Valider'),
                          ),
                        ],
                      )
                  ],
                )
                )
            ]),
          ),
        ),
      ),
    );
  }
}
