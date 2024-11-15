import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:xyz_bank/models/result.dart';
import 'package:xyz_bank/services/dolphin_logger.dart';
import 'package:xyz_bank/views/explorer/provider/explorer_provider.dart';
import 'package:xyz_bank/views/explorer/widgets/explorer_answer_generator.dart';
import 'package:xyz_bank/views/explorer/widgets/explorer_loading.dart';

class ExplorerView extends StatefulWidget {
  const ExplorerView({
    super.key,
  });

  @override
  State<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends State<ExplorerView> {
  late FocusNode focusNode;
  late TextEditingController controller;

  late ExplorerProvider explorerProviderWidget;

  final DolphinLogger dolphinLogger = DolphinLogger.instance;
  bool submitted = false;
  Result? answer;
  String? link;
  String? buttonLabel;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    init();
  }

  init() async {
    explorerProviderWidget =
        Provider.of<ExplorerProvider>(context, listen: false);
    try {
      await explorerProviderWidget.populateSuggestion();
    } catch (e, stack) {
      dolphinLogger.e(e, stackTrace: stack);
      Fluttertoast.showToast(
          msg:
              "Cannot retrieve suggestions right now. Please try again later.");
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    explorerProviderWidget.clearData();
    super.dispose();
  }

  doSubmitSearch(ExplorerProvider explorerProvider) async {
    if (!explorerProvider.loading && controller.text.length > 3)
      explorerProvider.submitSearch();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSuggestions(ExplorerProvider explorerProvider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SUGGESTION",
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(fontSize: 14.sp, color: const Color(0xff7A7E87)),
          ),
          if (explorerProvider.suggestions.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: explorerProvider.suggestions.length,
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.all(0),
                minTileHeight: 0,
                dense: true,
                title: InkWell(
                  onTap: () => setState(() {
                    controller.text = explorerProvider.suggestions[index];
                    doSubmitSearch(explorerProvider);
                  }),
                  child: Text(
                    explorerProvider.suggestions[index],
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    buildAnswer() {
      return Selector<ExplorerProvider, Result?>(
        selector: (context, explorerProvider) => explorerProvider.result,
        builder: (context, explorerProvider, child) => ExplorerAnswerGenerator(
          question: controller.text,
        ),
      );
    }

    Widget buildShimmer() {
      return const ExplorerLoading();
    }

    Widget buildExplorerContents() {
      Widget getChild() {
        if (!explorerProviderWidget.loading) {
          if (!explorerProviderWidget.submitted) {
            return buildSuggestions(explorerProviderWidget);
          } else {
            return buildAnswer();
          }
        } else {
          return buildShimmer();
        }
      }

      return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.r), child: getChild());
    }

    return PopScope(
      canPop: !Provider.of<ExplorerProvider>(context).loading,
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjusts blur effect
        child: Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: const Color(0xff171D2C).withOpacity(0.7),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => {
                    if (!Provider.of<ExplorerProvider>(context, listen: false)
                        .loading)
                      Navigator.pop(context)
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.r),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          autofocus: true,
                          controller: controller,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xfffeffff).withOpacity(0.1),
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.r, horizontal: 8.r),
                              child: Image.asset(
                                "assets/images/home/ic_home_explorer.png",
                                height: 8.r,
                              ),
                            ),
                            suffixIcon: IconButton(
                                onPressed: explorerProviderWidget.submitted
                                    ? () => {
                                          setState(() {
                                            controller.text = '';
                                            explorerProviderWidget.clearData();
                                            explorerProviderWidget
                                                .populateSuggestion();
                                          })
                                        }
                                    : null,
                                icon: const Icon(Icons.clear)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            hintText: "Apa yang anda butuhkan?",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.8)),
                          ),
                          focusNode: focusNode,
                          onFieldSubmitted: (value) =>
                              doSubmitSearch(explorerProviderWidget),
                          onTapOutside: (event) => focusNode.unfocus(),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        buildExplorerContents(),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.r),
                          child: IconButton.filled(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close)),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
