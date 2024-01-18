library pkg_utils;

//import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:flutter/foundation.dart' show kIsWeb;

//SizedBox voidWidget() => const SizedBox.shrink();

void printColor(PrintColor color, String? message) {
  String? sTmp = '';
  switch (color) {
    case PrintColor.red:
      sTmp = '\x1B[31m$message\x1B[0m';
      break;
    case PrintColor.green:
      sTmp = '\x1B[32m$message\x1B[0m';
      break;
    case PrintColor.magenta:
      sTmp = '\x1B[35m$message\x1B[0m';
      break;
    case PrintColor.cyan:
      sTmp = '\x1B[36m$message\x1B[0m';
      break;
    case PrintColor.white:
      sTmp = '\x1B[37m$message\x1B[0m';
      break;
    case PrintColor.blue:
      sTmp = '\x1B[34m$message\x1B[0m';
      break;
    case PrintColor.yellow:
      sTmp = '\x1B[33m$message\x1B[0m';
      break;
    default:
      sTmp = message;
      break;
  }

  print(sTmp);
}

enum PrintColor {
  red,
  green,
  magenta,
  cyan,
  white,
  blue,
  yellow,
  ;
}

/*

class OS {
  static bool isMobile() {
    if (kIsWeb) return false;
    if (Platform.isAndroid || Platform.isIOS) return true;
    return false;
  }

  static bool isWeb() {
    if (kIsWeb) return true;
    return false;
  }

  static bool isDesktop() {
    if (kIsWeb) return false;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) return true;
    return false;
  }

  static bool isAndroid() {
    if (kIsWeb) return false;
    if (Platform.isAndroid) return true;
    return false;
  }

  static bool isIOS() {
    if (kIsWeb) return false;
    if (Platform.isIOS) return true;
    return false;
  }

  static bool isLinux() {
    if (kIsWeb) return false;
    if (Platform.isLinux) return true;
    return false;
  }

  static bool isWindows() {
    if (kIsWeb) return false;
    if (Platform.isWindows) return true;
    return false;
  }
}
*/