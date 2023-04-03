class DeviceVitals {
  double? latitude;
  double? longitude;
  double? altitude;
  double? signalStrength;
  int? satelliteCount;
  String? androidVersion;
  String? mobileModel;
  String? batteryStatus;
  String? image1;
  String? image1FileType;
  String? image2;
  String? image2FileType;

  DeviceVitals(
      this.latitude,
      this.longitude,
      this.altitude,
      this.signalStrength,
      this.satelliteCount,
      this.androidVersion,
      this.mobileModel,
      this.batteryStatus,
      this.image1,
      this.image1FileType,
      this.image2,
      this.image2FileType);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['altitude'] = altitude;
    data['signalStrength'] = signalStrength;
    data['satelliteCount'] = satelliteCount;
    data['androidVersion'] = androidVersion;
    data['mobileModel'] = mobileModel;
    data['batteryStatus'] = batteryStatus;
    data['image1'] = image1;
    data['image1FileType'] = image1FileType;
    data['image2'] = image2;
    data['image2FileType'] = image2FileType;
    return data;
  }
}
