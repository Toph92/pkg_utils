library pkg_utils;

import 'dart:io';

void printColor(PrintColor color, String? message,
    [PrintColor? color2,
    String? message2,
    PrintColor? color3,
    String? message3]) {
  if (color3 != null &&
      message3 != null &&
      color2 != null &&
      message2 != null) {
    stdout.write(updateWithColor(color, message));
    stdout.write(updateWithColor(color2, message2));
    stdout.writeln(updateWithColor(color3, message3));
  } else if (color2 != null && message2 != null) {
    stdout.write(updateWithColor(color, message));
    stdout.writeln(updateWithColor(color2, message2));
  } else {
    stdout.writeln(updateWithColor(color, message));
  }
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

String updateWithColor(PrintColor color, String? message) {
  String sResult;
  switch (color) {
    case PrintColor.red:
      sResult = '\x1B[31m$message\x1B[0m';
      break;
    case PrintColor.green:
      sResult = '\x1B[32m$message\x1B[0m';
      break;
    case PrintColor.magenta:
      sResult = '\x1B[35m$message\x1B[0m';
      break;
    case PrintColor.cyan:
      sResult = '\x1B[36m$message\x1B[0m';
      break;
    case PrintColor.white:
      sResult = '\x1B[37m$message\x1B[0m';
      break;
    case PrintColor.blue:
      sResult = '\x1B[34m$message\x1B[0m';
      break;
    case PrintColor.yellow:
      sResult = '\x1B[33m$message\x1B[0m';
      break;
    default:
      sResult = message ?? '';
      break;
  }
  return sResult;
}
