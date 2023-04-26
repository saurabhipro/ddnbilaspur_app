import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../ddn_app.dart';
import 'access_key.dart';

Future<Response> postRequest(
    Uri uri, Map<String, String> headers, dynamic body) async {
  final response = await http.post(uri, headers: headers, body: body);
  if (response.statusCode == 200) {
    return response;
  } else if (response.statusCode == 401) {
    DDNApp.navigatorKey.currentState?.pushNamed('/login');
    return response;
  } else {
    return response;
  }
}

Future<Response> authorizedGetRequest(
    Uri uri, Map<String, String> headers) async {
  var accessKey = await AccessKeyStorage.getAccessToken();
  headers.addAll({'Authorization': 'Bearer ${accessKey!}'});
  final response = await http.get(uri, headers: headers);
  if (response.statusCode == 200) {
    return response;
  } else if (response.statusCode == 401) {
    DDNApp.navigatorKey.currentState?.pushNamed('/login');
    return response;
  } else {
    return response;
  }
}

Future<Response> authorizedPostRequest(
    Uri uri, Map<String, String> headers, String body) async {
  var accessKey = await AccessKeyStorage.getAccessToken();
  headers.addAll({'Authorization': 'Bearer ${accessKey!}'});
  final response = await http.post(uri, headers: headers, body: body);
  if (response.statusCode == 200) {
    return response;
  } else if (response.statusCode == 401) {
    DDNApp.navigatorKey.currentState?.pushNamed('/login');
    return response;
  } else {
    return response;
  }
}
