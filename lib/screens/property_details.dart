import 'dart:convert';

import 'package:ddnbilaspur_mob/screens/survey_details.dart';
import 'package:flutter/material.dart';

import '../app-const/app_constants.dart';
import '../ddn_app.dart';
import '../model/property.model.dart';
import '../model/survey.model.dart';
import '../service/http_request.service.dart';

class PropertyDetailsView extends StatefulWidget {
  const PropertyDetailsView({Key? key, required this.property})
      : super(key: key);
  final Property property;

  @override
  State<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<PropertyDetailsView> {
  final ddnStringController = TextEditingController();
  final propertyUidController = TextEditingController();
  final wardNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final mobileController = TextEditingController();
  Survey? survey;

  bool _loadingSurveyData = false;

  @override
  void initState() {
    _getSurvey();
    ddnStringController.text = widget.property.ddnString!;
    propertyUidController.text = widget.property.propertyUid!;
    wardNameController.text = widget.property.ward!.wardName!;
    ownerNameController.text = widget.property.propertyDetails == null
        ? 'Property Details Not Available'
        : (widget.property.propertyDetails!.ownerName == null
            ? ''
            : widget.property.propertyDetails!.ownerName!);
    mobileController.text = widget.property.mobileNumber!;
    super.initState();
  }

  @override
  void dispose() {
    ddnStringController.dispose();
    propertyUidController.dispose();
    wardNameController.dispose();
    ownerNameController.dispose();
    mobileController.dispose();
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
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Property Details',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: ddnStringController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'DDN String',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: propertyUidController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'PropertyUid',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: wardNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ward',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: ownerNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Owner Name',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: mobileController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _loadingSurveyData
                  ? const CircularProgressIndicator()
                  : SurveyDetails(survey: survey),
            ],
          ),
        ));
  }

  Future<void> _getSurvey() async {
    setState(() {
      _loadingSurveyData = true;
    });
    final response = await authorizedGetRequest(
        Uri.parse(
            '${AppConstant.baseUrl}/api/surveys/get-one/${widget.property.survey!.id}'),
        {"Content_Type": "application/json"});
    final survey = Survey.fromJson(jsonDecode(response.body));
    setState(() {
      _loadingSurveyData = false;
      this.survey = survey;
    });
  }
}
