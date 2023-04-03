import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/account.model.dart';
import 'model/user_info.model.dart';
import 'screens/filter-property.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'service/access_key.dart';

class DDNApp extends StatelessWidget {
  static Account? account;
  static UserInfo? userInfo;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  DDNApp({super.key});

  @override
  Widget build(BuildContext context) {
    _getAccessKey();
    return MaterialApp(
        routes: {
          '/': (context) => const Home(),
          '/login': (context) => const Login(),
          '/filter-property': (context) => const FilterProperty()
        },
        title: 'Digital Door Number, Bilaspur',
        theme: ThemeData(primarySwatch: Colors.blue),
        darkTheme: ThemeData(primarySwatch: Colors.blueGrey),
        color: Colors.amberAccent,
        navigatorKey: DDNApp.navigatorKey,
        supportedLocales: {const Locale('en', ' ')});
  }

  _getAccessKey() async {
    var accessKey = await AccessKeyStorage.getAccessToken();
    if (accessKey == null) {
      DDNApp.navigatorKey.currentState?.pushNamed('/login');
    }
  }
}
