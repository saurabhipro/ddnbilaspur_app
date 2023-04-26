import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app-const/app_constants.dart';

class AccessKeyStorage {
  static const storage = FlutterSecureStorage();

  static Future setAccessToken(String jwt) async {
    await storage.write(key: AppConstant.jwtKeyName, value: jwt);
  }

  static Future<String?> getAccessToken() async {
    return await storage.read(key: AppConstant.jwtKeyName);
  }
}
