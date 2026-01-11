import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/project/project_detailed.dart';
import 'package:taskflow_mobile/widgets/app_bar_current_view.dart';
import 'package:taskflow_mobile/widgets/bottom_app_bar_menu.dart';
import 'package:taskflow_mobile/utils/format_date.dart';

class ProjectFormUpdate extends StatefulWidget {
  final ProjectDetailed project;

  const ProjectFormUpdate({super.key, required this.project});

  @override
  State<StatefulWidget> createState() => ProjectFormUpdateState();
}

class ProjectFormUpdateState extends State<ProjectFormUpdate> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startAtController;
  DateTime? _selectedStartAt;
  late final TextEditingController _endAtController;
  DateTime? _selectedEndAt;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
    _startAtController = TextEditingController(
      text: formatDateFr(widget.project.startAt),
    );
    _selectedStartAt = DateTime.parse(widget.project.startAt);
    if (widget.project.endAt != null) {
      _endAtController = TextEditingController(
        text: formatDateFr(widget.project.endAt!),
      );
      _selectedEndAt = DateTime.parse(widget.project.endAt!);
    } else {
      _endAtController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCurrentView(title: widget.project.title),
      bottomNavigationBar: BottomAppBarMenu(currentView: 'project'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
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
                              return 'Le titre du projet est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La description du projet est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _startAtController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date de début',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await pickDate(
                              context: context,
                              initialDate: _selectedStartAt,
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedStartAt = pickedDate;
                                _startAtController.text =
                                    formatDateTimeToString(pickedDate);
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La date de début est obligatoire';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 30),
                        child: TextFormField(
                          controller: _endAtController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date de fin',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await pickDate(
                              context: context,
                              initialDate: _selectedEndAt,
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _selectedEndAt = pickedDate;
                                _endAtController.text = formatDateTimeToString(
                                  pickedDate,
                                );
                              });
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: (){}, child: Text('Valider'))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
