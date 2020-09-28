import 'package:flutter/material.dart';
import 'package:form_get_users_bloc/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Material App Bar'),
            backgroundColor: Colors.purple,
          ),
          body: LoginPage()),
    );
  }
}
