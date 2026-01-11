import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateFr(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  return DateFormat('dd/MM/yyyy').format(date);
}

Future<DateTime?> pickDate({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2020),
    lastDate: lastDate ?? DateTime(2100),
  );
  return picked;
}

String formatDateTimeToString(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
         '${date.month.toString().padLeft(2, '0')}/'
         '${date.year}';
}