import 'dart:convert';
import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';
import '../ddn_app.dart';
import '../model/account.model.dart';
import '../model/user_info.model.dart';
import '../widgets/drawer_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
  final String appVersion = '1.0.0'; // Replace with your app version
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            // leading: Image.asset('assets/icons/favicon.ico'),
            title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: getAccount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final account = snapshot.data as Account;
                      return Center(
                        child: Text('${account.firstName} ${account.lastName}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                      );
                    }
                  }
                  return const SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.lime,
                      ));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: const TextStyle(fontSize: 7),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final userInfo = snapshot.data as UserInfo;
                      List<String?> wards = [];
                      for (var i = 0; i < userInfo.wards!.length; ++i) {
                        var ward = userInfo.wards![i];
                        wards.add(ward.wardNumber);
                      }
                      return Center(
                        child: Text('Wards: $wards',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                      );
                    }
                  }
                  return const SizedBox(
                      height: 10.0,
                      width: 10.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.lime,
                      ));
                },
              )
            ],
          ),
        )),
        drawer: const DrawerWidget(appVersion: '1.0'),
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.teal,
              width: 10,
            ),
          ),
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.question_answer_outlined),
                        iconSize: 100,
                        onPressed: () {
                          DDNApp.navigatorKey.currentState
                              ?.pushNamed('/filter-property');
                        },
                      ),
                      const Text('Survey')
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_chart_outlined),
                        iconSize: 100,
                        onPressed: () {
                          DDNApp.navigatorKey.currentState
                              ?.pushNamed('/add-property');
                        },
                      ),
                      const Text('Add Property')
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.dashboard_customize_outlined),
                        iconSize: 100,
                        onPressed: () {},
                      ),
                      const Text('Dashboard')
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.report_gmailerrorred_outlined),
                        iconSize: 100,
                        onPressed: () {},
                      ),
                      const Text('Reports')
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.account_box_outlined),
                        iconSize: 100,
                        onPressed: () {},
                      ),
                      const Text('About')
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.policy_outlined),
                        iconSize: 100,
                        onPressed: () {},
                      ),
                      const Text('Privacy Policy')
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Future<Account> getAccount() async {
    final accountResponse = await authorizedGetRequest(
        Uri.parse('${AppConstant.baseUrl}/api/account'),
        {'Content-Type': 'application/json'});
    final account =
        DDNApp.account = Account.fromJson(jsonDecode(accountResponse.body));
    return account;
  }

  Future<UserInfo> getUserInfo() async {
    final accountResponse = await authorizedGetRequest(
        Uri.parse('${AppConstant.baseUrl}/api/account'),
        {'Content-Type': 'application/json'});
    final account = Account.fromJson(jsonDecode(accountResponse.body));
    final userInfoResponse = await authorizedGetRequest(
        Uri.parse(
            '${AppConstant.baseUrl}/api/user-info/get-user-infos-by-login/${account.login}'),
        {'Content-Type': 'application/json'});
    final userInfo =
        DDNApp.userInfo = UserInfo.fromJson(jsonDecode(userInfoResponse.body));
    return userInfo;
  }
}
