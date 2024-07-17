// ignore_for_file: unnecessary_null_comparison, avoid_print, prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_string.dart';
import 'package:chat_app/constants/ui_text_style.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/auth/congratulations_page.dart';
import 'package:chat_app/screens/auth/email_verification_screen.dart';
import 'package:chat_app/screens/auth/login_page.dart';
import 'package:chat_app/screens/auth/register_page.dart';
import 'package:chat_app/screens/callpickup_screen.dart';
import 'package:chat_app/screens/chat_room.dart';
import 'package:chat_app/screens/splesh_page.dart';
import 'package:chat_app/services/db_services.dart';
import 'package:chat_app/widget/error_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Global variable to track ringtone playing state
bool isRingtonePlaying = true;
// FlutterRingtonePlayer flutterRingtonePlayer = FlutterRingtonePlayer();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('A bg message just showed up :  ${message.messageId}');
  debugPrint('A bg message just showed up :  ${message.data}');
  if (message.data['type'] == 'CALL') {
    // Future.delayed(const Duration(seconds: 1));
    FlutterRingtonePlayer()
        .play(fromAsset: "assets/audios/instrumenta_sort.mp3");
    isRingtonePlaying = true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<InternetStatus> listener;
  final DBServices _db = DBServices();
  String? snackBarText;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  SnackBar getSnackBar(String val, BuildContext context) {
    return SnackBar(
        content:
            Text(val, style: getSemiBoldStyle(color: ColorManager.textColor)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.fixed);
  }

  getConnectivityStatus() async {
    bool result = await InternetConnection().hasInternetAccess;
    if (!result) {
      navigatorKey.currentState?.pushReplacementNamed('/errorscr');
    } else {
      navigatorKey.currentState?.pushReplacementNamed('/');
    }
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.disconnected) {
        navigatorKey.currentState?.pushReplacementNamed('/errorscr');
      } else {
        navigatorKey.currentState?.pushReplacementNamed('/');
      }
    });
  }

  void checkStatus() {
    snackBarText = AppStrings.checkConnectionText;
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      getSnackBar(snackBarText!, context),
    );
    //return;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    getConnectivityStatus();
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification notification = message!.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        print("@@@@@@@@@@@@@@@@@@@@@");
        debugPrint("${message.data}");
        if (message.data['type'] == 'CALL') {
          FlutterRingtonePlayer()
              .play(fromAsset: "assets/audios/instrumental.mp3");
        }
        flutterLocalNotificationsPlugin
            .show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                    android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  playSound: true,
                  importance: Importance.max,
                  priority: Priority.max,
                  sound:
                      RawResourceAndroidNotificationSound('notification_sound'),
                  fullScreenIntent: true,
                  autoCancel: false,
                  // icon: '@mipmap/ic_launcher',
                )))
            .onError((error, stackTrace) async {
          if (message.data['type'] == 'CALL') {
            UserModel? userModel =
                await _db.fetchProfileDataFuture(message.data['sebderId']);
            Get.to(() => CallPickupScreen(
                  userModel: userModel!,
                  callingType: int.parse(message.data['Calltype']), //Calltype
                ));
          }
        });
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        if (message.data['type'] == 'MSG') {
          print("##########MSG##########");
          UserModel? userModel =
              await _db.fetchProfileDataFuture(message.data['senderId']);
          if (userModel != null) {
            Get.to(() => ChatRoomPage(
                reciverUserModel: userModel,
                chatId: message.data['callingID']));
          }
        } else if (message.data['type'] == 'CALL') {
          print("##########CALL##########");
          print(message.data);
          FlutterRingtonePlayer().stop();
          UserModel? userModel =
              await _db.fetchProfileDataFuture(message.data['sebderId']);
          Get.to(() => CallPickupScreen(
                userModel: userModel!,
                callingType: int.parse(message.data['Calltype']), //Calltype
              ));
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: false),
        initialRoute: '/',
        routes: {
          '/': (context) => const SpleshScreen(),
          '/login': (context) => const LoginScreen(),
          '/reg': (context) => const RegisterScreen(),
          '/homescr': (context) => const CongratulationsScreen(),
          '/evs': (context) => const EmailVerificationScreen(),
          '/errorscr': (context) => const ErrorScreen()
        });
  }
}
