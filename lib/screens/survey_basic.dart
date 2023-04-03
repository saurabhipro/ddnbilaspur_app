import 'dart:convert';

import 'package:flutter/material.dart';

import '../app-const/app_constants.dart';
import '../ddn_app.dart';
import '../model/property.model.dart';
import '../model/property_type.model.dart';
import '../model/survey.model.dart';
import '../service/http_request.service.dart';

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
  var _submitted = false;

  final mobileNumberController = TextEditingController();
  final alternateMobileNumberController = TextEditingController();
  final rationCardNumberController = TextEditingController();
  final bpNumberController = TextEditingController();
  final fatherNameController = TextEditingController();
  final ownerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPropertyTypes();
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
                                Navigator.pop(context);
                                Navigator.pop(context);
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
                  controller: mobileNumberController,
                  validator: (value) {
                    return validateMobile();
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
                  controller: alternateMobileNumberController,
                  validator: (value) {
                    return validateMobile();
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
              _propertyListAvailable
                  ? getPropertyListView()
                  : const Center(child: CircularProgressIndicator()),
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
                          if (_formKey.currentState!.validate()) {
                            _submitted = true;
                            saveSurvey();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Basic survey updated for property!')));
                          }
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

  Future<List<PropertyType>> getPropertyTypes() async {
    final response = await authorizedGetRequest(
        Uri.parse('${AppConstant.baseUrl}/api/property-types?page=0&size=20'),
        {'Content-Type': 'application/json'});
    final list = jsonDecode(response.body);
    List<PropertyType> propertyTypes = [];
    for (var i = 0; i < list.length; ++i) {
      var propertyTypeJson = list[i];
      var propertyType = PropertyType.fromJson(propertyTypeJson);
      propertyTypes.add(propertyType);
      if (setExistingPropertyTypes(propertyType)) {
        selectedPropertyTypes[propertyType] = true;
      }
    }
    setState(() {
      _propertyListAvailable = true;
    });
    this.propertyTypes = propertyTypes;
    return propertyTypes;
  }

  getPropertyListView() {
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

  setExistingPropertyTypes(PropertyType propertyType) {
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

  validateMobile() {
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

  saveSurvey() {
    Survey survey = Survey();
    survey.ownerName = ownerNameController.text;
    survey.fatherSpouseName = fatherNameController.text;
    survey.mobileNumber = mobileNumberController.text;
    survey.alternateMobileNumber = alternateMobileNumberController.text;
    survey.rationCardNumber = rationCardNumberController.text.isNotEmpty
        ? rationCardNumberController.text
        : null;
    survey.bpLevel = _bpLevel;
    survey.bpNumber = _bpLevel ? bpNumberController.text : null;
    survey.propertyTypes = [];
    for (var key in selectedPropertyTypes.keys) {
      survey.propertyTypes?.add(key);
    }
    widget.property.survey = survey;
    authorizedPostRequest(Uri.parse("${AppConstant.baseUrl}/api/surveys"),
        {'Content-Type': 'application/json'}, jsonEncode(widget.property));
  }
}
