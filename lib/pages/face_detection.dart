import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'dart:isolate';
import 'dart:async';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  Interpreter? _tfliteInterpreter;
  Model? _pyTorchModel;

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
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => throw Exception('No front camera available'));

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      _cameraController?.startImageStream((image) {
        _runModelsOnFrame(image);
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _loadModels() async {
    try {
      _tfliteInterpreter = await Interpreter.fromAsset('best_float32.tflite');
      print('TFLite model loaded.');
    } catch (e) {
      print('Error loading TFLite model: $e');
    }

    try {
      _pyTorchModel = await PyTorchMobile.loadModel('best.pt');
      print('PyTorch model loaded.');
    } catch (e) {
      print('Error loading PyTorch model: $e');
    }
  }

  Future<void> _runModelsOnFrame(CameraImage image) async {
    try {
      if (_tfliteInterpreter != null) {
        var input = _preprocessCameraImage(image);
        var output = List.filled(1, 0).reshape([1]);
        _tfliteInterpreter?.run(input, output);
        print('TFLite Model Output: $output');
      }
    } catch (e) {
      print('Error running TFLite model: $e');
    }

    try {
      if (_pyTorchModel != null) {
        var input = _preprocessForPyTorch(image);
        var imageWidth = image.width; // Get image width
        var imageHeight = image.height; // Get image height

        // Replace the double threshold with a String configuration
        String config =
            'your_configuration_string'; // Update this with the actual string needed
        var output = await _pyTorchModel?.getImagePrediction(
            input, // Preprocessed input tensor
            imageWidth, // Image width
            imageHeight, // Image height
            config // Replace this with the actual required parameter as a String
            );

        print('PyTorch Model Output: $output');
      }
    } catch (e) {
      print('Error running PyTorch model: $e');
    }
  }

  List<List<double>> _preprocessCameraImage(CameraImage image) {
    // Convert CameraImage to model input format for TFLite
    // This could involve resizing and normalizing the pixel values
    return List.generate(
        1, (_) => List.filled(1, 0.0)); // Placeholder for preprocessing
  }

  dynamic _preprocessForPyTorch(CameraImage image) {
    // Convert CameraImage to Tensor format for PyTorch
    return image; // Placeholder: You need to convert the image to a tensor format as required by PyTorch
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _tfliteInterpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
      ),
      body: _isCameraInitialized
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_cameraController!),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
