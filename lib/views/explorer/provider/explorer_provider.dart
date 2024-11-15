import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xyz_bank/models/button.dart';
import 'package:xyz_bank/models/result.dart';
import 'package:xyz_bank/services/dolphin_api.dart';
import 'package:xyz_bank/services/dolphin_logger.dart';
import 'package:xyz_bank/views/explorer/provider/dolphin_provider.dart';

class ExplorerProvider extends ChangeNotifier {
  final DolphinApi dolphinApi = DolphinApi.instance;

  bool loading = false;
  bool submitted = false;
  Result? result;
  Button? button;
  List<String> suggestions = [];

  late DolphinProvider _dolphinProvider;

  void updateDolphinProvider(DolphinProvider dolphinProvider) {
    _dolphinProvider = dolphinProvider;
    notifyListeners();
  }

  // Populate Suggestion
  populateSuggestion() async {
    try {
      loading = true;
      suggestions = await dolphinApi.getSuggestionsNative();
      loading = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  String? populateAnswerJson(String answerJson) {
    try {
      var sanitizedJson =
          answerJson.replaceAll("\n", "\\n").replaceAll("'", "\"");
      var parsedJson = jsonDecode(sanitizedJson);

      if (parsedJson is Map<String, dynamic>) {
        result = Result.fromJson(parsedJson);
        if (result!.button != null) {
          var buttonArray = result!.button!.split("@===@");
          button = Button(label: buttonArray[2], link: buttonArray[1]);
        }
        return result!.title!;
      }
    } catch (e) {
      DolphinLogger.instance.e(e);
    }

    return null;
  }

  // Clear data
  clearData() {
    submitted = false;
    result = null;
    button = null;
    suggestions = [];
  }

  // Start Loading
  startLoading() => {loading = true, notifyListeners()};

  // Stop Loading
  stopLoading() => {loading = false, notifyListeners()};

  // Submit Search
  submitSearch() {
    if (submitted) {
      result = null;
      button = null;
    } else {
      submitted = true;
    }

    notifyListeners();
  }
}
