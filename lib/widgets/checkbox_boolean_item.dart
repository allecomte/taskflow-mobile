import 'package:flutter/material.dart';

class CheckboxBooleanItem extends StatefulWidget {
  final bool? initialValue;
  final String label;
  final void Function(bool value) onChanged;
  final double textSize;
  final double spacing;

  const CheckboxBooleanItem({
    super.key,
    this.initialValue,
    required this.label,
    required this.onChanged,
    this.textSize = 16,
    this.spacing = 4,
  });

  @override
  State<StatefulWidget> createState() => CheckboxBooleanItemState();
}

class CheckboxBooleanItemState extends State<CheckboxBooleanItem> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: _value,
            onChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _value = newValue;
              });
              widget.onChanged(newValue);
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(width: widget.spacing),
          Flexible(
            child: Text(
              widget.label,
              style: TextStyle(fontSize: widget.textSize),
            ),
          ),
        ],
      );
  }
}
