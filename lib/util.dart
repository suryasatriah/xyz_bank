import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:xyz_bank/services/dolphin_logger.dart';

class Util {
  static final DolphinLogger dolphinLogger = DolphinLogger.instance;

  static String decodeUtf8(String input) {
    try {
      return utf8.decode(input.codeUnits);
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }

    return input;
  }

  static String formatAccountNumber(int accountNumber) {
    return NumberFormat("#,##0", "en_US")
        .format(accountNumber)
        .replaceAll(",", " ");
  }

  static String formatCurrency(int amount) {
    return NumberFormat("#,##0.00", "en_US").format(amount);
  }
}
