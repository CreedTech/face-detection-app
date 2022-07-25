import 'dart:io';
import 'package:face_detection/bloc/theme_bloc.dart';
import 'package:face_detection/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Home Page'),
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
      ),
    );
  }
}
