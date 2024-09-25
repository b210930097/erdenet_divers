import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'dart:async';
import 'dart:typed_data';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  String _drowsinessResult = "Detecting...";
  ModelObjectDetection? _objectModel;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModels();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      _startImageStream();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _loadModels() async {
    try {
      log('Starting to load the model');
      _objectModel = await PytorchLite.loadObjectDetectionModel(
        "assets/models/best.torchscript",
        3,
        640,
        640,
        labelPath: "assets/labels/text.txt",
        objectDetectionModelType: ObjectDetectionModelType.yolov8,
      );
      log('Model loaded successfully');
    } catch (e) {
      log('Error loading model: $e');
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) async {
      if (_objectModel != null) {
        await _analyzeCameraImage(image);
      }
    });
  }

  Future<void> _analyzeCameraImage(CameraImage image) async {
    List<Uint8List> imageBytesList = image.planes.map((plane) {
      return Uint8List.fromList(plane.bytes);
    }).toList();
    log('map done');
    Uint8List imageBytes =
        Uint8List.fromList(imageBytesList.expand((x) => x).toList());
    log('list done');

    List<ResultObjectDetection> objDetect =
        await _objectModel!.getImagePrediction(
      imageBytes,
      minimumScore: 0.1,
      iOUThreshold: 0.3,
    );

    setState(() {
      _drowsinessResult = objDetect.isNotEmpty
          ? "Face Detected"
          : "No Face Detected"; // Update the result based on detection
    });
    log(_drowsinessResult);
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream(); // Stop the image stream
    _cameraController?.dispose(); // Dispose of the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Жолоодлого эхлүүлэх'), // App title
      ),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child: CameraPreview(
                      _cameraController!), // Show the camera preview
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _drowsinessResult,
                    style: const TextStyle(
                        fontSize: 24), // Display detection result
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator()), // Show loading indicator
    );
  }
}
