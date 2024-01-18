import 'dart:io';
import 'package:pkg_utils/pkg_utils.dart';

void main(List<String> arguments) {
  // ne fonctionne pas en test, donc plus qu'a le ùmettre dans un chti exemple
  printColor(PrintColor.red, "printColor() without newLine...",
      noNewLine: true);
  sleep(Duration(seconds: 1));
  printColor(
    PrintColor.green,
    "OK",
  );
}
