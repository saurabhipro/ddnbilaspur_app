class PropertyType {
  int? id;
  String? excelString;
  String? properName;

  PropertyType({this.id, this.excelString, this.properName});

  PropertyType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    excelString = json['excelString'];
    properName = json['properName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['excelString'] = excelString;
    data['properName'] = properName;
    return data;
  }
}
