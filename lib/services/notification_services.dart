// ignore_for_file: unused_import

import 'dart:convert';
// import 'package:googleapis/script/v1.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseSendNotificationServices {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
     // get from the google console
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    //get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();

    return credentials.accessToken.data;
  }

  static Future<void> sendNotificationtoSelectedDeviceForSMS(
      {required UserModel userModel,
      required String msgBody,
      required String callingID}) async {
    final String serverAuthKey = await getAccessToken();

    String endpointFirebaseCloudeMessaging =
        'https://fcm.googleapis.com/v1/projects/ProjectID/messages:send';

    final Map<String, dynamic> message = {
      'message': {
        'token': userModel.fcmToken,
        'notification': {'title': "${userModel.displayName}", 'body': msgBody},
        'data': {
          'type': "MSG",
          'callingID': callingID,
          'sebderId': userModel.uid
        }
      }
    };

    http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudeMessaging),
        body: jsonEncode(message),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAuthKey'
        });

    print(response.body);

    if (response.statusCode == 200) {
      print("Notification sent succesfully");
    } else {
      print("Notification SENT ERROR");
    }
  }

  static Future<void> sendNotificationtoSelectedDeviceForCalling(
      {required UserModel userModel,
      required String msgBody,
      required String callingID,
      required String callingType}) async {
    final String serverAuthKey = await getAccessToken();

    String endpointFirebaseCloudeMessaging =
        'https://fcm.googleapis.com/v1/projects/ProjectID/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        'token': userModel.fcmToken,
        'notification': {'title': "${userModel.displayName}", 'body': msgBody},
        'data': {
          'type': "CALL",
          'Calltype': callingType,
          'callingID': callingID,
          'sebderId': userModel.uid
        }
      }
    };
    http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudeMessaging),
        body: jsonEncode(message),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAuthKey'
        });
    print(response.body);
    if (response.statusCode == 200) {
      
      print("Notification sent succesfully");
    } else {
      print("Notification SENT ERROR");
    }
  }
}

