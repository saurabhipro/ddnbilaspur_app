import 'dart:convert';

import '../model/user_info.model.dart';

import '../app-const/app_constants.dart';
import 'http_request.service.dart';

Future<UserInfo> getUserInfo() async {
  final response = await authorizedGetRequest(
      Uri.parse('${AppConstant.baseUrl}/api/account'),
      {'Content-type': 'application/json', 'Authorization': 'Bearer '});
  return UserInfo.fromJson(jsonDecode(response.body));
}
