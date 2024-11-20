import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xyz_bank/views/pln_pra/pln_pra_view.dart';
import 'package:xyz_bank/views/transfer/transfer_amt_view.dart';

mixin DolphinLinkNavigator {
  static const String kEndpointPlnPra = "/plnpra";

  Future<void> navigateDeeplink(BuildContext context,
      {required String url}) async {
    try {
      final uri = Uri.parse(url);

      if ((Platform.isIOS || Platform.isAndroid) && context.mounted) {
        _handleIOSDeeplink(context, uri);
      } else {
        await _launchExternalDeeplink(uri);
      }
    } catch (e) {
      throw Exception("Failed to navigate to URL: ${e.toString()}");
    }
  }

  void _handleIOSDeeplink(BuildContext context, Uri uri) {
    if (uri.path.contains(kEndpointPlnPra)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlnPraView(
            amount: uri.queryParameters['amt'],
            destination: uri.queryParameters['dest'],
          ),
        ),
      );
    } else if (uri.path.contains('sukha')) {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const SukhaScreen()));
    } else if (uri.path.contains("transfer")) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TransferAmtView(
                    destination:
                        uri.queryParameters['name'] ?? "10024520240810",
                    amount: uri.queryParameters['amt'] ?? "0",
                    destinationName:
                        uri.queryParameters['dest'] ?? "Andriansyah Hakim",
                  ))).then((_) {});
    }
  }

  Future<void> _launchExternalDeeplink(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Unable to launch URL.");
    }
  }
}
