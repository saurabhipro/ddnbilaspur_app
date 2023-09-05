import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../app-const/app_constants.dart';

class AccessKeyStorage {
  static const storage = FlutterSecureStorage();

  static Future setAccessToken(String jwt) async {
    await storage.write(key: AppConstant.jwtKeyName, value: jwt);
  }

  static Future<String?> getAccessToken() async {
    return 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbWl0YW5zaHUiLCJhdXRoIjoiUk9MRV9BUkkiLCJleHAiOjE2OTM5NjU4Mzh9.6PIPmikg9tuDja47wQkO59rFOTmxAU6odwxE8Dxs1uhxocuhSM3b0N20z3UFh8DCFeqH9acFMt73KCVgfR_oEg';
    //return await storage.read(key: AppConstant.jwtKeyName);
  }
}
