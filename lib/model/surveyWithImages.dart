import 'package:ddnbilaspur_mob/model/device_vitals.model.dart';
import 'package:ddnbilaspur_mob/model/property.model.dart';

class SurveyWithProperty {
  Property? property;
  CapturedImages? capturedImages;

  SurveyWithProperty(this.property, this.capturedImages);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (property != null) {
      data['property'] = property!.toJson();
    }
    if (capturedImages != null) {
      data['capturedImages'] = capturedImages!.toJson();
    }
    return data;
  }
}
