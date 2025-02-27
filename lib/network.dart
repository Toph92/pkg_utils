library network;

export 'network.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

enum HttpMethod { post, get, put }

enum NetworkStatus {
  ok("OK"),
  timeout("Host unreachable"),
  authorization("Bad authorization"),
  connectionRefused("Connection refused"),
  connectionFails("Connection erreur"),
  aborted("Aborted"),
  dnsLookup("DNS lookup error"),
  otherError("Other error");

  final String errorMessage;
  const NetworkStatus(this.errorMessage);
}

class NetDatasource {
  NetDatasource({required this.baseUrl, this.disableCertCheck = false}) {
    //assert(baseUrl.right(1) == '/');
    if (disableCertCheck) HttpOverrides.global = MyHttpOverrides();
  }

  bool disableCertCheck;
  //bool connected = false;
  String baseUrl;
  NetworkStatus status = NetworkStatus.otherError;
  http.Client? httpClient;

  Future<String?> requestNetwork({
    required HttpMethod method,
    Map<String, dynamic>? jsonBody,
    Map<String, String>? jsonBodyFields,
    Map<String, String>? jsonHeaders,
    required String url,
  }) async {
    httpClient ??= http.Client();
    status = NetworkStatus.otherError;

    var defaultHeaders = {'Content-Type': 'application/x-www-form-urlencoded'};
    if (jsonHeaders != null) {
      defaultHeaders.addAll(jsonHeaders);
    }

    try {
      final uri = Uri.parse('$baseUrl$url');

      // Configurer la requête en fonction du type de méthode
      late http.Response response;
      switch (method) {
        // copyright Github copilote. Cela semble bon, pas tout vérifié son code ;)
        case HttpMethod.post:
          if (jsonBody != null) {
            // Envoyer une requête POST avec un corps JSON encodé
            response = await httpClient!.post(
              uri,
              headers: defaultHeaders,
              body: jsonEncode(jsonBody),
            );
          } else if (jsonBodyFields != null) {
            // Envoyer une requête POST avec des champs de formulaire
            response = await httpClient!.post(
              uri,
              headers: defaultHeaders,
              body: jsonBodyFields,
            );
          } else {
            response = await httpClient!.post(uri, headers: defaultHeaders);
          }
          break;
        case HttpMethod.get:
          // Envoyer une requête GET
          response = await httpClient!.get(uri, headers: defaultHeaders);
          break;
        case HttpMethod.put:
          if (jsonBody != null) {
            // Envoyer une requête PUT avec un corps JSON encodé
            response = await httpClient!.put(
              uri,
              headers: defaultHeaders,
              body: jsonEncode(jsonBody),
            );
          } else if (jsonBodyFields != null) {
            // Envoyer une requête PUT avec des champs de formulaire
            response = await httpClient!.put(
              uri,
              headers: defaultHeaders,
              body: jsonBodyFields,
            );
          } else {
            response = await httpClient!.put(uri, headers: defaultHeaders);
          }
          break;
      }

      //connected = true;
      if (httpClient == null) {
        status = NetworkStatus.aborted;
        print("Requête annulée");
        return null;
      }
      if (response.statusCode == 200) {
        status = NetworkStatus.ok;
        return response.body;
      } else {
        print("Erreur de serveur : ${response.reasonPhrase}");
        status = NetworkStatus.otherError;
      }
    } catch (e) {
      //connected = false;

      switch (http.ClientException) {
        case http.ClientException(message: "Connection refused"):
          status = NetworkStatus.connectionRefused;
          break;
        case http.ClientException(message: "Connection timed out"):
          status = NetworkStatus.timeout;
          break;
        case http.ClientException(message: "Failed host lookup"):
          status = NetworkStatus.dnsLookup;
          break;

        case http.ClientException(message: "Connection failed"):
          status = NetworkStatus.connectionFails;
          break;
        case http.ClientException(message: "Bad certificate"):
          status = NetworkStatus.authorization;
          break;
        case http.ClientException(message: "Software caused connection abort"):
          status = NetworkStatus.aborted;
          break;
        default:
          status = NetworkStatus.otherError;
          break;
      }
      print("Erreur réseau : $e");
    }

    return null;
  }

  abort() {
    status = NetworkStatus.aborted;
    if (httpClient != null) {
      httpClient!.close();
      httpClient = null;
    }
  }

// Ne fonctionne pas en web
  /* Future<String?> requestNetwork(
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
      HttpClient client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      // Désactive la vérification du certificat SSL
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      http.Request request = http.Request(
          method == HttpMethod.post ? 'POST' : 'GET',
          Uri.parse('$baseUrl$url'));

      if (jsonBody != null) {
        request.body = jsonEncode(jsonBody);
      }
      if (jsonBodyFields != null) {
        request.bodyFields = jsonBodyFields;
      }
      request.headers.addAll(defaultHeaders);

      http.StreamedResponse response = await request.send();
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
  } */
}

/// return the best time offset in ms between the device and  NTP servers adding localHosts list servers
/// if disableRegularNtpServers is true, only localHosts servers are used
Future<int?> getTimeOffset(
    {List<String>? additionnalNtpServers,
    bool disableRegularNtpServers = false,
    bool exitOnFirstNtpServerFound = false}) async {
  int? bestTimeOffset;
  int? timeOffset;

  List<String> hosts = [
    'time.google.com',
    'time.facebook.com',
    'time.euro.apple.com',
    'pool.ntp.org'
  ];

  if (disableRegularNtpServers) hosts.clear();

  if (additionnalNtpServers != null) hosts.insertAll(0, additionnalNtpServers);

  for (String host in hosts) {
    timeOffset = await _checkTime(host);
    if (timeOffset != null) {
      if (bestTimeOffset == null || timeOffset < bestTimeOffset) {
        bestTimeOffset = timeOffset;
        if (exitOnFirstNtpServerFound) return bestTimeOffset;
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
    offset = await NTP.getNtpOffset(
        localTime: myTime,
        lookUpAddress: lookupAddress,
        timeout: Duration(seconds: 5));
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
