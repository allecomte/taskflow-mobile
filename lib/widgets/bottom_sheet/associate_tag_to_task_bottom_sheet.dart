import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/models/task/task_detailed.dart';
import 'package:taskflow_mobile/services/api/data/tag_service.dart';
import 'package:taskflow_mobile/widgets/skeleton/line_skeleton.dart';

class AssociateTagToTaskBottomSheet extends StatefulWidget {
  final TaskDetailed taskDetail;
  const AssociateTagToTaskBottomSheet({super.key, required this.taskDetail});

  @override
  State<StatefulWidget> createState() => AssociateTagToTaskBottomSheetState();
}

class AssociateTagToTaskBottomSheetState
    extends State<AssociateTagToTaskBottomSheet> {
  LoadState tagsState = LoadState.loading;
  List<Tag> tagOptions = [];
  Tag? tagSelected;

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  Future<void> fetchTags() async {
    final tagService = TagService();
    try {
      final tags = await tagService.getTagsByProject(
        projectId: widget.taskDetail.project.id,
      );
      final tagIdsExcluded = widget.taskDetail.tags
          .map((tag) => tag.id)
          .toSet();
      final tagsAvailable = tags
          .where((tag) => !tagIdsExcluded.contains(tag.id))
          .toList();
      setState(() {
        tagOptions = tagsAvailable;
        tagsState = LoadState.success;
      });
    } catch (e) {
      setState(() {
        tagsState = LoadState.error;
      });
    }
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
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      FontAwesomeIcons.tag,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Associer un tag',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              tagsState == LoadState.loading
                  ? LineSkeleton(context: context)
                  : tagsState == LoadState.error
                  ? Text(
                      'Erreur lors du chargement des donnés',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : tagOptions.isEmpty
                  ? Text(
                      "Aucun tag disponible",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : DropdownButtonFormField<Tag>(
                    decoration: const InputDecoration(labelText: 'Tag'),
                      isExpanded: true,
                      items: tagOptions.map((tag) {
                        return DropdownMenuItem<Tag>(
                          value: tag,
                          child: Tooltip(
                            message: tag.name,
                            child: Text(
                              tag.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (tag) {
                        if (tag != null) {
                          setState(() {
                            tagSelected = tag;
                          });
                        }
                      },
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: tagSelected == null
                    ? null
                    : () => Navigator.pop(context, tagSelected),
                child: Text('Associer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
