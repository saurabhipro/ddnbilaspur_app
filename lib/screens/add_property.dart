import 'dart:convert';

import 'package:ddnbilaspur_mob/model/property.model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../app-const/app_constants.dart';
import '../ddn_app.dart';
import '../model/property_details.model.dart';
import '../model/property_type.model.dart';
import '../service/http_request.service.dart';

class AddProperty extends StatefulWidget {
  const AddProperty({Key? key}) : super(key: key);

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final _formKey = GlobalKey<FormState>();

  final propertyUid = TextEditingController();
  final ddnString = TextEditingController();
  final mobile = TextEditingController();
  final alternateMobile = TextEditingController();
  final address = TextEditingController();
  final ownerName = TextEditingController();
  final fatherName = TextEditingController();
  double? longitude;
  double? latitude;
  Map<PropertyType, bool?> selectedPropertyTypes = {};
  late final List<PropertyType> propertyTypes;

  bool _latLongAltSet = false;
  bool _submitted = false;
  bool _propertyListAvailable = false;

  @override
  void initState() {
    super.initState();
    _getPropertyTypes();
    _getLatLongAlt();
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Add Property',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: ownerName,
                  validator: (value) {
                    if (ownerName.text.isEmpty) {
                      return 'Owner Name can\'t be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Owner Name',
                      hintText: 'Enter Owner name'),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: fatherName,
                  validator: (value) {
                    if (fatherName.text.isEmpty) {
                      return 'Father/Spouse Name can\'t be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Father/Spouse Name',
                      hintText: 'Enter Father/Spouse name'),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: mobile,
                  validator: (value) {
                    return _validateMobile();
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile Number',
                      hintText: 'Enter Mobile Number'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: alternateMobile,
                  validator: (value) {
                    return _validateMobile();
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alternate Mobile Number',
                      hintText: 'Enter Alternate Mobile Number'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: address,
                  validator: (value) {
                    if (address.text.isEmpty) {
                      return 'Address can\'t be empty!';
                    }
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Enter Address'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _getPropertyListView(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _latLongAltSet
                      ? Column(
                          children: [
                            Text('Longitude: ${longitude.toString()}'),
                            Text('Latitude: ${latitude.toString()}'),
                          ],
                        )
                      : const CircularProgressIndicator(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _latLongAltSet = false;
                        });
                        _getLatLongAlt();
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: _submitted
                      ? null
                      : () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Confirm New Property'),
                                    content: const Text(
                                        'Are You Sure to add New Property?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _submitted = true;
                                              _addProperty();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'New Property Added!')));
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('OK'))
                                    ],
                                  ));
                        },
                  child: _submitted
                      ? const SizedBox(
                          height: 10.0,
                          width: 10.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.lime,
                          ))
                      : const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPropertyListView() {
    if (!_propertyListAvailable) {
      return const CircularProgressIndicator();
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200, minHeight: 10),
      child: ListView(
          children: propertyTypes.map((propertyType) {
        return CheckboxListTile(
            title: Text(propertyType.properName!),
            value: selectedPropertyTypes[propertyType] ?? false,
            onChanged: (value) {
              setState(() {
                selectedPropertyTypes[propertyType] = value;
              });
            });
      }).toList()),
    );
  }

  Future<List<PropertyType>> _getPropertyTypes() async {
    final response = await authorizedGetRequest(
        Uri.parse('${AppConstant.baseUrl}/api/property-types?page=0&size=20'),
        {'Content-Type': 'application/json'});
    final list = jsonDecode(response.body);
    List<PropertyType> propertyTypes = [];
    for (var i = 0; i < list.length; ++i) {
      var propertyTypeJson = list[i];
      var propertyType = PropertyType.fromJson(propertyTypeJson);
      propertyTypes.add(propertyType);
    }
    setState(() {
      _propertyListAvailable = true;
    });
    this.propertyTypes = propertyTypes;
    return propertyTypes;
  }

  _validateMobile() {
    if (mobile.text.isEmpty && alternateMobile.text.isEmpty) {
      return 'Mobile Number and Alternate Mobile Number both can\'t be empty';
    }
    var enteredValue =
        mobile.text.isNotEmpty ? mobile.text : alternateMobile.text;
    RegExp mobileNumber = RegExp(r'^[1-9][0-9]{9}$');
    if (!mobileNumber.hasMatch(enteredValue)) {
      return 'Please enter a 10 digit mobile number not starting with 0';
    }
    return null;
  }

  _getLatLongAlt() async {
    try {
      Position position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      setState(() {
        _latLongAltSet = true;
      });
    } catch (e) {
      print('position determination failed: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _addProperty() {
    List<PropertyType> propertyTypes = [];
    for (var propertyType in selectedPropertyTypes.keys) {
      propertyTypes.add(propertyType);
    }
    PropertyDetails propertyDetails = PropertyDetails(
      ownerName: ownerName.text,
      fatherName: fatherName.text,
    );
    Property property = Property(
        mobileNumber: mobile.text,
        alternateMobileNumber: alternateMobile.text,
        addressLine1: address.text,
        latitude: latitude,
        longitude: longitude,
        propertyDetails: propertyDetails,
        propertyTypes: propertyTypes);
    authorizedPostRequest(
        Uri.parse('${AppConstant.baseUrl}/api/properties/discoveredInSurvey'),
        {'Content-Type': 'application/json'},
        jsonEncode(property));
  }
}
