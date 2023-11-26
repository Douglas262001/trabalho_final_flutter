import 'package:flutter/material.dart';
import 'package:trabalho_final/models/user.dart';
import 'package:trabalho_final/pages/edit_user_screen.dart';
import 'package:trabalho_final/pages/user_list_screen.dart';
import 'package:trabalho_final/pages/add_user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Usuários',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => UserListScreen(),
        '/addUser': (context) => AddUserScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/editUser') {
          final args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) {
              return EditUserScreen(args as User);
            },
          );
        }
      },
    );
  }
}
