import 'package:intl/intl.dart';

String getToday([String? format]) {
  return DateFormat(format ?? 'yyyy-MM-dd').format(DateTime.now());
}
