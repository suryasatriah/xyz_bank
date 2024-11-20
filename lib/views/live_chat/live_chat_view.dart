import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:xyz_bank/utils/constant.dart';
import 'package:xyz_bank/views/live_chat/widgets/live_chat_app_bar.dart';
import 'package:xyz_bank/views/transfer/transfer_amt_view.dart';

class LiveChatView extends StatefulWidget {
  const LiveChatView({super.key});

  @override
  State<LiveChatView> createState() => _LiveChatViewState();
}

class _LiveChatViewState extends State<LiveChatView> {
  late WebViewController webViewController;
  late final PlatformWebViewControllerCreationParams params;

  @override
  void initState() {
    super.initState();
    initController();
  }

  initController() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webViewController = WebViewController.fromPlatformCreationParams(params);

    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }

            if (request.url.contains('sukha') ||
                request.url.contains('transfer')) {
              if ((Platform.isIOS || Platform.isAndroid) && mounted) {
                var isNavigating = false;
                if (!isNavigating) {
                  isNavigating = true;
                  if (request.url.contains('transfer')) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransferAmtView(
                                  destination: Uri.parse(request.url)
                                          .queryParameters['name'] ??
                                      "10024520240810",
                                  amount: Uri.parse(request.url)
                                          .queryParameters['amt'] ??
                                      "0",
                                  destinationName: Uri.parse(request.url)
                                          .queryParameters['dest'] ??
                                      "Andriansyah Hakim",
                                ))).then((_) {
                      isNavigating = false;
                    });
                  }
                }

                return NavigationDecision.prevent;
              } else if (await canLaunchUrl(Uri.parse(request.url))) {
                await launchUrl(Uri.parse(request.url),
                    mode: LaunchMode.externalApplication);

                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.prevent;
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(kLiveChatEndpoint));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57.r),
        child: const LiveChatAppBar(),
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 4.r),
          child: WebViewWidget(controller: webViewController)),
    );
  }
}
