import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app-const/app_constants.dart';

class AccessKeyStorage {
  static const storage = FlutterSecureStorage();

  static Future setAccessToken(String jwt) async {
    await storage.write(key: AppConstant.jwtKeyName, value: jwt);
  }

  static Future<String?> getAccessToken() async {
    //return 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbWl0YW5zaHUiLCJhdXRoIjoiUk9MRV9BUkkiLCJleHAiOjE2OTQxNTQ3NTB9.7rgIz_S7s9ja557Vz0dhvm-8Q3vc9DbwG-PPNwogR8J7wtlE8jEwAW24iCLFAjaXU6IK1Iv_ne400Hveeq42dA';
    return await storage.read(key: AppConstant.jwtKeyName);
  }
}
