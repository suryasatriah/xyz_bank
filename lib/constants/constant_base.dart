import 'package:flutter/material.dart';

class ConstantBase {
  static const List<DropdownMenuEntry<String>> kListBankDropdownMenu =
      <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: "mandiri", label: "Bank Mandiri"),
    DropdownMenuEntry(value: "xyz", label: "Bank XYZ"),
    DropdownMenuEntry(value: "bca", label: "Bank BCA"),
  ];

  static const String kPathPlnPra = "/plnpra";
  static const String kPathSukha = "/sukha";
  static const String kPathTransfer = "/transfer";

  static const String kCurrencyNumberFormat = "#,##0";
}
