import 'package:cloud_firestore/cloud_firestore.dart';

class Detection {
  String? userEmail;
  String? className;
  int? classIndex;

  Detection({
    this.userEmail,
    this.className,
    this.classIndex,
  });

  factory Detection.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return Detection(
      userEmail: d['userEmail'],
      className: d['className'],
      classIndex: d['classIndex'],
    );
  }
}
