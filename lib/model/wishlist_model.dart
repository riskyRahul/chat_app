import 'package:cloud_firestore/cloud_firestore.dart';

class WishListModel {
  List<String>? items;
  Timestamp? createdAt;
  Timestamp? updateAt;

  String? userId;

  WishListModel({this.items, this.createdAt, this.updateAt, this.userId});

  // Convert a WishListModel into a Map
  Map<String, dynamic> toMap() {
    return {
      "items": items,
      "createdAt": createdAt,
      "updateAt": updateAt,
      "userId": userId
    };
  }

  // Create a WishListModel from a Map
  WishListModel.fromMap(Map<String, dynamic> map)
      : items = List<String>.from(map["items"]),
        createdAt = map["createdAt"],
        updateAt = map["updateAt"],
        userId = map["userId"];
}
