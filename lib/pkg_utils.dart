library pkg_utils;

import 'dart:io';

import 'package:pkg_utils/extensions.dart';

/// display message to console
void printColor(dynamic color, String? message,
    [dynamic color2, String? message2, dynamic color3, String? message3]) {
  assert(color is PrintColor || color is int);
  if (color is PrintColor) color = color.value;
  if (color2 is PrintColor) color2 = color.value;
  if (color3 is PrintColor) color3 = color.value;

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
  grey(1),
  red(2),
  green(4),
  magenta(8),
  cyan(16),
  white(32),
  black(64),
  blue(128),
  yellow(256),

  bgGrey(512),
  bgRed(1024),
  bgGreen(2048),
  bgMagenta(4096),
  bgCyan(65536),
  bgWhite(131072),
  bgBlue(524288),
  bgYellow(1048576),

  bold(2097152),
  blink(4194304),
  italic(8388608),
  underline(16777216),

  error(32 + 1024 + 4194304),
  warning(33554432),
  info(262144);

  final int value;
  const PrintColor(this.value);
}

// https://notes.burke.libbey.me/ansi-escape-codes/
String updateWithColor(int color, String? message) {
  String sResult;
  String sCode = "";
  String sEmoticon = "";

  if (color.binaryIsSet(PrintColor.info.value)) {
    sEmoticon = ' ℹ️ ';
    color = PrintColor.blue.value + PrintColor.bold.value;
  }

  if (color.binaryIsSet(PrintColor.error.value)) {
    sEmoticon = '⭕';

    color = PrintColor.white.value +
        PrintColor.bgRed.value +
        PrintColor.blink.value;
  }
  if (color.binaryIsSet(PrintColor.warning.value)) {
    sEmoticon = '⚠️';
    color = PrintColor.yellow.value;
  }

  if (color.binaryIsSet(PrintColor.bold.value)) sCode += "\x1B[1m";
  if (color.binaryIsSet(PrintColor.blink.value)) sCode += "\x1B[5m";
  if (color.binaryIsSet(PrintColor.italic.value)) sCode += "\x1B[3m";
  if (color.binaryIsSet(PrintColor.underline.value)) sCode += "\x1B[4m";

  if (color.binaryIsSet(PrintColor.grey.value)) {
    sCode += "\x1b[38;2;128;128;128m";
  }
  if (color.binaryIsSet(PrintColor.black.value)) sCode += "\x1B[30m";
  if (color.binaryIsSet(PrintColor.red.value)) sCode += "\x1B[31m";
  if (color.binaryIsSet(PrintColor.green.value)) sCode += "\x1B[32m";
  if (color.binaryIsSet(PrintColor.yellow.value)) sCode += "\x1B[33m";
  if (color.binaryIsSet(PrintColor.blue.value)) sCode += "\x1B[34m";
  if (color.binaryIsSet(PrintColor.magenta.value)) sCode += "\x1B[35m";
  if (color.binaryIsSet(PrintColor.cyan.value)) sCode += "\x1B[36m";
  if (color.binaryIsSet(PrintColor.white.value)) sCode += "\x1B[37m";

  if (color.binaryIsSet(PrintColor.bgGrey.value)) {
    sCode += "\x1b[48;2;128;128;128m";
  }
  //if (color.binaryIsSet(PrintColor.bgBlack.value))sCode += "\x1B[30m";
  if (color.binaryIsSet(PrintColor.bgRed.value)) sCode += "\x1B[41m";
  if (color.binaryIsSet(PrintColor.bgGreen.value)) sCode += "\x1B[42m";
  if (color.binaryIsSet(PrintColor.bgYellow.value)) sCode += "\x1B[43m";
  if (color.binaryIsSet(PrintColor.bgBlue.value)) sCode += "\x1B[44m";
  if (color.binaryIsSet(PrintColor.bgMagenta.value)) sCode += "\x1B[45m";
  if (color.binaryIsSet(PrintColor.bgCyan.value)) sCode += "\x1B[46m";
  if (color.binaryIsSet(PrintColor.bgWhite.value)) sCode += "\x1B[47m";

  sResult = '$sEmoticon $sCode$message\x1B[0m ';
  return sResult;
}
