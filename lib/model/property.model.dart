import 'package:ddnbilaspur_mob/model/user_info.model.dart';

import 'property_details.model.dart';
import 'property_type.model.dart';
import 'survey.model.dart';
import 'ward.model.dart';

class Property {
  int? id;
  String? propertyUid;
  String? ddnString;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? addressLine1;
  double? longitude;
  double? latitude;
  String? propertyStatus;
  bool? discoveredInSurvey;
  bool? surveyed;
  PropertyDetails? propertyDetails;
  Survey? survey;
  Ward? ward;
  UserInfo? approver;
  List<PropertyType>? propertyTypes;

  Property(
      {this.id,
      this.propertyUid,
      this.ddnString,
      this.mobileNumber,
      this.alternateMobileNumber,
      this.addressLine1,
      this.longitude,
      this.latitude,
      this.propertyStatus,
      this.discoveredInSurvey,
      this.surveyed,
      this.propertyDetails,
      this.survey,
      this.ward,
      this.approver,
      this.propertyTypes});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyUid = json['propertyUid'];
    ddnString = json['ddnString'];
    mobileNumber = json['mobileNumber'];
    alternateMobileNumber = json['alternateMobileNumber'];
    addressLine1 = json['addressLine1'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    propertyStatus = json['propertyStatus'];
    discoveredInSurvey = json['discoveredInSurvey'];
    surveyed = json['surveyed'];
    propertyDetails = json['propertyDetails'] != null
        ? PropertyDetails.fromJson(json['propertyDetails'])
        : null;
    survey = json['survey'] != null ? Survey.fromJson(json['ward']) : null;
    ward = json['ward'] != null ? Ward.fromJson(json['ward']) : null;
    approver =
        json['approver'] != null ? UserInfo.fromJson(json['approver']) : null;
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
    data['propertyUid'] = propertyUid;
    data['ddnString'] = ddnString;
    data['mobileNumber'] = mobileNumber;
    data['alternateMobileNumber'] = alternateMobileNumber;
    data['addressLine1'] = addressLine1;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['propertyStatus'] = propertyStatus;
    data['discoveredInSurvey'] = discoveredInSurvey;
    data['surveyed'] = surveyed;
    if (propertyDetails != null) {
      data['propertyDetails'] = propertyDetails!.toJson();
    }
    data['survey'] = survey;
    if (ward != null) {
      data['ward'] = ward!.toJson();
    }
    data['approver'] = approver;
    if (propertyTypes != null) {
      data['propertyTypes'] = propertyTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
