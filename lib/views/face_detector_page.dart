import 'dart:io';

import 'package:face_detection/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  late ui.Image imageFile;
  bool imageLoaded = false;
  late List<Face> faces = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detector'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              child: (imageLoaded == true)
                  ? CustomPaint(
                      foregroundPainter: ImagePainter(faces, imageFile),
                      // child: imageLoaded?Image.file(imageFile):const Text('No Image'),
                    )
                  : Container(),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.camera),
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Source'),
                    content: const Text('Select the source'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          List<Face> faceList = await faceDetect(context, ImageSource.camera);
                          setState(() {
                            faces = faceList;
                          });
                        },
                        child: const Text('Camera'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          List<Face> faceList = await faceDetect(context, ImageSource.gallery);
                          setState(() {
                            faces = faceList;
                          });
                        },
                        child: const Text('Gallery'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  faceDetect(context, source) async {
    Navigator.of(context).pop();
    File image = await Utils().pickImage(source, true, 400);
    final data = image.readAsBytesSync();
    var imageData = await decodeImageFromList(data);
    setState(() {
      imageFile = imageData;
      imageLoaded = true;
    });
    List<Face> faceList = await Utils().faceDetector(image.path);
    setState(() {
      faces=faceList;
    });
  }
}

class ImagePainter extends CustomPainter {
  List<Face> faces;
  ui.Image imageFile;

  ImagePainter(this.faces, this.imageFile);

  @override
  void paint(Canvas canvas, Size size) async {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(255, 0, 0, 1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawImage(imageFile, Offset.zero, paint);
    for (var face in faces) {
      canvas.drawRect(face.boundingBox, paint);
    }
    canvas.drawRect(const Offset(0,0) & Size(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) {
    return imageFile != oldDelegate.imageFile || faces != oldDelegate.faces;
  }
}
