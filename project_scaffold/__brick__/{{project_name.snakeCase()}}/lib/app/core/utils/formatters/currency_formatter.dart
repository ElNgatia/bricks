import 'package:intl/intl.dart';

class AppCurrencyFormatter {
  static String format(num? amount, {String currencySymbol = ''}) {
    if (amount == null) return '$currencySymbol 0.00';
    final formatter = NumberFormat('#,##0.00');
    final formatted = formatter.format(amount);
    return currencySymbol.isEmpty ? formatted : '$currencySymbol $formatted';
  }
}

