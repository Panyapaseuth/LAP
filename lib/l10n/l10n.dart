import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('lo'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'lo':
        return 'LA';
      case 'en':
      default:
        return 'EN';
    }
  }
}
