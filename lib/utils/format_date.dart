import 'package:intl/intl.dart';

String formatDateFr(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  return DateFormat('dd/MM/yyyy').format(date);
}