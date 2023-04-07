import 'dart:ffi';

import 'package:ddnbilaspur_mob/model/user_info.model.dart';

import '../model/property_type.model.dart';

class Survey {
  int? id;
  String? surveyId;
  String? timeOfSurvey;
  double? latitude;
  double? longitude;
  double? heightFromSeaLevel;
  String? memo;
  String? signalStrength;
  String? satelliteCount;
  String? androidVersion;
  String? mobileModel;
  String? batteryStatus;
  String? ownerName;
  String? fatherSpouseName;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? rationCardNumber;
  bool? bpLevel;
  String? bpNumber;
  UserInfo? surveyor;
  List<PropertyType>? propertyTypes;

  Survey(
      {this.id,
      this.surveyId,
      this.timeOfSurvey,
      this.latitude,
      this.longitude,
      this.heightFromSeaLevel,
      this.memo,
      this.signalStrength,
      this.satelliteCount,
      this.androidVersion,
      this.mobileModel,
      this.batteryStatus,
      this.ownerName,
      this.fatherSpouseName,
      this.mobileNumber,
      this.alternateMobileNumber,
      this.rationCardNumber,
      this.bpLevel,
      this.bpNumber,
      this.surveyor,
      this.propertyTypes});

  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surveyId = json['surveyId'];
    timeOfSurvey = json['timeOfSurvey'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    heightFromSeaLevel = json['heightFromSeaLevel'];
    memo = json['memo'];
    signalStrength = json['signalStrength'];
    satelliteCount = json['satelliteCount'];
    androidVersion = json['androidVersion'];
    mobileModel = json['mobileModel'];
    batteryStatus = json['batteryStatus'];
    ownerName = json['ownerName'];
    fatherSpouseName = json['fatherSpouseName'];
    mobileNumber = json['mobileNumber'];
    alternateMobileNumber = json['alternateMobileNumber'];
    rationCardNumber = json['rationCardNumber'];
    bpLevel = json['bpLevel'];
    bpNumber = json['bpNumber'];
    surveyor =
        json['surveyor'] != null ? UserInfo.fromJson(json['surveyor']) : null;
    if (json['propertyTypes'] != null) {
      propertyTypes = <PropertyType>[];
      json['propertyTypes'].forEach((v) {
        propertyTypes!.add(PropertyType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['surveyId'] = surveyId;
    data['timeOfSurvey'] = timeOfSurvey;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['heightFromSeaLevel'] = heightFromSeaLevel;
    data['memo'] = memo;
    data['signalStrength'] = signalStrength;
    data['satelliteCount'] = satelliteCount;
    data['androidVersion'] = androidVersion;
    data['mobileModel'] = mobileModel;
    data['batteryStatus'] = batteryStatus;
    data['ownerName'] = ownerName;
    data['fatherSpouseName'] = fatherSpouseName;
    data['mobileNumber'] = mobileNumber;
    data['alternateMobileNumber'] = alternateMobileNumber;
    data['rationCardNumber'] = rationCardNumber;
    data['bpLevel'] = bpLevel;
    data['bpNumber'] = bpNumber;
    if (surveyor != null) {
      data['surveyor'] = surveyor!.toJson();
    }
    if (propertyTypes != null) {
      data['propertyTypes'] = propertyTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
