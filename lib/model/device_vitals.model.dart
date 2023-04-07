import 'dart:ffi';

class CapturedImages {
  bool? image1Found;
  String? image1;
  String? image1FileType;
  bool? image2Found;
  String? image2;
  String? image2FileType;

  CapturedImages(
      this.image1Found,
      this.image1,
      this.image1FileType,
      this.image2Found,
      this.image2,
      this.image2FileType);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image1Found'] = image1Found;
    data['image1'] = image1;
    data['image1FileType'] = image1FileType;
    data['image2Found'] = image2Found;
    data['image2'] = image2;
    data['image2FileType'] = image2FileType;
    return data;
  }
}
