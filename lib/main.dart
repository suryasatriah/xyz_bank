import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xyz_bank/constant.dart';
import 'package:xyz_bank/views/home/home_view.dart';

void main() {
  runApp(const XyzBank());
}

class XyzBank extends StatefulWidget {
  const XyzBank({super.key});

  @override
  State<XyzBank> createState() => _XyzBankState();
}

class _XyzBankState extends State<XyzBank> {
  final GoRouter _goRouter = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeView(),
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

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
    );
  }
}
