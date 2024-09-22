import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAIUOfIEOIOVrpStMIyiNo7S91T0piQ2Ts',
    appId: '1:174457943368:web:aae3567d7c2629b09f2f7d',
    messagingSenderId: '174457943368',
    projectId: 'onch-44aa5',
    authDomain: 'onch-44aa5.firebaseapp.com',
    storageBucket: 'onch-44aa5.appspot.com',
    measurementId: 'G-252TVVGZPP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKvHm9qxlgHC1P-Z5FkM9799advWldwCM',
    appId: '1:174457943368:android:46be6b725561a76f9f2f7d',
    messagingSenderId: '174457943368',
    projectId: 'onch-44aa5',
    storageBucket: 'onch-44aa5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpmpjaJGStf9tw1IBiUFgtThunG2zMHKc',
    appId: '1:174457943368:ios:4d4b2e18fbaa87d09f2f7d',
    messagingSenderId: '174457943368',
    projectId: 'onch-44aa5',
    storageBucket: 'onch-44aa5.appspot.com',
    iosClientId:
        '174457943368-7fq2ra4qbtcs4dqhq845ub6o30eede4s.apps.googleusercontent.com',
    iosBundleId: 'com.erdenet.onch',
  );
}
