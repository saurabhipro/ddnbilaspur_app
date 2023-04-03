import 'zone.model.dart';

class Ward {
  int? id;
  String? wardName;
  String? wardNumber;
  Zone? zone;

  Ward({this.id, this.wardName, this.wardNumber, this.zone});

  Ward.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wardName = json['wardName'];
    wardNumber = json['wardNumber'];
    zone = json['zone'] != null ? Zone.fromJson(json['zone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wardName'] = wardName;
    data['wardNumber'] = wardNumber;
    if (zone != null) {
      data['zone'] = zone!.toJson();
    }
    return data;
  }
}
