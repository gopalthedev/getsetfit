// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:camera/camera.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
//
// class PoseDetection extends StatefulWidget {
//   const PoseDetection({Key? key}) : super(key: key);
//
//   @override
//   _PoseDetectionState createState() => _PoseDetectionState();
// }
//
// class _PoseDetectionState extends State<PoseDetection> {
//   List _recognitions = [];
//   double _imageHeight = 0.0;
//   late CameraImage img;
//   late CameraController controller;
//   bool isBusy = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//     initCamera();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     controller.stopImageStream();
//     Tflite.close();
//   }
//
//   Future<void> loadModel() async {
//     try {
//       String? res;
//       res = await Tflite.loadModel(
//         model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
//         useGpuDelegate: true,
//       );
//       if (kDebugMode) {
//         print(res);
//       }
//     } on PlatformException {
//       if (kDebugMode) {
//         print('Failed to load model.');
//       }
//     }
//   }
//
//   void initCamera() async {
//     final cameras = await availableCameras();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     await controller.initialize();
//     controller.startImageStream((image) {
//       if (!isBusy) {
//         isBusy = true;
//         img = image;
//         runModelOnFrame();
//       }
//     });
//   }
//
//   void runModelOnFrame() async {
//     _imageHeight = img.height + 100.0;
//     _recognitions = (await Tflite.runPoseNetOnFrame(
//       bytesList: img.planes.map((plane) => plane.bytes).toList(),
//       imageHeight: img.height,
//       imageWidth: img.width,
//       numResults: 2,
//     ))!;
//     isBusy = false;
//     setState(() {}); // Update UI after running model
//   }
//
//   List<Widget> renderKeyPoints(Size screen) {
//     double factorX = screen.width;
//     double factorY = _imageHeight;
//
//     var lists = <Widget>[];
//     for (var re in _recognitions) {
//       var list = re["keypoints"].values.map<Widget>((k) {
//         return Positioned(
//           left: k["x"]! * factorX - 6,
//           top: k["y"]! * factorY - 6,
//           width: 100,
//           height: 100,
//           child: Text(
//             "● ${k["part"]}",
//             style: const TextStyle(
//               color: Colors.red,
//               fontSize: 12.0,
//             ),
//           ),
//         );
//       }).toList();
//
//       lists.addAll(list);
//     }
//
//     return lists;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     List<Widget> stackChildren = [];
//
//     stackChildren.add(Positioned(
//       top: 0.0,
//       left: 0.0,
//       width: size.width,
//       child: Container(
//         child: (!controller.value.isInitialized)
//             ? Container()
//             : AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: CameraPreview(controller),
//         ),
//       ),
//     ));
//
//     stackChildren.addAll(renderKeyPoints(size));
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 500,
//             width: 340,
//             color: Colors.black,
//             child: Stack(
//               children: stackChildren,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';


class PoseDetection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pose Detection',
      home: PoseDetectionScreen(),
    );
  }
}

class PoseDetectionScreen extends StatefulWidget {
  @override
  _PoseDetectionScreenState createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends State<PoseDetectionScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  late bool _isDetecting;
  late List<dynamic> _recognitions;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadTFLiteModel();
    _isDetecting = false;
    _recognitions = [];
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
    _cameraController.startImageStream(_processCameraImage);
  }

  Future<void> _loadTFLiteModel() async {
    await Tflite.loadModel(
      model: 'assets/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 2,
    );
  }

  void _processCameraImage(CameraImage cameraImage) async {
    if (!_isDetecting) {
      _isDetecting = true;
      List<dynamic>? recognitions = await Tflite.runPoseNetOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        numResults: 2,
      );
      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _recognitions = recognitions;
        });
      }
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pose Detection'),
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          _buildKeypoints(),
        ],
      ),
    );
  }

  Widget _buildKeypoints() {
    List<Widget> keypoints = [];

    for (var recognition in _recognitions) {
      Map<String, dynamic> keypointsMap = recognition['keypoints'];
      keypointsMap.values.forEach((keypoint) {
        keypoints.add(
          Positioned(
            left: keypoint['x'] - 3,
            top: keypoint['y'] - 3,
            width: 6,
            height: 6,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ),
          ),
        );
      });
    }

    return Stack(
      children: keypoints,
    );
  }
}

