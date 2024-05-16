library utils;

import 'dart:convert';
import 'package:pkg_utils/extensions.dart';

/* /// display message to console
void printColor(dynamic color, String? message,
        [dynamic color2, String? message2, dynamic color3, String? message3]) =>
    Console.printColor(color, message, [color2, message2, color3, message3]); */

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

class Console {
  static void printColor(dynamic color, String? message) {
    assert(color is PrintColor || color is int);
    if (color is PrintColor) color = color.value;
    /* if (color2 is PrintColor) color2 = color2.value;
    if (color3 is PrintColor) color3 = color3.value; */

    /* if (color3 != null &&
        message3 != null &&
        color2 != null &&
        message2 != null) {
      stdout.write(_updateWithColor(color, message));
      stdout.write(_updateWithColor(color2, message2));
      stdout.writeln(_updateWithColor(color3, message3));
    } else if (color2 != null && message2 != null) {
      stdout.write(_updateWithColor(color, message));
      stdout.writeln(_updateWithColor(color2, message2));
    } else { */
    //stdout.writeln(_updateWithColor(color, message)); // marche pas en WEB :(
    print(_updateWithColor(color, message));
    //}
  }

// https://notes.burke.libbey.me/ansi-escape-codes/
  static String _updateWithColor(int color, String? message) {
    String sResult;
    String sCode = "";
    String sEmoticon = "";

    if (color.binaryIsSet(PrintColor.info.value)) {
      sEmoticon = '🔵';
      color = PrintColor.blue.value + PrintColor.bold.value;
    }

    if (color.binaryIsSet(PrintColor.error.value)) {
      sEmoticon = '🔴';

      color = PrintColor.white.value +
          PrintColor.bgRed.value +
          PrintColor.blink.value;
    }
    if (color.binaryIsSet(PrintColor.warning.value)) {
      sEmoticon = '🟡';
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

  static clear() {
    print("\x1B[2J\x1B[0;0H"); // clear entire screen, move cursor to 0;0
  }
}

/// return a value from a json string from key and subKey. By exemple : json2var(json, 'credentials', 'pin')
dynamic json2var(Map<String, dynamic> json, String key, [String? subKey]) {
  if (json[key] == null) return null;
  if (json.containsKey(key) == false) return null;

  try {
    if ((jsonDecode(json[key]) as Map).isEmpty) return null;
  } catch (e) {
    return null;
  }
  if (subKey == null) {
    return jsonDecode(json[key]);
  } else {
    if (jsonDecode(json[key]).containsKey(subKey) == false) return null;
    return jsonDecode(json[key])[subKey];
  }
}

/// return variable's name. null if not found
/// call exemple: getVariableName(() => myVariable);
String? getVariableName(Function() variable) {
  var name = variable.toString();
  var parts = name.split(' => ');
  return parts.length == 3 ? parts[2].trim() : null;
}
