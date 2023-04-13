import 'dart:convert';

import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/model/survey.model.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';

import '../ddn_app.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _totalInstalledAvailable = false;
  int? _totalInstalled;
  bool _visitAgainAvailable = false;
  int? _visitAgain;
  bool _notFoundAvailable = false;
  int? _notFound;
  bool _installedTodayAvailable = false;
  int? _installedToday;

  @override
  void initState() {
    _getTotalDashboardData();
    _getNotAvailableData();
    _getNotFoundData();
    _getSurveysDoneToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String?> wards = [];
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      var ward = DDNApp.userInfo!.wards![i];
      wards.add(ward.wardNumber);
    }
    return Scaffold(
      appBar: AppBar(
          title: Column(
        children: [
          Center(
            child: Text(
                '${DDNApp.account!.firstName} ${DDNApp.account!.lastName}',
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
          Center(
            child: Text('Wards: $wards',
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
        ],
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text('Dashboard',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Card(
                  color: Colors.blueGrey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.home),
                      const Center(
                        child: Text(
                          'Total Installed',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Center(
                        child: (!_totalInstalledAvailable)
                            ? const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : Text(
                                '${_totalInstalled!}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                Card(
                  color: Colors.brown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.home),
                      const Center(
                        child: Text(
                          'Not Available',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Center(
                        child: !_visitAgainAvailable
                            ? const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : Text(
                                '${_visitAgain!}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                Card(
                  color: Colors.brown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.home),
                      const Center(
                        child: Text(
                          'Not Found',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Center(
                        child: !_notFoundAvailable
                            ? const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ))
                            : Text(
                                '${_notFound!}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                Card(
                  color: Colors.brown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.home),
                      const Center(
                        child: Text(
                          'Installed Today',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Center(
                        child: !_installedTodayAvailable
                            ? const CircularProgressIndicator()
                            : Text(
                                '$_installedToday',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                Card(
                  color: Colors.brown,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(Icons.home),
                      const Center(
                        child: Text(
                          'Total Wards',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${DDNApp.userInfo!.wards!.length}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _getTotalDashboardData() {
    _getTotalInstalled();
  }

  _getTotalInstalled() async {
    String url =
        '${AppConstant.baseUrl}/api/properties/count?propertyStatus.equals=DOWNLOADED';
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      url += '&wardId.in=${DDNApp.userInfo!.wards![i].id}';
    }
    final response =
        await authorizedGetRequest(Uri.parse(url), {'accept': '*/*'});
    setState(() {
      _totalInstalled = int.parse(response.body ?? '0');
      _totalInstalledAvailable = true;
    });
  }

  _getNotAvailableData() async {
    String url =
        '${AppConstant.baseUrl}/api/properties/count?propertyStatus.equals=VISIT_AGAIN';
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      url += '&wardId.in=${DDNApp.userInfo!.wards![i].id}';
    }
    final response =
        await authorizedGetRequest(Uri.parse(url), {'accept': '*/*'});
    setState(() {
      _visitAgain = int.parse(response.body ?? '0');
      _visitAgainAvailable = true;
    });
  }

  _getNotFoundData() async {
    String url =
        '${AppConstant.baseUrl}/api/properties/count?discoveredInSurvey.equals=true';
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      url += '&wardId.in=${DDNApp.userInfo!.wards![i].id}';
    }
    final response =
        await authorizedGetRequest(Uri.parse(url), {'accept': '*/*'});
    setState(() {
      _notFound = int.parse(response.body ?? '0');
      _notFoundAvailable = true;
    });
  }

  _getSurveysDoneToday() async {
    final currentTime = DateTime.now();
    final currentDate =
        DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0);
    String surveyUrl =
        '${AppConstant.baseUrl}/api/surveys?timeOfSurvey.greaterThan=${currentDate.toIso8601String()}Z';
    String propertyCountUrl =
        '${AppConstant.baseUrl}/api/properties/count?propertyStatus.equals=INSTALLED';
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      propertyCountUrl += '&wardId.in=${DDNApp.userInfo!.wards![i].id}';
    }
    final surveyResponse = await authorizedGetRequest(
        Uri.parse(surveyUrl), {'Content-Type': 'application/json'});
    final responseList = jsonDecode(surveyResponse.body);
    if (responseList.length == 0) {
      propertyCountUrl += '&surveyId.in=0';
    } else {
      for (var i = 0; i < responseList.length; ++i) {
        var responseSurvey = responseList[i];
        final Survey survey = Survey.fromJson(responseSurvey);
        propertyCountUrl += '&surveyId.in=${survey.id}';
      }
    }
    final propertyCountResponse = await authorizedGetRequest(
        Uri.parse(propertyCountUrl), {'accept': '*/*'});
    setState(() {
      _installedToday = int.parse(propertyCountResponse.body ?? '0');
      _installedTodayAvailable = true;
    });
  }
}
