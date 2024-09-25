import 'package:erdenet_divers/pages/face_detection.dart';
import 'package:erdenet_divers/pages/sign_in.dart';
import 'package:erdenet_divers/yolo/run_model_by_camera_demo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:erdenet_divers/firebase_options.dart';
import 'package:erdenet_divers/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => RunModelByCameraDemo(),
        // '/login': (context) => SignIn(),
        // '/home': (context) => Home(),
      },
      initialRoute: '/',
    );
  }
}
