
import 'package:chat_app/auth/email_auth.dart';
import 'package:chat_app/auth/google_auth.dart';
import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/model/message_model.dart'; // Import your message model
import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GoogleAuth _googleAuth = GoogleAuth();
  final DBServices _db = DBServices();
  String? userId;

  @override
  void initState() {
    super.initState();
    _db.saveFcmToken();
    WidgetsBinding.instance.addObserver(this);
    _initializeUser();
  }

 
  Future<void> _initializeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uid");
    if (userId != null) {
      _db.setUserOnline();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (userId != null) {
      if (state == AppLifecycleState.resumed) {
        _db.setUserOnline();
      } else if (state == AppLifecycleState.paused) {
        _db.setUserOffline();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.museum_sharp,
          color: ColorManager.primary,
        ),
        backgroundColor: ColorManager.arrowBackColor,
        title: Text(
          "Chat Now",
          style: getBoldStyle(color: ColorManager.primary, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _googleAuth.signOutFromGoogle();
              if (result) {
                GoogleAuth.userCredential.value = '';
                EmailAuth.emailUserCredential.value = '';
                EmailAuth.loginEmailUserCredential.value = '';
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("uid");
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: Icon(
              Icons.logout_outlined,
              color: ColorManager.primary,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _db.getChatUsers(),
        initialData: [],
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorManager.primary,
              ),
            );
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              // Fetch chatId and last message
              return FutureBuilder<String>(
                future: _db.createOrGetChatId(user.uid!),
                builder: (context, chatIdSnapshot) {
                  if (!chatIdSnapshot.hasData) {
                    return ListTile(
                      title: Text(user.displayName ?? ""),
                      subtitle: Text("Loading..."),
                    );
                  }
                  final chatId = chatIdSnapshot.data!;

                  // Fetch last message
                  return StreamBuilder<MessageModel?>(
                    stream: _db.getLastMessagestreem(chatId),
                    builder: (context, messageSnapshot) {
                      if (!messageSnapshot.hasData) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomPage(
                                  reciverUserModel: user,
                                  chatId: chatId,
                                ),
                              ),
                            );
                          },
                          leading: const Icon(Icons.person_outlined),
                          title: Text(user.displayName ?? ""),
                          subtitle: Text("No messages",
                              style: getMediumStyle(
                                  color: ColorManager.textColor, fontSize: 12)),
                          trailing: user.isOnLine == null
                              ? const SizedBox()
                              : Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: user.isOnLine!
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                        );
                      }
                      final lastMessage = messageSnapshot.data!;
                      return ListTile(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatRoomPage(
                                reciverUserModel: user,
                                chatId: chatId,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.person,
                            size: 40, color: ColorManager.primary),
                        title: Text(
                          user.displayName ?? "",
                          style: getSemiBoldStyle(
                              color: ColorManager.primary, fontSize: 16),
                        ),
                        subtitle: Text(
                          lastMessage.text ?? "",
                          style: getMediumStyle(
                              color: ColorManager.textColor, fontSize: 12),
                        ),
                        trailing: user.isOnLine == null
                            ? const SizedBox()
                            : Icon(
                                Icons.circle,
                                size: 12,
                                color:
                                    user.isOnLine! ? Colors.green : Colors.grey,
                              ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
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
}
