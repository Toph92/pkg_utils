//import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart';
import 'package:pkg_utils/pkg_utils.dart';
import 'package:pkg_utils/extensions.dart';

void main() {
  test('extract()', (() {
    String sTmp = "ab:cde:fg.hij";
    expect(sTmp.extract(":", ":"), "cde");
    expect(sTmp.extract(":", "."), "cde:fg");
    expect(sTmp.extract(":"), "cde:fg.hij");
    expect(sTmp.extract("."), "hij");
  }));

  test('toPrecision()', (() {
    double a = 2.3456789;
    expect(a.toPrecision(2), 2.35);
    expect(a.toPrecision(3), 2.346);
    expect(a.toPrecision(0), 2);
    expect(a.toStringAsFixed(0), "2");
    expect(a.toStringAsFixed(1), "2.3");
    expect(a.toPrecision(1), 2.3);

    expect(a.toPrecision(1).toString(), "2.3");
    expect(a.toPrecision(0).toInt().toString(), "2");
    double b = 2;
    expect("${b.round()}", "2");

    bool bError = false;
    try {
      a.toPrecision(-1);
    } on AssertionError {
      bError = true;
    }
    expect(bError, true);
  }));

  test('concat()', (() {
    String sTmp;
    sTmp = "abc";
    sTmp = "${sTmp.concat("|")}def";
    expect(sTmp, "abc|def");
    //print(sTmp);

    String? sTmp2;
    sTmp2 ??= "";
    sTmp2 = "${sTmp2.concat("|")}def";
    expect(sTmp2, "def");
  }));

  test('binarySet()', (() {
    int value = 0;
    value = value.binarySet(2);
    expect(value, 2);

    value = 6;
    if (value.binaryIsSet(2)) {
      expect(true, true);
    } else {
      expect(true, false);
    }

    value = 6;
    value = value.binaryUnset(2);
    expect(value, 4);

    value = 4;
    value.binarySet(2);
    expect(value, 4);

    int? value2;
    value2 ??= 2;
    value2 = value2.binarySet(2);
    expect(value2, 2);
  }));

  test('printColor()', (() {
    printColor(
      PrintColor.red.value,
      "This is a test",
    );

    printColor(
      PrintColor.info.value,
      "This is an information",
    );

    printColor(
      PrintColor.red.value + PrintColor.italic.value,
      "This is a test",
    );
    printColor(
      PrintColor.white.value + PrintColor.bgGrey.value,
      "This is a test",
    );

    printColor(
      PrintColor.error.value,
      "This is an error",
    );

    printColor(
      PrintColor.warning.value,
      "This is an warning",
    );

    printColor(PrintColor.warning, "Windows login ");

    /* printColor(
        PrintColor.blinkE, "printColor.blinkError", PrintColor.green, "OK");

    printColor(PrintColor.red, "Uno ", PrintColor.green, "Dos ",
        PrintColor.magenta, "Tres"); */
  }));
}
