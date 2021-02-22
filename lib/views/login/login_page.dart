import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/user/userDAO.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';

class LoginPage extends StatefulWidget {
  String _cpf = "";
  String _senha = "";
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              inputFormatterField: AppMasks.cpfMask,
              initialValue: widget._cpf,
              labelText: "CPF",
              externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
              validatorFunction: (text) {
                if (text.isEmpty) return "Campo Vazio";
              },
              onChangedFunction: (text){
                widget._cpf = text;
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

                  var bytes = utf8.encode(widget._senha); // data being hashed
                  var digest = sha1.convert(bytes);

                  if(widget._formKey.currentState.validate()){
                    QuerySnapshot snapshot;
                    snapshot = await FirebaseFirestore.instance.collection("user")
                        .where("cpf", isEqualTo: widget._cpf)
                        .where("senha", isEqualTo: digest.toString())
                        .get();
                    if(snapshot!=null && snapshot.docs.isNotEmpty){
                      print(snapshot.docs.first.toString());
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
}
