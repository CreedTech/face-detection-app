import 'package:face_detection/bloc/theme_bloc.dart';
import 'package:face_detection/views/face_detector_page.dart';
import 'package:face_detection/views/home_page.dart';
import 'package:face_detection/views/ocr_page.dart';
import 'package:face_detection/views/qr_code_page.dart';
import 'package:face_detection/views/qr_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootView extends StatelessWidget {
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.theme,
            routes: {
              "/": (context) => const HomePage(),
              "/ocr": (context) => const OcrPage(),
              "/face": (context) => const FaceDetectorPage(),
              "/QR": (context) => const QRCodePage(),
              "/scanQR": (context) => const QRViewScannerPage(),
              // "/graphics": (context) => const GraphicsPage(),
              // "/users": (context) => const UsersPage(),
            },
          );
        },
    );
  }
}
