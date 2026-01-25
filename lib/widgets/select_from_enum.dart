import 'package:flutter/material.dart';
import 'package:taskflow_mobile/models/select_item.dart';

class SelectFromEnum<T extends SelectItem> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final void Function(T value) onSelect;
  final String? fieldLabel;
  const SelectFromEnum({super.key, required this.items, this.initialValue, required this.onSelect, this.fieldLabel});

  @override
  State<SelectFromEnum<T>> createState() => SelectFromEnumState<T>();
}

class SelectFromEnumState<T extends SelectItem> extends State<SelectFromEnum<T>>{
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: widget.fieldLabel ?? 'Sélectionner une valeur',
      ),
      initialValue: _selectedValue,
      items: widget.items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.label),
        );
      }).toList(),
      onChanged: (item) {
        if (item != null) {
          setState(() {
            _selectedValue = item;
          });
          widget.onSelect(item);
        }
      },
    );
  }

}