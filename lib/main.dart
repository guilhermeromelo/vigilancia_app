//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/menu/menu.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: 'menu',
    debugShowCheckedModeBanner: false,
    routes: {
      //Menu
      'menu': (context) => Menu(),
    },
  ));
}
