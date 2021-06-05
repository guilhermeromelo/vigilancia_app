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
import 'package:vigilancia_app/views/shared/components/popup/popup.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.01),
              child: Image.asset(
                "assets/logo_nome_azul.png",
                height: size.height * 0.10,
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  "Realize o Login Para Continuar",
                  style: TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            AppTextFormField(
              keyboardInputType: TextInputType.number,
              initialValue: widget._matricula,
              labelText: "Matrícula",
              externalPadding: EdgeInsets.only(
                  top: size.height * 0.015, left: 10, right: 10),
              validatorFunction: (text) {
                if (text.isEmpty) return "Campo Vazio";
              },
              onChangedFunction: (text) {
                widget._matricula = text;
              },
            ),
            AppTextFormField(
              textCapitalization: TextCapitalization.none,
              suffixIcon:
                  widget._obscureText ? Icons.visibility : Icons.visibility_off,
              suffixIconOnPressed: () {
                setState(() {
                  widget._obscureText = !widget._obscureText;
                });
              },
              obscureText: widget._obscureText,
              initialValue: widget._senha,
              labelText: "Senha",
              externalPadding: EdgeInsets.only(
                  top: size.height * 0.015, left: 10, right: 10),
              validatorFunction: (text) {
                if (text.isEmpty) return "Campo Vazio";
              },
              onChangedFunction: (text) {
                widget._senha = text;
              },
            ),
            Container(
              width: size.width,
              child: AppButton(
                labelText: "Entrar",
                onPressedFunction: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  var bytes = utf8.encode(widget._senha); // data being hashed
                  var digest = sha1.convert(bytes);

                  if (widget._formKey.currentState.validate()) {

                    await FirebaseFirestore.instance
                        .collection("users")
                        .where("matricula", isEqualTo: widget._matricula)
                        .where("senha", isEqualTo: digest.toString())
                        .get()
                        .timeout(Duration(seconds: 5), onTimeout: () {
                      throw (showDialog(
                          context: context,
                          builder: (context) {
                            return PopUpInfo(
                              onOkPressed: () {
                                Navigator.of(context).pop();
                              },
                              title: "Problema Encontrado!",
                              text:
                                  "Verifique sua conexão com a Internet ou tente novamente mais tarde!",
                            );
                          }));
                    }).catchError((err) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PopUpInfo(
                              onOkPressed: () {
                                Navigator.of(context).pop();
                              },
                              title: "Problema Encontrado!",
                              text:
                                  "Verifique sua conexão com a Internet ou tente novamente mais tarde!",
                            );
                          });
                    }).then((QuerySnapshot snapshot) {
                      if (snapshot != null && snapshot.docs.isNotEmpty) {
                        SingletonLogin().loggedUser =
                            docToUser(snapshot.docs.first);
                        _increment();
                        Navigator.pushReplacementNamed(context, 'menu');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PopUpInfo(
                                onOkPressed: () {
                                  Navigator.of(context).pop();
                                },
                                title: "Problema Encontrado!",
                                text: "Verifique seu usuário, senha e conexão com a internet.",
                              );
                            });
                      }
                    });
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
