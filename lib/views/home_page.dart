import 'dart:io';
import 'package:face_detection/bloc/theme_bloc.dart';
import 'package:face_detection/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menus = [
      {"title":"Home", "icon": Icon(Icons.home, color: Theme.of(context).primaryColor,), "route":"/"},
      {"title":"OCR", "icon": Icon(Icons.ac_unit, color: Theme.of(context).primaryColor,), "route":"/ocr"},
      {"title":"Face Detector", "icon": Icon(Icons.face, color: Theme.of(context).primaryColor,), "route":"/face"},
      {"title":"QR Code Generator", "icon": Icon(Icons.qr_code, color: Theme.of(context).primaryColor,), "route":"/QR"},
      {"title":"QR Scan", "icon": Icon(Icons.qr_code, color: Theme.of(context).primaryColor,), "route":"/scanQR"},
      // {"title":"Graphics", "icon": Icon(Icons.grading, color: Theme.of(context).primaryColor,), "route":"/graphics"},
      // {"title":"Github Users", "icon": Icon(Icons.verified_user, color: Theme.of(context).primaryColor,), "route":"/users"},
    ];
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to exit?'),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    exit(0);
                  },
                  child: const Text('Exit'),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('DetectQue'),
          actions: [
            IconButton(
              onPressed: (){
                context.read<ThemeBloc>().add(SwitchThemeEvent());
              },
              icon: const Icon(Icons.switch_account),
            ),
          ],
        ),
        drawer: const MyDrawer(),
        body: ListView.separated(
          separatorBuilder: (_,__){
            return Divider(color: Theme.of(context).primaryColor, height: 1,);
          },
          itemCount: menus.length,
          itemBuilder: (_,index){
            return ListTile(
              leading: menus[index]['icon'] as Icon,
              title: Text("${menus[index]['title']}"),
              onTap: (){
                // Navigator.of(context).pop();
                Navigator.pushNamed(context, "${menus[index]['route']}");
              },
            );
          },
        ),
      ),
    );
  }
}
