import 'dart:convert';

import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../ddn_app.dart';
import '../service/access_key.dart';

class Mobile extends StatefulWidget {
  const Mobile({Key? key}) : super(key: key);

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  bool otpSent = false;
  bool waitingForOtp = false;
  bool _permissionDenied = false;

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Authentication')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                  keyboardType: TextInputType.number,
                  controller: mobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Can\'t be empty';
                    } else {
                      RegExp mobileNumber = RegExp(r'^[1-9][0-9]{9}$');
                      if (!mobileNumber.hasMatch(value)) {
                        return 'Please enter a 10 digit mobile number not starting with 0';
                      }
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile',
                      hintText: 'Enter Mobile'),
                ),
              ),
              const SizedBox(height: 10),
              if (!waitingForOtp)
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: otpSent
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              /*if (mobileController.text=='1111111111') {
                                print('--------------------------------------------${mobileController.text}');
                                _fakeAuthenticate();
                              } else {
                                _generateOtp();
                              }*/
                                _generateOtp();
                            }
                          },
                    child: otpSent
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Send OTP',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                  ),
                ),
              if(waitingForOtp)
                const Text('Waiting for OTP...'),
              const SizedBox(height: 10),
              if (_permissionDenied)
                const Text('SMS Permission is required for login!')
            ],
          ),
        ),
      ),
    );
  }

  void _generateOtp() async {
    setState(() {
      otpSent = true;
    });
    final response = await postRequest(
        Uri.parse('${AppConstant.baseUrl}/api/generate-otp'),
        {'accept': '*/*'},
        mobileController.text);
    if (response.statusCode == 200) {
      setState(() {
        otpSent = false;
        waitingForOtp = true;
      });
      Telephony telephony = Telephony.instance;
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      if (permissionsGranted == null || !permissionsGranted) {
        permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      }
      if (permissionsGranted == null || !permissionsGranted) {
        _permissionDenied = true;
        return;
      }
      telephony.listenIncomingSms(
          listenInBackground: false,
          onNewMessage: (SmsMessage message) async {
            final credentials = jsonEncode({
              'username': mobileController.text,
              'password': message.body?.split(' ')[3],
              'rememberMe': true
            });

            final verifyOtpResponse = await postRequest(
                Uri.parse('${AppConstant.baseUrl}/api/verify-otp'),
                {'Content-Type': 'application/json'},
                credentials);
            AccessKeyStorage.setAccessToken(
                jsonDecode(verifyOtpResponse.body)['id_token']);
            DDNApp.navigatorKey.currentState?.pushNamed("/");
          });
    }
  }

  void _fakeAuthenticate() async {
    final credentials = jsonEncode({
      'username': 'google',
      'password': 'admin',
      'rememberMe': true
    });
    final verifyOtpResponse = await postRequest(
        Uri.parse('${AppConstant.baseUrl}/api/authenticate'),
        {'Content-Type': 'application/json'},
        credentials);
    AccessKeyStorage.setAccessToken(
        jsonDecode(verifyOtpResponse.body)['id_token']);
    DDNApp.navigatorKey.currentState?.pushNamed("/");
  }
}
