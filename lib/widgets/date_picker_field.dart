import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow_mobile/utils/format_date.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final String label;
  final void Function(DateTime date) onDateSelected;

  const DatePickerField({
    super.key,
    this.initialDate,
    required this.label,
    required this.onDateSelected,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  DateTime? _dateSelected;

  @override
  void initState() {
    super.initState();
    _dateSelected = widget.initialDate;
    _controller = TextEditingController(
      text: _dateSelected != null
          ? formatDateTimeToString(_dateSelected!)
          : '',
    );
  }

  Future<void> _onPickDatePressed() async {
    final DateTime? picked = await pickDate(
      context: context,
      initialDate: _dateSelected,
    );
    if (picked != null && picked != _dateSelected) {
      setState(() {
        _dateSelected = picked;
        _controller.text = formatDateTimeToString(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: IconButton(
          icon: const Icon(FontAwesomeIcons.calendar),
          onPressed: _onPickDatePressed,
        ),
      ),
      readOnly: true,
      onTap: _onPickDatePressed,
    );
  }
}
