//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/views/doormanAndGuard/doormanAndGuardRegistration.dart';
import 'package:vigilancia_app/views/menu/menu.dart';
import 'package:vigilancia_app/views/schedule/schedulePage.dart';
import 'package:vigilancia_app/views/users/userRegistration.dart';
import 'package:vigilancia_app/views/workplace/workplaceRegistration.dart';

import 'models/guard/guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //FirebaseFirestore.instance.collection("teste").doc().set({"deuCerto":true});

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
      //WorkPlaces
      'workplace/registration': (context) => WorkplaceRegistrationPage(),
    },
  ));
}
