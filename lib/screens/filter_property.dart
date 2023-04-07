import 'dart:convert';

import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/model/property_details.model.dart';
import 'package:ddnbilaspur_mob/screens/property_card.dart';
import 'package:ddnbilaspur_mob/screens/property_details.dart';
import 'package:flutter/material.dart';

import '../ddn_app.dart';
import '../model/property.model.dart';
import '../service/http_request.service.dart';
import 'survey_basic.dart';

class FilterProperty extends StatefulWidget {
  const FilterProperty({Key? key}) : super(key: key);

  @override
  State<FilterProperty> createState() => _FilterPropertyState();
}

class _FilterPropertyState extends State<FilterProperty> {
  final _formKey = GlobalKey<FormState>();

  final propertyUidController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileNumberController = TextEditingController();

  late bool _error = false;
  late bool _loading = false;
  late List<Property> _properties = [];

  @override
  void dispose() {
    propertyUidController.dispose();
    ownerNameController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String?> wards = [];
    for (var i = 0; i < DDNApp.userInfo!.wards!.length; ++i) {
      var ward = DDNApp.userInfo!.wards![i];
      wards.add(ward.wardNumber);
    }
    return Scaffold(
        backgroundColor: Colors.white,
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
              const Text('Filter Property',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: mobileNumberController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Filter by Mobile Number',
                            hintText: 'Mobile Number'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: ownerNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Filter by Owner Name',
                            hintText: 'Owner Name'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        validator: (value) {
                          if (ownerNameController.text.isEmpty &&
                              mobileNumberController.text.isEmpty &&
                              propertyUidController.text.isEmpty) {
                            return 'No filters set';
                          }
                        },
                        controller: propertyUidController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Filter by Property Uid',
                            hintText: 'Property Uid'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                            fetchData();
                          }
                        },
                        child: _loading
                            ? const CircularProgressIndicator()
                            : const Text("Submit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25)),
                      ),
                    ),
                    ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: 300, minHeight: 200),
                        child: buildPropertyList())
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> fetchData() async {
    if (_formKey.currentState == null) {
      return;
    }
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    var url = "${AppConstant.baseUrl}/api/properties?page=0&size=20";
    if (propertyUidController.text.isNotEmpty) {
      url += '&propertyUid.contains=${propertyUidController.text}';
    }
    if (mobileNumberController.text.isNotEmpty) {
      url += '&mobileNumber.contains=${mobileNumberController.text}';
    }
    if (ownerNameController.text.isNotEmpty) {
      final propertyDetailResponse = await authorizedGetRequest(
          Uri.parse(
              '${AppConstant.baseUrl}/api/property-details?size=300&ownerName.contains=${ownerNameController.text}'),
          {'Content-Type': 'application/json'});
      final propertyDetailResponseList =
          jsonDecode(propertyDetailResponse.body);
      for (var i = 0; i < propertyDetailResponseList.length; ++i) {
        var propertyDetailJson = propertyDetailResponseList[i];
        final propertyDetails = PropertyDetails.fromJson(propertyDetailJson);
        url += '&propertyDetailsId.in=${propertyDetails.id}';
      }
    }

    final response = await authorizedGetRequest(
        Uri.parse(url), {'Content-Type': 'application/json'});
    final responseList = jsonDecode(response.body);
    List<Property> propertyList = [];
    for (var i = 0; i < responseList.length; ++i) {
      var response = responseList[i];
      final property = Property.fromJson(response);
      final response1 = await authorizedGetRequest(
          Uri.parse(
              '${AppConstant.baseUrl}/api/property-details/${property.propertyDetails!.id}'),
          {'Content-Type': 'application/json'});

      property.propertyDetails =
          PropertyDetails.fromJson(jsonDecode(response1.body));
      propertyList.add(property);
    }
    setState(() {
      _loading = false;
      _properties = propertyList;
    });
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the properties!',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }

  Widget buildPropertyList() {
    if (_properties.isEmpty) {
      return const Center(
        child: Text('Submit filtering data to get list of properties!'),
      );
    }
    if (_properties.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(child: errorDialog(size: 20));
      }
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          final Property property = _properties[index];
          property.surveyed ??= false;
          return ListTile(
            title: PropertyCard(
              property: property,
            ),
            onTap: () async {
              if (property.propertyStatus == 'DOWNLOADED' ||
                  property.propertyStatus == 'VISIT_AGAIN') {
                final done = Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SurveyBasic(property: property)));
                setState(() {
                  _properties = [];
                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PropertyDetailsView(property: property)));
              }
            },
          );
        });
  }
}
