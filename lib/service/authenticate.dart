import 'dart:convert';
import '../service/http_request.service.dart';
import '../app-const/app_constants.dart';

Future<String?> authenticate(String userName, String password) async {
  Map data = {'username': userName, 'password': password};

  var body = json.encode(data);
  final response = await postRequest(
      Uri.parse('${AppConstant.baseUrl}/api/authenticate'),
      {'Content-Type': 'application/json'},
      body);
  if (response != null && response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    return responseBody[AppConstant.jwtKeyName];
  }
  return Future(() => null);
}
