class User {
  int? id;
  String? login;
  String? firstName;
  String? lastName;
  String? email;
  String? imageUrl;
  bool? activated;
  String? langKey;
  String? createdBy;
  String? createdDate;
  String? lastModifiedBy;
  String? lastModifiedDate;
  List<String>? authorities;

  User({this.id,
    this.login,
    this.firstName,
    this.lastName,
    this.email,
    this.imageUrl,
    this.activated,
    this.langKey,
    this.createdBy,
    this.createdDate,
    this.lastModifiedBy,
    this.lastModifiedDate,
    this.authorities});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    activated = json['activated'];
    langKey = json['langKey'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedDate = json['lastModifiedDate'];
    if (json['authorities'] == null) {
      authorities = null;
    } else {
      authorities = json['authorities'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['imageUrl'] = imageUrl;
    data['activated'] = activated;
    data['langKey'] = langKey;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedDate'] = lastModifiedDate;
    data['authorities'] = authorities;
    return data;
  }
}
