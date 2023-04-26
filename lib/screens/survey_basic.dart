import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ddnbilaspur_mob/model/surveyWithImages.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../app-const/app_constants.dart';
import '../ddn_app.dart';
import '../model/device_vitals.model.dart';
import '../model/property.model.dart';
import '../model/property_type.model.dart';
import '../model/survey.model.dart';
import '../service/http_request.service.dart';
import 'camera.dart';

class SurveyBasic extends StatefulWidget {
  const SurveyBasic({Key? key, required this.property}) : super(key: key);
  final Property property;

  @override
  State<SurveyBasic> createState() => _SurveyBasicState();
}

class _SurveyBasicState extends State<SurveyBasic> {
  final _formKey = GlobalKey<FormState>();
  Map<PropertyType, bool?> selectedPropertyTypes = {};
  late final List<PropertyType> propertyTypes;
  var _rationCardNumber = false;
  var _bpLevel = false;
  var _propertyListAvailable = false;
  CapturedImages deviceVitals =
      CapturedImages(null, null, null, null, null, null);
  double? longitude;
  double? latitude;
  double? altitude;
  bool _loadingFormData = false;
  bool _latLongAltSet = false;
  bool image1Found = false;
  XFile? image1;
  bool image2Found = false;
  XFile? image2;
  bool _submitted = false;

