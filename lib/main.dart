//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/doormanAndGuard/doormanAndGuardRegistration.dart';
import 'package:vigilancia_app/views/menu/menu.dart';
import 'package:vigilancia_app/views/schedule/schedulePage.dart';
import 'package:vigilancia_app/views/users/userRegistration.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: 'menu',
    debugShowCheckedModeBanner: false,
    routes: {
      //Menu
      'menu': (context) => Menu(),
      //Schedule
      'schedule/schedulePage': (context) => SchedulePage(),
      //Users
      'users/registration': (context) => UserRegistrationPage(),
      //DoormanAndGuard
      'doormanAndGuard/registration': (context) => DoormanAndGuardRegistrationPage(),
    },
  ));
}
