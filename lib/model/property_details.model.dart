class PropertyDetails {
  int? id;
  String? colonyName;
  String? totalFloors;
  String? floorNumber;
  String? ownerName;
  String? fatherName;
  String? addressLine2;
  double? area;
  String? areaCode;
  String? street;
  String? houseNumber;
  String? unit;
  String? sparrowPropertyId;
  String? nsgPropertyId;
  String? ddnImage;

  PropertyDetails(
      {this.id,
        this.colonyName,
        this.totalFloors,
        this.floorNumber,
        this.ownerName,
        this.fatherName,
        this.addressLine2,
        this.area,
        this.areaCode,
        this.street,
        this.houseNumber,
        this.unit,
        this.sparrowPropertyId,
        this.nsgPropertyId,
        this.ddnImage});

  PropertyDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    colonyName = json['colonyName'];
    totalFloors = json['totalFloors'];
    floorNumber = json['floorNumber'];
    ownerName = json['ownerName'];
    fatherName = json['fatherName'];
    addressLine2 = json['addressLine2'];
    area = json['area'];
    areaCode = json['areaCode'];
    street = json['street'];
    houseNumber = json['houseNumber'];
    unit = json['unit'];
    sparrowPropertyId = json['sparrowPropertyId'];
    nsgPropertyId = json['nsgPropertyId'];
    ddnImage = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['colonyName'] = colonyName;
    data['totalFloors'] = totalFloors;
    data['floorNumber'] = floorNumber;
    data['ownerName'] = ownerName;
    data['fatherName'] = fatherName;
    data['addressLine2'] = addressLine2;
    data['area'] = area;
    data['areaCode'] = areaCode;
    data['street'] = street;
    data['houseNumber'] = houseNumber;
    data['unit'] = unit;
    data['sparrowPropertyId'] = sparrowPropertyId;
    data['nsgPropertyId'] = nsgPropertyId;
    data['ddnImage'] = ddnImage;
    return data;
  }
}
