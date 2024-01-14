// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB54qVXLN_6wSxbCJzjiOz-q8WCAPXInfU',
    appId: '1:613066548408:web:bb04c5ec23a53f16ca404d',
    messagingSenderId: '613066548408',
    projectId: 'igeoplus',
    authDomain: 'igeoplus.firebaseapp.com',
    storageBucket: 'igeoplus.appspot.com',
    measurementId: 'G-2K92NCNC27',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2nXwIGMb7zvNkru56v8osTpVglYi_5y4',
    appId: '1:613066548408:android:7d371e7a2205d0cdca404d',
    messagingSenderId: '613066548408',
    projectId: 'igeoplus',
    storageBucket: 'igeoplus.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtnyLGBHpRfm2E7ExqEjvlfPQ7SPEveGA',
    appId: '1:613066548408:ios:720e7c9c6d534954ca404d',
    messagingSenderId: '613066548408',
    projectId: 'igeoplus',
    storageBucket: 'igeoplus.appspot.com',
    androidClientId: '613066548408-pfkt1vea0g6ledb2mr3c7oks63rt2icd.apps.googleusercontent.com',
    iosClientId: '613066548408-0dpqvorb2b02hnhgiomqm99aoe6hk82b.apps.googleusercontent.com',
    iosBundleId: 'br.uff.igeoplus',
  );
}
