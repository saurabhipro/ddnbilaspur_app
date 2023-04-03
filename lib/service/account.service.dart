import 'dart:convert';

import '../app-const/app_constants.dart';
import '../model/account.model.dart';
import '../service/http_request.service.dart';

Future<Account> account() async {
  final response = await authorizedGetRequest(
      Uri.parse('${AppConstant.baseUrl}/api/account'), {
    'Content-type': 'application/json',
    'Authorization': 'Bearer '
  });
  return Account.fromJson(jsonDecode(response.body));
}
