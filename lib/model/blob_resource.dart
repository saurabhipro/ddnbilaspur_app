import 'survey.model.dart';

class BlobResource {
  int? id;
  String? fileName;
  List<String>? fileContent;
  String? fileContentContentType;
  String? resourceFor;
  bool? fileMovedToS3;
  String? fileS3URL;
  Survey? survey;

  BlobResource(
      {this.id,
      this.fileName,
      this.fileContent,
      this.fileContentContentType,
      this.resourceFor,
      this.fileMovedToS3,
      this.fileS3URL,
      this.survey});

  BlobResource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    fileContent = json['fileContent'].cast<String>();
    fileContentContentType = json['fileContentContentType'];
    resourceFor = json['resourceFor'];
    fileMovedToS3 = json['fileMovedToS3'];
    fileS3URL = json['fileS3URL'];
    survey =
        json['survey'] != null ? new Survey.fromJson(json['survey']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileName'] = this.fileName;
    data['fileContent'] = this.fileContent;
    data['fileContentContentType'] = this.fileContentContentType;
    data['resourceFor'] = this.resourceFor;
    data['fileMovedToS3'] = this.fileMovedToS3;
    data['fileS3URL'] = this.fileS3URL;
    if (this.survey != null) {
      data['survey'] = this.survey!.toJson();
    }
    return data;
  }
}
