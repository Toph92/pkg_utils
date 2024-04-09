library network;

export 'network.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:pkg_utils/utils.dart';
import 'package:pkg_utils/extensions.dart';
import 'dart:async';
import 'dart:io';
import 'package:ntp/ntp.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class Token {
  String accessToken;
  //int session;
  String tokenType;
  int expireTimeout;
  DateTime? expireDatetime;

  Token(
      {required this.accessToken,
      //required this.session,
      required this.tokenType,
      required this.expireTimeout}) {
    expireDatetime = DateTime.now().add(Duration(seconds: expireTimeout - 60));
  }

  factory Token.fromJson(Map<String, dynamic> jsonMap) {
    return Token(
      accessToken: jsonMap["access_token"],
      //session: jsonMap["session"],
      tokenType: jsonMap["token_type"],
      expireTimeout: jsonMap["expires_in"],
    );
  }
  String authHeader() => "Bearer $accessToken";

  bool isExpired() {
    DateTime now = DateTime.now();
    if (expireDatetime != null &&
        now.millisecondsSinceEpoch < expireDatetime!.millisecondsSinceEpoch) {
      return false;
    } else {
      return true;
    }
  }
}

enum HttpMethod { post, get }

enum NetworkStatus {
  ok("OK"),
  timeout("Host unreachable"),
  authorization("Bad authorization"),
  connectionRefused("Connection refused"),
  otherError("Other error");

  final String errorMessage;
  const NetworkStatus(this.errorMessage);
}

class NetDatasource {
  NetDatasource({required this.baseUrl, this.disableCertCheck = false}) {
    assert(baseUrl.right(1) == '/');
    if (disableCertCheck) HttpOverrides.global = MyHttpOverrides();
  }

  bool disableCertCheck;
  bool connected = false;
  String baseUrl;
  NetworkStatus status = NetworkStatus.otherError;

  Future<String?> requestNetwork(
      {required HttpMethod method,
      Map<String, dynamic>? jsonBody,
      Map<String, String>? jsonBodyFields,
      Map<String, String>? jsonHeaders,
      required String url}) async {
    status = NetworkStatus.otherError;
    assert(url.left(1) != '/');

    var defaultHeaders = {'Content-Type': 'application/x-www-form-urlencoded'};
    if (jsonHeaders != null) {
      defaultHeaders.addAll(jsonHeaders);
    }
    try {
      var client = HttpClient();

      // Désactive la vérification du certificat SSL
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Request request = Request(method == HttpMethod.post ? 'POST' : 'GET',
          Uri.parse('$baseUrl$url'));

      if (jsonBody != null) {
        request.body = jsonEncode(jsonBody);
      }
      if (jsonBodyFields != null) {
        request.bodyFields = jsonBodyFields;
      }
      request.headers.addAll(defaultHeaders);

      StreamedResponse response = await request.send();
      connected = true;
      if (response.statusCode == 200) {
        status = NetworkStatus.ok;
        return (await response.stream.bytesToString());
      } else {
        Console.printColor(PrintColor.red, response.reasonPhrase);
      }
      status = NetworkStatus.otherError;
      return null;
    } catch (e) {
      connected = false;
      if (e is SocketException) {
        switch (e.osError?.errorCode) {
          case 11001:
            status = NetworkStatus.timeout;
            break;
          case 1225:
            status = NetworkStatus.connectionRefused;
            break;
          default:
            status = NetworkStatus.otherError;
        }
      }
      Console.printColor(PrintColor.red, "$e]");
      return null;
    }
  }
}

/// return the best time offset in ms between the device and  NTP servers adding localHosts list servers
Future<int?> getTimeOffset({List<String>? additionnalNtpServers}) async {
  int? bestTimeOffset;
  int? timeOffset;

  List<String> hosts = [
    'time.google.com',
    'time.facebook.com',
    'time.euro.apple.com',
    'pool.ntp.org'
  ];

  if (additionnalNtpServers != null) {
    hosts.addAll(additionnalNtpServers);
  }

  for (String host in hosts) {
    timeOffset = await _checkTime(host);
    if (timeOffset != null) {
      if (bestTimeOffset == null || timeOffset < bestTimeOffset) {
        bestTimeOffset = timeOffset;
      }
    }
  }
  return bestTimeOffset;
}

Future<int?> _checkTime(String lookupAddress) async {
  DateTime myTime;
  DateTime ntpTime;

  /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
  myTime = DateTime.now();
  int? offset;

  /// Or get NTP offset (in milliseconds) and add it yourself
  try {
    offset =
        await NTP.getNtpOffset(localTime: myTime, lookUpAddress: lookupAddress);
    ntpTime = myTime.add(Duration(milliseconds: offset));
  } catch (e) {
    //print('Error: $e');
    // on peut deviner que le host n'est pas accessible
    return null;
  }

  ntpTime = myTime.add(Duration(milliseconds: offset));

  /* print('\n==== $lookupAddress ====');
  print('My time: $myTime');
  print('NTP time: $ntpTime');
  print('Difference: ${myTime.difference(ntpTime).inMilliseconds}ms');*/

  return myTime.difference(ntpTime).inMilliseconds.abs(); // ms
}
