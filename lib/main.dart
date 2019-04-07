import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

import 'package:flutter/rendering.dart';
import 'package:kaleidoscope/utils/clip_equilateral_triangle.dart';
import 'package:kaleidoscope/utils/math.dart';
import 'package:kaleidoscope/utils/transforms.dart';

final startSize = 100.0;
final minSize = 30.0;
final maxSize = 300.0;

double S, A, B, C;

// final rearCam = 0;
// final frontCam = 1;

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();

  runApp(
    MaterialApp(
      home: Hexagons(),
    ),
  );
}

class Hexagons extends StatefulWidget {
  @override
  HexagonsState createState() => HexagonsState();
}

class HexagonsState extends State<Hexagons> {
  CameraController controller;

  var sliderValue;
  bool hasCameras = false;
  bool showFront = false;

  @override
  void initState() {
    super.initState();

    sliderValue = S = startSize;
    _updateConstraints();

    if (cameras.length > 1) {
      hasCameras = true;
    }

    _setCamera(0);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    var view = Container(
      decoration: BoxDecoration(color: Colors.black),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
      height: S,
      width: S,
    );

    var clipped = ClipPath(
      child: view,
      clipper: TriangleClip(A),
    );

    var hexagon = createHexagon(clipped, S / 2);
    var hexagonGroup = groupHexagon(hexagon, S, B, S / 2);
    var finished = fillScreen(hexagonGroup);

    return Scaffold(
      body: Center(child: finished),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            height: 75,
            child: Slider(
              activeColor: Colors.white,
              min: minSize,
              max: maxSize,
              onChanged: (newValue) {
                setState(() => _newSliderValue(newValue));
              },
              value: sliderValue,
            ),
          ),
          RaisedButton(
            child: showFront
                ? Icon(Icons.camera_rear)
                : Icon(Icons.camera_front),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            onPressed: () {
              if (hasCameras) {
                _setCamera(showFront ? 0 : 1);
                showFront = !showFront;
              }
            },
          )
        ],
      ),
    );
  }

  void _setCamera(int i) {
    controller = CameraController(cameras[i], ResolutionPreset.medium);
    _updateCamera();
  }

  void _updateCamera() {
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void _newSliderValue(newValue) {
    setState(() {
      sliderValue = S = newValue;
      _updateConstraints();
    });
  }

  void _updateConstraints() {
    A = pitagoras(S);
    C = S - A;
    B = S + A - C;
  }
}