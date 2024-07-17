// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBServices {
  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid") ?? "";
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addDataToDB(
      String collectionName, String docID, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionName).doc(docID).set(data).then((value) {
        print("true");
        return true;
      });
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return false;
    }
  }

  editDataToDB(
      String collectionName, String docID, Map<String, dynamic> data) async {
    try {
      await _db
          .collection(collectionName)
          .doc(docID)
          .update(data)
          .then((value) {
        return true;
      });
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return false;
    }
  }

  Future<bool> editUserDataToDB(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";
    try {
      await _db.collection("users").doc(uid).update(data);
      return true;
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
      return false;
    }
  }

  fetchDatafromDB(String collectionName, String docID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection(collectionName).doc(docID).get();
      print("!!!!!!!!!!!Userdata!!!!!!!!!!!!!");
      print(docID);
      print(documentSnapshot.data());
      return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
    }
  }

  Stream<UserModel?> fetchProfileData(String userId) {
    // Stream of user documents
    return _db.collection("users").doc(userId).snapshots().asyncMap((snapshot) {
      if (!snapshot.exists) {
        return null; // Return null for non-existent documents
      }
      // Safely access data and convert to UserModel
      final data = snapshot.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    }).handleError((error) {
      // Log error details
      print("Error fetching profile data: ${error.code} - ${error.message}");
      // Re-throw the error to propagate
      return Stream.error(error);
    });
  }

  Future<UserModel?> fetchProfileDataFuture(String userId) async {
  try {
    // Fetch the document snapshot
    var snapshot = await _db.collection("users").doc(userId).get();

    if (!snapshot.exists) {
      return null; // Return null for non-existent documents
    } else {
      // Safely access data and convert to UserModel
      final data = snapshot.data() as Map<String, dynamic>;
      return UserModel.fromMap(data);
    }
  } catch (error) {
    // Log error details
    print("Error fetching profile data: ${error.toString()}");
    // Re-throw the error to propagate
    throw error;
  }
}


  Future<void> saveFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmToken': token,
      });
    }
  }

  deleteDocFromDB(String collectionName, String docID) async {
    try {
      await _db.collection(collectionName).doc(docID).delete();
    } on FirebaseException catch (e) {
      print("Failed with error '${e.code}': ${e.message}");
    }
  }

  Future<String> createOrGetChatId(String otherUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";

    // Create a list of participants
    List<String> participants = [uid, otherUserId];

    // Sort the participants to ensure consistency in chat ID creation
    participants.sort();

    // Join the sorted participant IDs into a single string to create a unique chat ID
    String chatId = participants.join('_');

    final chatDoc = await _db.collection('chats').doc(chatId).get();
    if (chatDoc.exists) {
      // Chat already exists
      return chatId;
    } else {
      // Create a new chat
      await _db.collection('chats').doc(chatId).set({
        'participants': participants,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return chatId;
    }
  }

  // Get the list of users excluding the current user
  Stream<List<UserModel>> getChatUsers() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";

    yield* _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            return UserModel.fromMap(doc.data());
          })
          .where((user) => user.uid != uid)
          .toList();
    });
  }

  // Retrieve messages for a specific chat ID
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  // Send a message to a specific chat ID
  Future<void> sendMessage(
      {required String chatId,
      required String text,
      required UserModel reciverUserModel}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";
    DocumentReference docRef =
        await _db.collection("chats").doc(chatId).collection('messages').add({
      'chatId': chatId,
      'senderId': uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
    // Get the document ID
    String messageId = docRef.id;
    // Update the document with the message ID
    await docRef.update({'id': messageId});
    FirebaseSendNotificationServices.sendNotificationtoSelectedDeviceForSMS(
        userModel: reciverUserModel, msgBody: text, callingID: chatId);
  }

  // Mark a specific message as read
  Future<void> markMessageAsRead(String chatId, String messageId) async {
    print("@@@@@@@@@@@");

    print(messageId);
    print(chatId);
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'read': true,
    });
  }

  Future<void> setUserOnline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isOnLine': true,
      'lastSeenTime':
          FieldValue.serverTimestamp(), // Optionally update lastSeenTime
    });
  }

  Future<void> setUserOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? "";
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isOnLine': false,
      'lastSeenTime':
          FieldValue.serverTimestamp(), // Optionally update lastSeenTime
    });
  }

  Future<MessageModel?> getLastMessage(String chatId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        return MessageModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching last message: $e');
    }
    return null;
  }

  Stream<MessageModel?> getLastMessagestreem(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return MessageModel.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
