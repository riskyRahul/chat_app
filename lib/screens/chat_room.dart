// ignore_for_file: library_private_types_in_public_api

import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/calling.dart';
import 'package:chat_app/services/db_services.dart';
import 'package:chat_app/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

class ChatRoomPage extends StatefulWidget {
  final UserModel reciverUserModel;
  final String chatId;

  const ChatRoomPage(
      {super.key, required this.chatId, required this.reciverUserModel});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final DBServices _db = DBServices();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    clearData();
    _scrollToBottom();
    super.initState();
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("NOTFICATION", "");
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  Stream<UserModel> getUserInfoStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        return UserModel();
      }
    });
  }

  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) {
      return 'Last seen: unknown';
    }
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    if (difference.inDays > 0) {
      return 'Last seen: ${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return 'Last seen: ${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return 'Last seen: ${difference.inMinutes} minutes ago';
    } else {
      return 'Last seen: just now';
    }
  }

  videoCalling() {
    FirebaseSendNotificationServices.sendNotificationtoSelectedDeviceForCalling(
            userModel: widget.reciverUserModel,
            msgBody: "Calling..",
            callingID: widget.chatId,
            callingType: "1")
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CallingPage(callType: 1),
            )));
  }

  audioCalling() {
    FirebaseSendNotificationServices.sendNotificationtoSelectedDeviceForCalling(
            userModel: widget.reciverUserModel,
            msgBody: "Calling..",
            callingID: widget.chatId,
            callingType: "0")
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CallingPage(callType: 0),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: StreamBuilder<UserModel>(
          stream: getUserInfoStream(widget.reciverUserModel.uid!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else if (snapshot.hasError) {
              return const SizedBox();
            } else {
              final user = snapshot.data;
              final displayName = user?.displayName ?? 'Unknown';
              final lastSeen = user?.lastSeenTime?.toDate();
              return AppBar(
                backgroundColor: ColorManager.arrowBackColor,
                centerTitle: false,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorManager.primary,
                    )),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName,
                        style: getSemiBoldStyle(color: ColorManager.primary)),
                    Text(
                      _formatLastSeen(lastSeen),
                      style: getRegularStyle(
                          color: ColorManager.primary, fontSize: 12),
                    ),
                  ],
                ),
                actions: [
                  PopupMenuButton<int>(
                    icon: Icon(Icons.call, color: ColorManager.primary),
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          videoCalling();
                          break;
                        case 1:
                          audioCalling();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.video_call_outlined, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Video Call'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.call, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Audio Call'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _db.getMessages(widget.chatId),
              initialData: [],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        CircularProgressIndicator(color: ColorManager.primary),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender =
                        message.senderId == widget.reciverUserModel.uid;
                    print(isSender);
                    //Mark the message as read if it's not sent by the current user
                    if (isSender && !message.read!) {
                      print("###############");
                      _db.markMessageAsRead(widget.chatId, message.id!);
                    }
                    return ListTile(
                      title: Align(
                        alignment: isSender
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: isSender
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(isSender ? 0 : 20),
                                    bottomRight:
                                        Radius.circular(isSender ? 20 : 0),
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                  ),
                                  color: isSender
                                      ? Colors.grey[200]
                                      : ColorManager.primary), //
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Text(
                                  message.text ?? '',
                                  style: TextStyle(
                                    color:
                                        isSender ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                message.timestamp == null
                                    ? const SizedBox()
                                    : Text(
                                        DateFormat('hh:mm a').format(
                                            message.timestamp!.toDate()),
                                        style: getRegularStyle(
                                            color: ColorManager.hintTextColor),
                                      ),
                                const SizedBox(width: 5),
                                if (!isSender)
                                  Icon(
                                    message.read! ? Icons.done_all : Icons.done,
                                    size: 16,
                                    color: message.read!
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              _db.sendMessage(
                                  chatId: widget.chatId,
                                  text: _messageController.text,
                                  reciverUserModel: widget.reciverUserModel);
                              _messageController.clear();
                              _scrollToBottom();
                            }
                          },
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorManager.primary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
