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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9k0hwALPGJAxfIksIZV-nQVZoFTtbN0k',
    appId: '1:446562789301:android:08a85295960f80bf2e5bfc',
    messagingSenderId: '446562789301',
    projectId: 'srifitness-96c1b',
    databaseURL: 'https://srifitness-96c1b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'srifitness-96c1b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAML81P5RrfwI5X7NgsrQfQpsKX6wcaOIc',
    appId: '1:446562789301:ios:953b3c9e54af93642e5bfc',
    messagingSenderId: '446562789301',
    projectId: 'srifitness-96c1b',
    databaseURL: 'https://srifitness-96c1b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'srifitness-96c1b.firebasestorage.app',
    iosBundleId: 'com.example.srifitnessApp',
  );

}