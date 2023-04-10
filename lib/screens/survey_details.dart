import 'dart:convert';

import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/model/blob_resource.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';

import '../model/survey.model.dart';

class SurveyDetails extends StatefulWidget {
  const SurveyDetails({Key? key, required this.survey}) : super(key: key);
  final Survey? survey;

  @override
  State<SurveyDetails> createState() => _SurveyDetailsState();
}

class _SurveyDetailsState extends State<SurveyDetails> {
  final surveyIdController = TextEditingController();
  final timeOfSurvey = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  final altitude = TextEditingController();
  final ownerName = TextEditingController();
  final fatherSpouseName = TextEditingController();
  final mobileNumber = TextEditingController();
  final alternateMobileNumber = TextEditingController();
  final rationCardNumber = TextEditingController();
  final bpNumber = TextEditingController();
  String propertyTypes = '';
  bool image1Loading = false;
  bool image2loading = false;
  String image1 = '';
  String image2 = '';

  @override
  void initState() {
    super.initState();
    if (widget.survey == null) return;
    final Survey? survey = widget.survey;
    surveyIdController.text = survey!.surveyId ?? '';
    timeOfSurvey.text = survey!.timeOfSurvey ?? '';
    latitude.text = survey!.latitude != null ? survey.latitude.toString() : '';
    longitude.text =
        survey.longitude != null ? survey.longitude.toString() : '';
    altitude.text = survey.heightFromSeaLevel != null
        ? survey.heightFromSeaLevel.toString()
        : '';
    ownerName.text = survey!.ownerName ?? '';
    fatherSpouseName.text = survey.fatherSpouseName ?? '';
    mobileNumber.text = survey.mobileNumber ?? '';
    alternateMobileNumber.text = survey.alternateMobileNumber ?? '';
    rationCardNumber.text = survey.rationCardNumber ?? '';
    bpNumber.text = survey.bpNumber ?? '';
    if (survey.propertyTypes != null && survey.propertyTypes!.isNotEmpty) {
      for (var i = 0; i < survey!.propertyTypes!.length; ++i) {
        final propertyType = survey!.propertyTypes![i];
        propertyTypes += ' ${propertyType.properName!}';
      }
    }
    _getSurveyImage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.survey == null
        ? const Text('Survey Not Available!')
        : Column(
            children: [
              const Text('Survey Details',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: surveyIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Survey ID',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: timeOfSurvey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time Of Survey',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: latitude,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Latitude',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: longitude,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Longitude',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: altitude,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Height from Sea Level',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: ownerName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Owner name',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: fatherSpouseName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Father/Spouse Name',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: mobileNumber,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: alternateMobileNumber,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Alternate Mobile Number',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: rationCardNumber,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ration Card Number',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  enabled: false,
                  controller: bpNumber,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'BP Number',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Property Types: $propertyTypes')),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                      flex: 1,
                      child: image1Loading
                          ? const CircularProgressIndicator()
                          : Image.memory(
                              const Base64Decoder().convert(image1),
                              fit: BoxFit.scaleDown,
                            )),
                  const SizedBox(width: 5),
                  Expanded(
                      flex: 1,
                      child: image2loading
                          ? const CircularProgressIndicator()
                          : Image.memory(
                              const Base64Decoder().convert(image2),
                            )),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 10),
            ],
          );
  }

  _getSurveyImage() async {
    image1Loading = true;
    image2loading = true;
    final response = await authorizedGetRequest(
        Uri.parse(
            '${AppConstant.baseUrl}/api/blob-resources?surveyId.equals=${widget.survey!.id}'),
        {'Content-Type': 'application/json'});
    final fileList = jsonDecode(response.body);
    final BlobResource blobResource1 = BlobResource.fromJson(fileList[0]);
    final BlobResource blobResource2 = BlobResource.fromJson(fileList[1]);
    setState(() {
      image1 = blobResource1.fileContent!;
      image2 = blobResource2.fileContent!;
      image1Loading = false;
      image2loading = false;
    });
  }
}
