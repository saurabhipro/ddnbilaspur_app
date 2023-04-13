import 'dart:convert';

import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';

import '../app-const/app_constants.dart';
import '../ddn_app.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final List<String?> _wards = [];
  final Map<String, String> _zone = {};
  final Map<String, int> _total = {};
  final Map<String, int> _installed = {};
  bool _dataAvailable = false;

  @override
  void initState() {
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      var ward = DDNApp.userInfo!.wards![i];
      _wards.add(ward.wardNumber);
    }
    _getWardWiseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Text('Wards: $_wards',
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ),
        ],
      )),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text('Ward Wise Report',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Zone'),
              Text('Ward'),
              Text('Total'),
              Text('Installed'),
            ],
          ),
          _dataAvailable
              ? Expanded(
                  child: ListView.builder(
                      itemCount: DDNApp.userInfo!.wards!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ward = DDNApp.userInfo!.wards![index];
                        bool totalPropertiesAvailable = false;
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(ward.wardNumber!),
                              Text('${_total[ward.wardNumber]}'),
                              Text('${_installed[ward.wardNumber]}')
                            ],
                          ),
                        );
                      }),
                )
              : const SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )),
        ],
      ),
    );
  }

  _getWardWiseData() async {
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      final total = await authorizedGetRequest(
          Uri.parse(
              '${AppConstant.baseUrl}/api/properties/count?wardId.equals=${DDNApp.userInfo!.wards![i].id}'),
          {'accept': '*/*'});
      _total['${DDNApp.userInfo!.wards![i].id}'] = int.parse(total.body);
      final installed = await authorizedGetRequest(
          Uri.parse(
              '${AppConstant.baseUrl}/api/properties/count?propertyStatus.equals=INSTALLED&wardId.in=${DDNApp.userInfo!.wards![i].id}'),
          {'accept': '*/*'});
      _installed['${DDNApp.userInfo!.wards![i].id}'] =
          int.parse(installed.body);
      final zone = authorizedGetRequest(
          Uri.parse('wardId.equals=62'), {'accept': '*/*'});
    }
    setState(() {
      _dataAvailable = true;
    });
  }
}
