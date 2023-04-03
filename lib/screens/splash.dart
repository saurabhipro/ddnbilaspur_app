import 'package:flutter/material.dart';
import '../service/authenticate.dart';
import '../ddn_app.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }


}
