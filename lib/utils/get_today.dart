import 'package:intl/intl.dart';

String getToday([String? format]) =>
    DateFormat(format ?? 'yyyy-MM-dd').format(DateTime.now());
