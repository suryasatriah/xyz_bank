import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xyz_bank/models/account.dart';

const String kAppTitle = "XYZ Bank";

const Color kOrca300 = Color(0xffA9AAAB);

final Account kAccount = Account(
  id: "001",
  name: "Sonny Hastomo",
  number: 102180192013,
  balance: 1500000,
);

final kHeadlineSmallTextStyle = TextStyle(
  fontSize: 18.sp,
);
const kBodyLargeTextStyle = TextStyle(
  color: Colors.black,
);
const kBodyMediumTextStyle = TextStyle(
  color: Colors.black,
);

final kLabelMediumTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.sp,
);

final kLabelLargeTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.sp,
);

const kTitleMediumTextStyle = TextStyle(
  color: Colors.black,
);

const kTitleLargeTextStyle = TextStyle(
  color: Colors.white,
);
