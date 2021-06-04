import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/views/guard/guardListPage.dart';
import 'package:vigilancia_app/views/guard/guardRegistration.dart';
import 'package:vigilancia_app/views/login/login_page.dart';
import 'package:vigilancia_app/views/login/singletonLogin.dart';
import 'package:vigilancia_app/views/menu/menu.dart';
import 'package:vigilancia_app/views/schedule/scheduleListPage.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/schedule/sort/selectGuardsPage.dart';
import 'package:vigilancia_app/views/schedule/sort/selectWorkplacesPage.dart';
import 'package:vigilancia_app/views/schedule/sort/sortResultsPage.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/splash/splashPage.dart';
import 'package:vigilancia_app/views/user/userListPage.dart';
import 'package:vigilancia_app/views/user/userRegistration.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/views/user/UserEditionNoAdminPermition.dart';
import 'package:vigilancia_app/views/workplace/workplaceInfoPage.dart';
import 'package:vigilancia_app/views/workplace/workplaceListPage.dart';
import 'package:vigilancia_app/views/workplace/workplaceRegistration.dart';

import 'models/guard/guard.dart';
import 'models/user/user.dart';

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
/*
  DateFormat("dd/MM/yy - HH:mm")
      .format(DateTime.now())
      .toString();
*/
  /*User logado = User(type: 1, name: "Guilherme", matricula: "0212313", id: 1);
  SingletonLogin().loggedUser = logado;*/


  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt', 'BR')],
    initialRoute: 'splash',
    debugShowCheckedModeBanner: false,
    routes: {
      //Splash
      'splash': (context) => SplashPage(),
      //Login
      'login': (context) => LoginPage(),
      //Menu
      'menu': (context) => Menu(),
      //Schedule
      'schedule/schedulePage': (context) => ScheduleListPage(),
      'schedule/selectGuardsPage': (context) => SelectGuardsPage(),
      'schedule/selectWorkplacesPage': (context) => SelectWorkplacePage(),
      'schedule/resultsPage': (context) => SortResultsPage(),
      //User
      'user/registration': (context) => UserRegistrationPage(),
      'user/registrationNoAdmin': (context) => UserEditionNoAdminPermitionPage(),
      'user/list': (context) => UserListPage(),
      //Guard
      'guard/registration': (context) => GuardRegistrationPage(),
      'guard/list': (context) => GuardListPage(),
      //WorkPlace
      'workplace/registration': (context) => WorkplaceRegistrationPage(),
      'workplace/list': (context) => WorkplaceListPage(),
      //'workplace/info': (context) => WorkplaceInfoPage(),
    },
  ));
}
