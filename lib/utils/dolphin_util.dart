import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:xyz_bank/constants/constant_base.dart';
import 'package:xyz_bank/services/dolphin_logger.dart';

class DolphinUtil {
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

  static String formatCurrency(dynamic amount) {
    var numberFormat = NumberFormat(ConstantBase.kCurrencyNumberFormat);
    var result = "0";

    try {
      if (amount is String) {
        result = numberFormat.format(int.tryParse(amount));
      } else if (amount is int || amount is double) {
        result = numberFormat.format(amount);
      } else {
        throw Exception("input is not string, int, or double");
      }
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
    }

    return result.replaceAll(",", ".");
  }
}
