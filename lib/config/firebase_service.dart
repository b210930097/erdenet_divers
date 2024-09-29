import 'dart:developer';
import 'package:erdenet_divers/models/detection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('Bvrtgvvlj chadsangv');
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('Newterch chadsangv');
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Garch chadsangv');
    }
  }

  Future<void> addDetection(Detection detection) async {
    try {
      String timestamp = DateFormat('yyyy.MM.dd HH:mm').format(DateTime.now());

      await _firestore.collection('detections').add({
        'classIndex': detection.classIndex,
        'className': detection.className,
        'userEmail': detection.userEmail,
        'timestamp': timestamp,
      });
    } catch (e) {
      print("Error adding detection: $e");
    }
  }
}
