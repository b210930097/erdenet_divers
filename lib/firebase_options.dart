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
      apiKey: "AIzaSyDOACmuAO5NKLWFv0VAd97MjLogwzLsSvQ",
      authDomain: "erdenet-divers.firebaseapp.com",
      databaseURL: "https://erdenet-divers-default-rtdb.firebaseio.com",
      projectId: "erdenet-divers",
      storageBucket: "erdenet-divers.appspot.com",
      messagingSenderId: "941154206174",
      appId: "1:941154206174:web:7108dd38696af54783dd4f");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBATNpZ4yfO7xPTmKdXOSfPYOto8JLsVo',
    appId: '1:941154206174:android:eabe15270cda9df883dd4f',
    messagingSenderId: '941154206174',
    projectId: 'erdenet-divers',
    storageBucket: 'erdenet-divers.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARz9QUIOV-S59p67UWKjmihkNPHIIKpfY',
    appId: '1:941154206174:ios:9ee54569699a770083dd4f',
    messagingSenderId: '941154206174',
    projectId: 'erdenet-divers',
    storageBucket: 'erdenet-divers.appspot.com',
    iosClientId:
        '941154206174-remln97bi2gsflialnbv3oq6h1vk688n.apps.googleusercontent.com',
    iosBundleId: 'com.erdenet.divers',
  );
}
