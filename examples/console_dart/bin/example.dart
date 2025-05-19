import 'package:pkg_utils/extensions.dart';
import 'package:pkg_utils/utils.dart';

void main(List<String> arguments) {
  Console.printColor(PrintColor.error, "Erreur");
  Console.printColor(PrintColor.warning, "Ah que test");
  Console.printColor(PrintColor.info, "Ah que test");
  Console.printColor(PrintColor.traceUp, "Upload / Send data");
  Console.printColor(PrintColor.traceDown, "Download / Receive data");
  Console.printColor(PrintColor.traceInfo, "Information");
  double n = 3.141592653589793;
  print("Nombre ${n.toPrecision(0).toString()}");
}
