import 'package:face_detection/repository/users_repository.dart';
import 'package:face_detection/views/repositories_page.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UsersRepository usersRepository = UsersRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: const GitRepositoriesPage(user: 'CreedTech'),
    );
  }
}
