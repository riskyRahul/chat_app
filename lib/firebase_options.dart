// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCGrnAq-WvVUPqYNUp60kHoABY9qunnVZY',
    appId: '1:928638258326:web:cec885ae89d651fca646b7',
    messagingSenderId: '928638258326',
    projectId: 'chatapp-83883',
    authDomain: 'chatapp-83883.firebaseapp.com',
    storageBucket: 'chatapp-83883.appspot.com',
    measurementId: 'G-9WQCM7N779',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5-2_oFwCkRCAqa5tohzYB3qsfzBPSEss',
    appId: '1:928638258326:android:54e5d0bcf17364f8a646b7',
    messagingSenderId: '928638258326',
    projectId: 'chatapp-83883',
    storageBucket: 'chatapp-83883.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPIpGF4QLvNHQjN7XiwGv-vI1NRjeRVQk',
    appId: '1:928638258326:ios:411b23f8df707460a646b7',
    messagingSenderId: '928638258326',
    projectId: 'chatapp-83883',
    storageBucket: 'chatapp-83883.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAPIpGF4QLvNHQjN7XiwGv-vI1NRjeRVQk',
    appId: '1:928638258326:ios:411b23f8df707460a646b7',
    messagingSenderId: '928638258326',
    projectId: 'chatapp-83883',
    storageBucket: 'chatapp-83883.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGrnAq-WvVUPqYNUp60kHoABY9qunnVZY',
    appId: '1:928638258326:web:c6c436cda4fcb03ea646b7',
    messagingSenderId: '928638258326',
    projectId: 'chatapp-83883',
    authDomain: 'chatapp-83883.firebaseapp.com',
    storageBucket: 'chatapp-83883.appspot.com',
    measurementId: 'G-6K328D43EZ',
  );
}
