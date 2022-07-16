class AlbumResponse {
  int? status;
  String? message;
  List<AlbumData>? albumData;

  AlbumResponse({this.status, this.message, this.albumData});

  AlbumResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      albumData = <AlbumData>[];
      json['data'].forEach((v) {
        albumData!.add(new AlbumData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.albumData != null) {
      data['data'] = this.albumData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumData {
  String? sId;
  String? photoTitle;
  String? photoDescription;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AlbumData(
      {this.sId,
      this.photoTitle,
      this.photoDescription,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.iV});

  AlbumData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    photoTitle = json['photo_title'];
    photoDescription = json['photo_description'];
    imageUrl = json['image_url'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['photo_title'] = this.photoTitle;
    data['photo_description'] = this.photoDescription;
    data['image_url'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