  final mobileNumberController = TextEditingController();
  final alternateMobileNumberController = TextEditingController();
  final rationCardNumberController = TextEditingController();
  final bpNumberController = TextEditingController();
  final fatherNameController = TextEditingController();
  final ownerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPropertyTypes();
    if (widget.property.surveyed == null || !widget.property.surveyed!) {
      mobileNumberController.text = widget.property.mobileNumber ?? '';
      alternateMobileNumberController.text =
          widget.property.alternateMobileNumber ?? '';
      ownerNameController.text =
          widget.property.propertyDetails!.ownerName == null
              ? ''
              : widget.property.propertyDetails!.ownerName!;
      fatherNameController.text =
          widget.property.propertyDetails!.fatherName == null
              ? ''
              : widget.property.propertyDetails!.fatherName!;
    } else {
      _getOldSurvey();
    }
    _getLatLongAlt();
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    alternateMobileNumberController.dispose();
    rationCardNumberController.dispose();
    bpNumberController.dispose();
    fatherNameController.dispose();
    ownerNameController.dispose();
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
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Survey: Basic',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  OutlinedButton(
                      onPressed: _submitted
                          ? null
                          : () {
                              setState(() {
                                _submitted = true;
                                authorizedPostRequest(
                                    Uri.parse(
                                        "${AppConstant.baseUrl}/api/properties/visit-again"),
                                    {"Content-Type": "application/json"},
                                    jsonEncode(widget.property));
                                Navigator.pop(context, true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Property Set For Visit Again!')));
                              });
                            },
                      child: (!_submitted
                          ? (const Text('Not Available'))
                          : const SizedBox(
                              height: 10.0,
                              width: 10.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.lime,
                              ))))
                ],
              ),
              if (_loadingFormData) const Text('Loading....'),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: ownerNameController,
                  validator: (value) {
                    if (ownerNameController.text.isEmpty) {
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
                  controller: fatherNameController,
                  validator: (value) {
                    if (fatherNameController.text.isEmpty) {
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
                  keyboardType: TextInputType.number,
                  controller: mobileNumberController,
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
                  keyboardType: TextInputType.number,
                  controller: alternateMobileNumberController,
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
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: _rationCardNumber,
                    onChanged: (bool value) {
                      setState(() {
                        _rationCardNumber = value;
                      });
                    },
                  ),
                  const Text('Add Ration Card Number')
                ],
              ),
              Visibility(
                visible: _rationCardNumber,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: rationCardNumberController,
                    validator: (value) {
                      if (_rationCardNumber &&
                          rationCardNumberController.text.isEmpty) {
                        return 'Ration Card Number can\'t be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ration Card Number',
                        hintText: 'Enter Ration Card Number'),
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: _bpLevel,
                    onChanged: (bool value) {
                      setState(() {
                        _bpLevel = value;
                      });
                    },
                  ),
                  const Text('Add BP Number')
                ],
              ),
              Visibility(
                visible: _bpLevel,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: bpNumberController,
                    validator: (value) {
                      if (_bpLevel && bpNumberController.text.isEmpty) {
                        return 'BP Number can\'t be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'BP Number',
                        hintText: 'Enter BP Number'),
                  ),
                ),
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
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () async {
                        final image1 = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Camera()));
                        setState(() {
                          this.image1 = image1;
                          image1 == null
                              ? image1Found = false
                              : image1Found = true;
                        });
                      },
                      child: Center(
                        child: image1 == null
                            ? Image.asset(
                                'assets/images/camera_placeholder.png')
                            : Image.file(File(image1!.path)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () async {
                        final image2 = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Camera()));
                        setState(() {
                          this.image2 = image2;
                          image2 == null
                              ? image2Found = false
                              : image2Found = true;
                        });
                      },
                      child: Center(
                        child: image2 == null
                            ? Image.asset(
                                'assets/images/camera_placeholder.png')
                            : Image.file(File(image2!.path)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 10),
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
                                    title: const Text('Confirm Survey'),
                                    content: const Text(
                                        'Are You Sure to submit the survey?'),
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
                                              _saveSurvey();
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Basic survey updated for property!')));
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

  _getLatLongAlt() async {
    try {
      Position position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      altitude = position.altitude;
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
      if (_setExistingPropertyTypes(propertyType)) {
        selectedPropertyTypes[propertyType] = true;
      }
    }
    setState(() {
      _propertyListAvailable = true;
    });
    this.propertyTypes = propertyTypes;
    return propertyTypes;
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

  _setExistingPropertyTypes(PropertyType propertyType) {
    if (widget.property.propertyTypes == null) {
      return false;
    }
    for (var i = 0; i < widget.property.propertyTypes!.length; ++i) {
      var existingPropertyType = widget.property.propertyTypes![i];
      if (existingPropertyType.properName == propertyType.properName) {
        return true;
      }
    }
    return false;
  }

  _validateMobile() {
    if (mobileNumberController.text.isEmpty &&
        alternateMobileNumberController.text.isEmpty) {
      return 'Mobile Number and Alternate Mobile Number both can\'t be empty';
    }
    var enteredValue = mobileNumberController.text.isNotEmpty
        ? mobileNumberController.text
        : alternateMobileNumberController.text;
    RegExp mobileNumber = RegExp(r'^[1-9][0-9]{9}$');
    if (!mobileNumber.hasMatch(enteredValue)) {
      return 'Please enter a 10 digit mobile number not starting with 0';
    }
    return null;
  }

  _saveSurvey() {
    Survey survey = Survey();
    survey.ownerName = ownerNameController.text;
    survey.surveyId = widget.property.propertyUid;
    survey.fatherSpouseName = fatherNameController.text;
    survey.mobileNumber = mobileNumberController.text.isEmpty
        ? null
        : mobileNumberController.text;
    survey.alternateMobileNumber = alternateMobileNumberController.text.isEmpty
        ? null
        : alternateMobileNumberController.text;
    survey.rationCardNumber = rationCardNumberController.text.isNotEmpty
        ? rationCardNumberController.text
        : null;
    survey.bpLevel = _bpLevel;
    survey.bpNumber = _bpLevel ? bpNumberController.text : null;
    survey.propertyTypes = [];
    for (var key in selectedPropertyTypes.keys) {
      survey.propertyTypes?.add(key);
    }
    survey.longitude = longitude;
    survey.latitude = latitude;
    survey.heightFromSeaLevel = altitude;
    widget.property.survey = survey;
    CapturedImages images = CapturedImages(
        image1Found,
        image1Found ? base64Encode(File(image1!.path).readAsBytesSync()) : null,
        'image/jpeg',
        image2Found,
        image2Found ? base64Encode(File(image2!.path).readAsBytesSync()) : null,
        'image/jpeg');
    SurveyWithProperty surveyWithProperty =
        SurveyWithProperty(widget.property, images);
    authorizedPostRequest(
        Uri.parse("${AppConstant.baseUrl}/api/surveys/survey-with-image"),
        {'Content-Type': 'application/json'},
        jsonEncode(surveyWithProperty));
  }

  Future<void> _getOldSurvey() async {
    setState(() {
      _loadingFormData = true;
    });
    final response = await authorizedGetRequest(
        Uri.parse(
            '${AppConstant.baseUrl}/api/surveys/get-one/${widget.property.survey!.id}'),
        {"Content_Type": "application/json"});
    widget.property.survey = Survey.fromJson(jsonDecode(response.body));
    setState(() {
      mobileNumberController.text = widget.property.survey!.mobileNumber ?? '';
      alternateMobileNumberController.text =
          widget.property.survey!.alternateMobileNumber ?? '';
      ownerNameController.text = widget.property.survey!.ownerName == null
          ? ''
          : widget.property.survey!.ownerName!;
      fatherNameController.text =
          widget.property.survey!.fatherSpouseName == null
              ? ''
              : widget.property.survey!.fatherSpouseName!;

      _loadingFormData = false;
    });
  }
}
