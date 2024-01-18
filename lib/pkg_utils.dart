library pkg_utils;

import 'dart:io';

void printColor(PrintColor color, String? message, {bool noNewLine = false}) {
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
  if (noNewLine) {
    stdout.write(sTmp);
    stdout.close();
  } else {
    print(sTmp);
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
