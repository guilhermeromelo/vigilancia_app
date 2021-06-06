import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/login/singletonLogin.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3)).then((_) {
      _prefs.then((SharedPreferences prefs) {
        String m = prefs.getString('matricula') ?? '0';
        String s = prefs.getString('senha') ?? '0';
        print(m + s);
        FirebaseFirestore.instance
            .collection('users')
            .where('matricula', isEqualTo: m)
            .where('senha', isEqualTo: s)
            .where('visible', isEqualTo: true)
            .limit(1)
            .get()
            .then(
          (QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              querySnapshot.docs.forEach(
                (doc) {
                  SingletonLogin().loggedUser = docToUser(doc);
                  Navigator.pushReplacementNamed(context, 'menu');
                },
              );
            } else {
              Navigator.pushReplacementNamed(context, 'login');
            }
          },
        );

        return;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.mainBlue,
      child: Center(child: Image.asset(
        "assets/logo_nome_branco.png",
        width: size.width*0.85,
      ),),
    );
  }
}
