import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigilancia_app/controllers/user/userDAO.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/login/singletonLogin.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';

class LoginPage extends StatefulWidget {
  String _matricula = "";
  String _senha = "";
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: widget._formKey,
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextFormField(
              initialValue: widget._matricula,
              labelText: "Matrícula",
              externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
              validatorFunction: (text) {
                if (text.isEmpty) return "Campo Vazio";
              },
              onChangedFunction: (text){
                widget._matricula = text;
              },
            ),
            AppTextFormField(
              suffixIcon: widget._obscureText ? Icons.visibility : Icons.visibility_off,
              suffixIconOnPressed: (){
                setState(() {
                  widget._obscureText = !widget._obscureText;
                });
              },
              obscureText: widget._obscureText,
              initialValue: widget._senha,
              labelText: "Senha",
              externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
              validatorFunction: (text) {
                if (text.isEmpty) return "Campo Vazio";
              },
              onChangedFunction: (text){
                widget._senha = text;
              },
            ),
            Container(
              width: size.width,
              child:  AppButton(
                labelText: "Entrar",
                onPressedFunction: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  var bytes = utf8.encode(widget._senha); // data being hashed
                  var digest = sha1.convert(bytes);

                  if(widget._formKey.currentState.validate()){
                    QuerySnapshot snapshot;
                    snapshot = await FirebaseFirestore.instance.collection("users")
                        .where("matricula", isEqualTo: widget._matricula)
                        .where("senha", isEqualTo: digest.toString())
                        .get();
                    if(snapshot!=null && snapshot.docs.isNotEmpty){
                      SingletonLogin().loggedUser = docToUser(snapshot.docs.first);
                      _increment();
                      Navigator.pushReplacementNamed(context, 'menu');
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _increment() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      prefs.setString("matricula", SingletonLogin().loggedUser.matricula);
      prefs.setString("senha", SingletonLogin().loggedUser.senha);
    });
  }
}
