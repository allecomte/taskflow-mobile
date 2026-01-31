import 'package:flutter/material.dart';

class CheckboxBooleanItem extends StatefulWidget {
  final bool? initialValue;
  final String label;
  final void Function(bool value) onChanged;
  final double textSize;
  final double spacing;
  final bool enabled;

  const CheckboxBooleanItem({
    super.key,
    this.initialValue,
    required this.label,
    required this.onChanged,
    this.textSize = 16,
    this.spacing = 4,
    this.enabled = true,
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
            value: widget.enabled ? _value : false,
            onChanged: widget.enabled ? (newValue) {
              if (newValue == null) return;
              setState(() {
                _value = newValue;
              });
              widget.onChanged(newValue);
            } : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(width: widget.spacing),
          Flexible(
            child: Text(
              widget.label,
              style: TextStyle(fontSize: widget.textSize, color: widget.enabled ? null : Theme.of(context).disabledColor),
            ),
          ),
        ],
      );
  }
}
