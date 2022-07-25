import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Utils {
  Future pickImage(ImageSource source, bool crop, double? maxWidth) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image;
    if(crop){
      image = await _picker.pickImage(source: source, maxWidth: maxWidth);
    }
    else {
      image = await _picker.pickImage(source: source);
    }
    final file = File(image!.path);
    return file;
  }

  /// crop the image from a file
  Future cropImage(File file) async {
    ImageCropper imageCropper = ImageCropper();
   var imageCropped =  await imageCropper.cropImage(
     sourcePath: file.path,
     aspectRatioPresets: Platform.isAndroid
       ? [
         CropAspectRatioPreset.square,
         CropAspectRatioPreset.ratio3x2,
         CropAspectRatioPreset.original,
         CropAspectRatioPreset.ratio4x3,
         CropAspectRatioPreset.ratio16x9
     ]
       : [
       CropAspectRatioPreset.original,
       CropAspectRatioPreset.square,
       CropAspectRatioPreset.ratio3x2,
       CropAspectRatioPreset.ratio5x3,
       CropAspectRatioPreset.ratio5x4,
       CropAspectRatioPreset.ratio7x5,
       CropAspectRatioPreset.ratio16x9,
     ],
     androidUiSettings: const AndroidUiSettings(
       toolbarTitle: 'Cropper',
       toolbarColor: Colors.deepOrange,
       toolbarWidgetColor: Colors.white,
       initAspectRatio: CropAspectRatioPreset.original,
       lockAspectRatio: false
     ),
     iosUiSettings: const IOSUiSettings(
       title: 'Cropper',
     )
   );
   return imageCropped;
  }
  /// Text OCR from an image using path
  Future textOcr(String path) async {
    String content = "";
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText _recognisedText = await textDetector.processImage(inputImage);

    for(TextBlock block in _recognisedText.blocks) {
      for(TextLine textLine in block.lines){
        for(TextElement textElement in textLine.elements){
          content  += " " + textElement.text;
        }

        content += '\n';
      }
    }
    return content;
  }
  /// Faces detected from an image using path
  Future faceDetector(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    List<Face> faces = await faceDetector.processImage(inputImage);
    /*
    for(Face face in faces){
      final Rect boundingBox = face.boundingBox;
      final double? rotY = face.headEulerAngleY; // head is rotated to the right rotY degrees
      final double? rotZ = face.headEulerAngleZ; // head is titled sideways rotZ degrees
      // if landmark detection was enabled with FaceDetectorOptions (mouth, ears, eyes, cheeks and nose available):
      final FaceLandmark? leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      if(leftEar != null){
        final Offset leftEarPos =leftEar.position;
      }

      //if classification was enabled with faceDetectorOptions:
      if(face.smilingProbability != null){
        final double? smileProb = face.smilingProbability;
      }
      // if face tracking was enabled with faceDetectorOptions:
      if(face.trackingId != null){
        final int? id = face.trackingId;
      }
    } */
    return faces;
  }
}
