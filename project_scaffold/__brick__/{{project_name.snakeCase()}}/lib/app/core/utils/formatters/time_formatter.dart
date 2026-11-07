import 'package:intl/intl.dart';

class AppTimeFormatter {
  static final _timeFormat = DateFormat('hh:mm a');
  static final _hour24Format = DateFormat('HH:mm');

  static String format(DateTime? time) {
    if (time == null) return '';
    return _timeFormat.format(time);
  }

  static String format24(DateTime? time) {
    if (time == null) return '';
    return _hour24Format.format(time);
  }
}

