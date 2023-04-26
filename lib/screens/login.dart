import 'dart:convert';

import 'package:ddnbilaspur_mob/ddn_app.dart';
import 'package:ddnbilaspur_mob/service/access_key.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';

import '../app-const/app_constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    @override
    void dispose() {
      loginController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Digital Door Number: Surveyor Login"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: SizedBox(
                        width: 200,
                        height: 150,
                        child: Image.asset('assets/images/bilaspur.jpeg')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: loginController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Can\'t be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'login',
                        hintText: 'Enter login'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login(loginController.text, passwordController.text);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                const Text('Not registered yet? contact system administrator.')
              ],
            )),
      ),
    );
  }

  _login(String username, String password) async {
    final credentials =
        jsonEncode({'username': username, 'password': password});
    final response = await postRequest(
        Uri.parse('${AppConstant.baseUrl}/api/authenticate'),
        {'Content-type': 'application/json'},
        credentials);
    AccessKeyStorage.setAccessToken(jsonDecode(response.body)['id_token']);
    DDNApp.navigatorKey.currentState?.pushNamed("/");
  }
}
