import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xyz_bank/views/pln_pra/pln_pra_amt_screen.dart';
import 'package:xyz_bank/views/pln_pra/widgets/pln_pra_header.dart';
import 'package:xyz_bank/widgets/dolphin_app_bar.dart';
import 'package:xyz_bank/widgets/dolphin_button.dart';

class PlnPraView extends StatefulWidget {
  final String? amount;
  final String? destination;

  const PlnPraView({super.key, this.amount, this.destination});

  @override
  State<PlnPraView> createState() => _PlnPraViewState();
}

class _PlnPraViewState extends State<PlnPraView> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    if (widget.destination != null) controller.text = widget.destination!;
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DolphinAppBar.appBar1(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 24.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.r),
              child: PlnPraHeader(
                title: "PLN Prabayar",
                picture: Image.asset("assets/images/ic_pln.png"),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: controller,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.black,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide:
                                  const BorderSide(color: Colors.black)),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () => setState(() {
                                      controller.text = '';
                                    }),
                                color: Colors.black,
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.clear_outlined)),
                          ),
                        ),
                        focusNode: focusNode,
                        onTapOutside: (event) => focusNode.unfocus(),
                      )),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
                    child: DolphinButton.outlinedButton1(context,
                        label: "Lanjutkan",
                        onPressed: () => controller.text.isNotEmpty
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlnPraAmtScreen(
                                        amount: widget.amount,
                                        destination: controller.text)))
                            : null),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
