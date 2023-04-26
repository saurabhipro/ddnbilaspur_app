class Zone {
  int? id;
  String? state;
  String? district;
  String? zoneNumber;

  Zone({this.id, this.state, this.district, this.zoneNumber});

  Zone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    district = json['district'];
    zoneNumber = json['zoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state'] = state;
    data['district'] = district;
    data['zoneNumber'] = zoneNumber;
    return data;
  }
}
