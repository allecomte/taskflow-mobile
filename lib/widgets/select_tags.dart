import 'package:flutter/material.dart';
import 'package:taskflow_mobile/enums/load_state.dart';
import 'package:taskflow_mobile/models/tag/tag.dart';
import 'package:taskflow_mobile/services/api/data/tag_service.dart';
import 'package:taskflow_mobile/widgets/skeleton/line_skeleton.dart';

class SelectTags extends StatefulWidget {
  final String? initialValue;
  final void Function(Tag tag) onSelected;
  const SelectTags({super.key, required this.onSelected, this.initialValue});

  @override
  State<StatefulWidget> createState() => SelectTagsState();
}

class SelectTagsState extends State<SelectTags> {
  LoadState tagsState = LoadState.loading;
  List<Tag> tagOptions = [];
  Tag? _tagSelected;

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  Future<void> fetchTags() async {
    final tagService = TagService();
    try {
      final tags = await tagService.getTags();
      setState(() {
        tagOptions = tags;
        if (widget.initialValue != null) {
          _tagSelected = tags.firstWhere(
              (tag) => tag.id == widget.initialValue,
            );
        }
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
    if (tagsState == LoadState.loading) {
      return LineSkeleton(context: context);
    } else if (tagsState == LoadState.error) {
      return Text(
        'Erreur lors du chargement des tags',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    } else {
      return DropdownButtonFormField<Tag>(
        decoration: const InputDecoration(labelText: 'Tag'),
        initialValue: _tagSelected,
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
            setState(() => _tagSelected = tag);
            widget.onSelected(tag);
          }
        },
      );
    }
  }
}
