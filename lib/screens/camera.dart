import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List<CameraDescription> cameras = [];
  late CameraController cameraController;
  late Future<void> _initializeControllerFuture;
  bool _cameraInitialized = false;

  @override
  void initState() {
    _getAvailableCameras();
    _cameraInitialized = true;
    super.initState();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(cameraController);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await cameraController.takePicture();
              Navigator.pop(context,image);
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        )
      ],
    );
  }

  _getAvailableCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    cameraController = CameraController(cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = cameraController!.initialize();
    setState(() {
      _cameraInitialized = true;
    });
  }
}
