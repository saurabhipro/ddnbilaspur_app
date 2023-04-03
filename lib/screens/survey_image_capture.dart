import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ddnbilaspur_mob/app-const/app_constants.dart';
import 'package:ddnbilaspur_mob/model/device_vitals.model.dart';
import 'package:ddnbilaspur_mob/screens/vitals_card.dart';
import 'package:ddnbilaspur_mob/service/http_request.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../ddn_app.dart';
import '../model/property.model.dart';
import 'camera.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({Key? key, required this.property}) : super(key: key);
  final Property property;

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  DeviceVitals deviceVitals = DeviceVitals(
      null, null, null, null, null, null, null, null, null, null, null, null);
  bool _deviceVitalsSet = false;
  XFile? image1;
  XFile? image2;

  @override
  void initState() {
    _getVitals();
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
            const SizedBox(height: 10),
            _deviceVitalsSet
                ? VitalsCard(deviceVitals: deviceVitals)
                : const CircularProgressIndicator(),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                final image1 = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Camera()));
                setState(() {
                  this.image1 = image1;
                });
              },
              child: Center(
                child: image1 == null
                    ? Image.asset('assets/images/camera_placeholder.png')
                    : Image.file(File(image1!.path)),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                final image2 = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Camera()));
                setState(() {
                  this.image2 = image2;
                });
              },
              child: Center(
                child: image2 == null
                    ? Image.asset('assets/images/camera_placeholder.png')
                    : Image.file(File(image2!.path)),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  if (_submitImageLatLong()) {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }
                },
                child: const Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getVitals() async {
    try {
      Position position = await _determinePosition();
      deviceVitals.latitude = position.latitude;
      deviceVitals.longitude = position.longitude;
      deviceVitals.altitude = position.altitude;
      setState(() {
        _deviceVitalsSet = true;
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

  bool _submitImageLatLong() {
    if (image1 == null || image2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please click both photos before, submitting!')));
      return false;
    }
    deviceVitals.image1 = base64Encode(File(image1!.path).readAsBytesSync());
    deviceVitals.image1FileType = 'image/jpeg';
    deviceVitals.image2 = base64Encode(File(image2!.path).readAsBytesSync());
    deviceVitals.image2FileType = 'image/jpeg';
    authorizedPostRequest(
        Uri.parse(
            "${AppConstant.baseUrl}/api/surveys/image-capture/${widget.property.id}"),
        {"Content-Type": "application/json"},
        jsonEncode(deviceVitals));
    return true;
  }
}
