class AlbumImagesModel {
  int? status;
  String? message;
  List<ImagesData>? imagesData;

  AlbumImagesModel({this.status, this.message, this.imagesData});

  AlbumImagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      imagesData = <ImagesData>[];
      json['data'].forEach((v) {
        imagesData!.add(new ImagesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.imagesData != null) {
      data['data'] = this.imagesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagesData {
  String? sId;
  String? photoTitle;
  String? photoDescription;
  String? privacy;
  String? imagePath;
  String? albumId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ImagesData(
      {this.sId,
      this.photoTitle,
      this.photoDescription,
      this.privacy,
      this.imagePath,
      this.albumId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ImagesData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    photoTitle = json['photo_title'];
    photoDescription = json['photo_description'];
    privacy = json['privacy'];
    imagePath = json['image_path'];
    albumId = json['album_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['photo_title'] = this.photoTitle;
    data['photo_description'] = this.photoDescription;
    data['privacy'] = this.privacy;
    data['image_path'] = this.imagePath;
    data['album_id'] = this.albumId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
