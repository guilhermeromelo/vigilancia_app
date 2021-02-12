//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/views/guards/guardRegistration.dart';
import 'package:vigilancia_app/views/menu/menu.dart';
import 'package:vigilancia_app/views/schedule/schedulePage.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/schedule/sort/selectGuardsPage.dart';
import 'package:vigilancia_app/views/schedule/sort/selectWorkplacesPage.dart';
import 'package:vigilancia_app/views/schedule/sort/sortResultsPage.dart';
import 'package:vigilancia_app/views/users/userRegistration.dart';
import 'package:vigilancia_app/views/workplaces/workplaceRegistration.dart';

import 'models/guard/guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /*
  for (int i = 1; i < 9; i++) {
    FirebaseFirestore.instance
        .collection("guards")
        .doc(i.toString())
        .update({"visible": true});
  }*/

  //FirebaseFirestore.instance.collection("teste").doc().set({"deuCerto":true});

  SingletonSchedule().isDaytime=true;

  runApp(MaterialApp(
    initialRoute: 'menu',
    debugShowCheckedModeBanner: false,
    routes: {
      //Menu
      'menu': (context) => Menu(),
      //Schedule
      'schedule/schedulePage': (context) => SchedulePage(),
      'schedule/selectGuardsPage': (context) => SelectGuardsPage(),
      'schedule/selectWorkplacesPage': (context) => SelectWorkplacePage(),
      'schedule/resultsPage': (context) => SortResultsPage(),
      //Users
      'users/registration': (context) => UserRegistrationPage(),
      //Guards
      'guards/registration': (context) => GuardRegistrationPage(),
      //WorkPlaces
      'workplaces/registration': (context) => WorkplaceRegistrationPage(),
    },
  ));
}
