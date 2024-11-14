import 'package:intl/intl.dart';

class Util {
  static String formatAccountNumber(int accountNumber) {
    return NumberFormat("#,##0", "en_US")
        .format(accountNumber)
        .replaceAll(",", " ");
  }

  static String formatCurrency(int amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }
}
