import 'package:chat_app/constants/ui_images.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/calling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallPickupScreen extends StatefulWidget {
  final UserModel userModel;
  final int callingType;
  const CallPickupScreen(
      {super.key, required this.callingType, required this.userModel});

  @override
  State<CallPickupScreen> createState() => _CallPickupScreenState();
}

class _CallPickupScreenState extends State<CallPickupScreen> {
  @override
  void initState() {
    clearData();
    super.initState();
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("NOTFICATION", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(height: 50),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(ImageAssets.profileImageTwo),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.userModel.displayName ?? "",
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Calling...',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.call_end, color: Colors.red),
                      onPressed: () async {
                        await FlutterRingtonePlayer().stop();
                        Get.back();
                      },
                      iconSize: 40,
                    ),
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () async {
                        await FlutterRingtonePlayer().stop();
                        Get.off(CallingPage(
                          callType: widget.callingType,
                        ));
                      },
                      iconSize: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
