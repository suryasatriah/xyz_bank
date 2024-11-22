import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xyz_bank/constants/constant_base.dart';
import 'package:xyz_bank/constants/constant_toast.dart';
import 'package:xyz_bank/services/dolphin_logger.dart';
import 'package:xyz_bank/views/pln_pra/pln_pra_view.dart';
import 'package:xyz_bank/views/sukha/sukha_view.dart';
import 'package:xyz_bank/views/transfer/transfer_amt_view.dart';
import 'package:xyz_bank/views/transfer/transfer_view.dart';

mixin DolphinLinkNavigator {
  final DolphinLogger dolphinLogger = DolphinLogger.instance;

  Future<void> navigateDeeplink(BuildContext context, {String? url}) async {
    try {
      if (url == null || url.isEmpty) {
        throw Exception();
      }

      final requestUri = Uri.parse(url);

      if ((Platform.isIOS || Platform.isAndroid) && context.mounted) {
        if (requestUri.path.contains(ConstantBase.kPathTransfer) ||
            requestUri.path.contains(ConstantBase.kPathSukha) ||
            requestUri.path.contains(ConstantBase.kPathTransfer)) {
          _handleDeeplink(context, requestUri);
        }
      } else {
        await _launchExternalDeeplink(requestUri);
      }
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
      Fluttertoast.showToast(msg: ConstantToast.kToastFailedLaunchLink);
    }
  }

  /// Handles the navigation request based on navigation request provided.
  ///
  /// Parameters:
  /// - [context]: The BuildContext used for navigation.
  /// - [request]: The URI containing the deeplink information with query parameters.
  /// - [mounted] : The state of context if it's still mounted.
  Future<NavigationDecision> handleNavigationRequest(
      BuildContext context, NavigationRequest request, bool mounted) async {
    var requestUrl = request.url;
    var requestUri = Uri.parse(requestUrl);

    if (request.url.startsWith('https://www.youtube.com/')) {
      return NavigationDecision.prevent;
    }

    if (requestUrl.contains(ConstantBase.kPathTransfer) ||
        requestUrl.contains(ConstantBase.kPathSukha) ||
        request.url.contains(ConstantBase.kPathTransfer)) {
      if ((Platform.isIOS || Platform.isAndroid) && mounted) {
        _handleDeeplink(context, requestUri);
      } else {
        await _launchExternalDeeplink(requestUri);
      }

      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  /// Handles all deeplinks by navigating to the appropriate view based on the query parameters.
  ///
  /// Parameters:
  /// - [context]: The BuildContext used for navigation.
  /// - [requestUri]: The URI containing the deeplink information with query parameters.
  void _handleDeeplink(BuildContext context, Uri requestUri) {
    if (requestUri.path.contains(ConstantBase.kPathPlnPra)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlnPraView(
                    amount: requestUri.queryParameters['amt'],
                    destination: requestUri.queryParameters['dest'],
                  )));
    } else if (requestUri.path.contains(ConstantBase.kPathSukha)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SukhaView()));
    } else if (requestUri.path.contains(ConstantBase.kPathTransfer)) {
      _handleTransferDeeplink(context, requestUri);
    }
  }

  /// Handles the transfer deeplink by navigating to the appropriate view based on the query parameters.
  ///
  /// Parameters:
  /// - [context]: The BuildContext used for navigation.
  /// - [requestUri]: The URI containing the deeplink information with query parameters.
  void _handleTransferDeeplink(BuildContext context, Uri requestUri) {
    if (requestUri.queryParameters['dest'] != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransferAmtView(
                  amount: requestUri.queryParameters['amt'],
                  destination: requestUri.queryParameters['dest']!)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TransferView(amount: requestUri.queryParameters['amt'])));
    }
  }

  /// Launches a deeplink by opening the provided URI in an external application.
  ///
  /// Parameters:
  /// - [requestUri]: The URI containing the deeplink to be launched.
  ///
  /// Throws:
  /// - [Exception]: If the URI cannot be launched.
  Future<void> _launchExternalDeeplink(Uri requestUri) async {
    if (await canLaunchUrl(requestUri)) {
      await launchUrl(requestUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception();
    }
  }
}
