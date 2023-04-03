import 'blob_resource.dart';
import 'user.model.dart';
import 'ward.model.dart';

class UserInfo {
  int? id;
  String? mobile;
  String? fatherSpouseName;
  String? aadharNumber;
  String? address;
  String? employeeCode;
  User? user;
  BlobResource? photo;
  List<Ward>? wards;

  UserInfo({this.id,
    this.mobile,
    this.fatherSpouseName,
    this.aadharNumber,
    this.address,
    this.employeeCode,
    this.user,
    this.photo,
    this.wards});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    fatherSpouseName = json['fatherSpouseName'];
    aadharNumber = json['aadharNumber'];
    address = json['address'];
    employeeCode = json['employeeCode'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    photo = json['photo'] != null ? BlobResource.fromJson(json['photo']) : null;
    if (json['wards'] != null) {
      wards = <Ward>[];
      json['wards'].forEach((v) {
        wards!.add(Ward.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['mobile'] = mobile;
    data['fatherSpouseName'] = fatherSpouseName;
    data['aadharNumber'] = aadharNumber;
    data['address'] = address;
    data['employeeCode'] = employeeCode;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    if (wards != null) {
      data['wards'] = wards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
