import 'package:flutter/material.dart';
import 'package:xyz_bank/services/dolphin_api.dart';
import 'package:xyz_bank/services/dolphin_logger.dart';

class DolphinChangeNotifier extends ChangeNotifier {
  final DolphinApi dolphinApi = DolphinApi.instance;
  final DolphinLogger dolphinLogger = DolphinLogger.instance;
}
