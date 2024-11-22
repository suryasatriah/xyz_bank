import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xyz_bank/utils/constant.dart';
import 'package:xyz_bank/views/explorer/explorer_view.dart';
import 'package:xyz_bank/views/explorer/provider/dolphin_provider.dart';
import 'package:xyz_bank/views/explorer/provider/explorer_provider.dart';
import 'package:xyz_bank/views/home/home_view.dart';
import 'package:xyz_bank/views/live_chat/live_chat_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

  runApp(const XyzBank());
}

class XyzBank extends StatefulWidget {
  const XyzBank({super.key});

  @override
  State<XyzBank> createState() => _XyzBankState();
}

class _XyzBankState extends State<XyzBank> {
  final GoRouter _goRouter = GoRouter(
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        // builder: (context, state) => TransferView(),
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: '/explorer',
        builder: (context, state) => ExplorerView(),
      ),
      GoRoute(
        path: '/livechat',
        builder: (context, state) => LiveChatView(),
      ),
    ],
  );

  _createTheme(BuildContext context) {
    return ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme:
            GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
          headlineSmall: kHeadlineSmallTextStyle,
          bodyLarge: kBodyLargeTextStyle,
          bodyMedium: kBodyMediumTextStyle,
          labelMedium: kLabelMediumTextStyle,
          labelLarge: kLabelLargeTextStyle,
          titleMedium: kTitleMediumTextStyle,
          titleLarge: kTitleLargeTextStyle,
        ));
  }

  buildProviders(BuildContext context) {
    return [
      ChangeNotifierProvider<DolphinProvider>(create: (_) => DolphinProvider()),
      ChangeNotifierProxyProvider<DolphinProvider, ExplorerProvider>(
        create: (_) => ExplorerProvider(),
        update: (context, dolphinProvider, previous) =>
            previous!..updateDolphinProvider(dolphinProvider),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(context),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: _goRouter,
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              ScreenUtil.ensureScreenSize();
              return widget!;
            },
            theme: _createTheme(context),
          );
        },
      ),
    );
  }
}
