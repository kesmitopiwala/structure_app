class LoginSuccessResponse {
  int? status;
  String? message;
  Data? data;
  String? token;

  LoginSuccessResponse({this.status, this.message, this.data, this.token});

  LoginSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? school;
  String? gender;
  String? dob;
  String? about;
  String? socialMedia;
  List<String>? friends;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? userProfileImage;

  Data(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.school,
      this.gender,
      this.dob,
      this.about,
      this.socialMedia,
      this.friends,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.userProfileImage});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    school = json['school'];
    gender = json['gender'];
    dob = json['dob'];
    about = json['about'];
    socialMedia = json['social_media'];
    friends = json['friends'].cast<String>();
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    userProfileImage = json['user_profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['password'] = password;
    data['school'] = school;
    data['gender'] = gender;
    data['dob'] = dob;
    data['about'] = about;
    data['social_media'] = socialMedia;
    data['friends'] = friends;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['user_profile_image'] = this.userProfileImage;

    return data;
  }
}
