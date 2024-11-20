import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xyz_bank/models/account.dart';
import 'package:xyz_bank/utils/constant.dart';
import 'package:xyz_bank/views/explorer/explorer_view.dart';
import 'package:xyz_bank/views/home/widgets/home_header.dart';
import 'package:xyz_bank/widgets/image_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Account account = kAccount;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalytics.instance.logScreenView(screenName: "Main Screen");
  }

  @override
  Widget build(BuildContext context) {
    void launchExplorer() {
      FirebaseAnalytics.instance.logEvent(
        name: 'event_name',
        parameters: <String, Object>{
          'string_parameter': 'string',
          'int_parameter': 42,
        },
      );
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return const ExplorerView();
            },
          );
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset("assets/images/home/img_home_header_bg.png"),
            ],
          ),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 32.r, 0, 18.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/ic_dolphin.png",
                                  height: 24.r,
                                ),
                                Text("BANK XYZ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        )),
                              ],
                            ),
                            Row(
                              children: [
                                ImageButton(
                                    name:
                                        "assets/images/home/ic_home_explorer.png",
                                    onTap: () => launchExplorer()),
                                ImageButton(
                                  name:
                                      "assets/images/home/ic_home_live_chat.png",
                                  onTap: () => {context.go("/livechat")},
                                ),
                                ImageButton(
                                    name:
                                        "assets/images/home/ic_home_notification.png"),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Halo, ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16.sp),
                                    ),
                                    TextSpan(
                                      text: account.name.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      HomeHeader(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.r),
                  child: Column(
                    children: [
                      Image.asset("assets/images/home/img_home_menu.png"),
                      Container(
                        height: 64.r,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Image.asset(
                          "assets/images/home/img_home_bottom_menu.png")),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
