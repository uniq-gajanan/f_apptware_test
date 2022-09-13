import 'dart:convert';

List<PostResponseModel> postResponseModelFromJson(String str) =>
    List<PostResponseModel>.from(
        json.decode(str).map((x) => PostResponseModel.fromJson(x)));

String postResponseModelToJson(List<PostResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostResponseModel {
  PostResponseModel({
    this.id,
    this.title,
    this.body,
  });

  int? id;
  String? title;
  String? body;

  factory PostResponseModel.fromJson(Map<String, dynamic> json) =>
      PostResponseModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
      };
}
