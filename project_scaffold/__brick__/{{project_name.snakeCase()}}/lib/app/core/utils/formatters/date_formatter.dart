import 'package:intl/intl.dart';

class AppDateFormatter {
  static final _defaultDate = DateFormat('dd MMM yyyy');
  static final _shortDate = DateFormat('dd/MM/yyyy');
  static final _apiDate = DateFormat('yyyy-MM-dd');
  static final _fullDate = DateFormat('EEEE, dd MMMM yyyy');

  static String format(DateTime? date) {
    if (date == null) return '';
    return _defaultDate.format(date);
  }

  static String formatShort(DateTime? date) {
    if (date == null) return '';
    return _shortDate.format(date);
  }

  static String toApi(DateTime date) => _apiDate.format(date);

  static DateTime? fromApi(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    return DateTime.tryParse(dateStr);
  }

  static String formatFull(DateTime? date) {
    if (date == null) return '';
    return _fullDate.format(date);
  }
}

