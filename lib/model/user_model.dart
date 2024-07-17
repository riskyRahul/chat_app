import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? photoURL;
  String? phoneNumber;
  String? contryCode;
  bool? isEmailVerified;
  Timestamp? lastSeenTime;
  bool? isOnLine;
  String? fcmToken;

  UserModel(
      {this.uid,
      this.email,
      this.displayName,
      this.photoURL,
      this.phoneNumber,
      this.contryCode,
      this.lastSeenTime,
      this.isOnLine,
      this.fcmToken,
      this.isEmailVerified});
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "displayName": displayName,
      "photoURL": photoURL,
      "phoneNumber": phoneNumber,
      "contryCode": contryCode,
      "isEmailVerified": isEmailVerified,
      "lastSeenTime": lastSeenTime,
      "isOnLine": isOnLine,
      "fcmToken": fcmToken
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        email = map["email"],
        displayName = map["displayName"],
        phoneNumber = map["phoneNumber"],
        contryCode = map["contryCode"],
        photoURL = map["photoURL"],
        lastSeenTime = map['lastSeenTime'],
        isOnLine = map['isOnLine'],
        fcmToken = map['fcmToken'],
        isEmailVerified = map["isEmailVerified"];
}
