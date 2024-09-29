import 'dart:developer';
import 'dart:async';

import 'package:erdenet_divers/models/detection.dart';
import 'package:flutter/material.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import '../config/firebase_service.dart';

class BoxWidget extends StatelessWidget {
  final ResultObjectDetection result;
  final Color? boxesColor;
  final bool showPercentage;
  final String email;

  const BoxWidget(
      {Key? key,
      required this.result,
      this.boxesColor,
      this.showPercentage = true,
      required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? usedColor;
    Size size = MediaQuery.of(context).size;
    double factorX = size.width;
    double factorY = size.height;
    final distractionSound = AudioPlayer();
    final drowsySound = AudioPlayer();

    if (boxesColor == null) {
      switch (result.className) {
        case 'Сэрүүн':
          usedColor = Colors.green;
          break;
        case 'Зүүрмэглэсэн':
          usedColor = Colors.red;
          break;
        case 'Сатаарсан':
          usedColor = Colors.yellow;
          break;
        default:
          usedColor = Colors.primaries[
              ((result.className ?? result.classIndex.toString()).length +
                      (result.className ?? result.classIndex.toString())
                          .codeUnitAt(0) +
                      result.classIndex) %
                  Colors.primaries.length];
      }
    } else {
      usedColor = boxesColor;
    }
    log(result.classIndex.toString());
    log(result.className!);

    if (result.className == 'Зүүрмэглэсэн') {
      _playDrowsySound(drowsySound);
    } else if (result.className == 'Сатаарсан') {
      _playDistractionSound(distractionSound);
    }

    void sendToFirebase() {
      final detection = Detection(
          userEmail: email,
          classIndex: result.classIndex,
          className: result.className);
      FirestoreService().addDetection(detection);
    }

    if (result.className != null) {
      sendToFirebase();
    }

    return Positioned(
      left: result.rect.left * factorX,
      top: result.rect.top * factorY,
      width: result.rect.width * factorX,
      height: result.rect.height * factorY,
      child: Container(
        width: result.rect.width * factorX,
        height: result.rect.height * factorY,
        decoration: BoxDecoration(
            border: Border.all(color: usedColor!, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: usedColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(result.className ?? result.classIndex.toString()),
                  Text(" ${result.score.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _playDistractionSound(AudioPlayer player) async {
    for (int i = 0; i < 4; i++) {
      await player.play(AssetSource('distraction.mp3'));
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  void _playDrowsySound(AudioPlayer player) async {
    for (int i = 0; i < 4; i++) {
      await player.play(AssetSource('drowsy.mp3'));
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}
