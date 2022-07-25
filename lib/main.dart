import 'package:face_detection/bloc/repositories_bloc.dart';
import 'package:face_detection/bloc/theme_bloc.dart';
import 'package:face_detection/bloc/users_bloc.dart';
import 'package:face_detection/views/root_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(),),
        BlocProvider(create: (context) => RepositoriesBloc(),),
        BlocProvider(create: (context) => ThemeBloc(),),
      ],
      child: const RootView(),
    );
  }
}

