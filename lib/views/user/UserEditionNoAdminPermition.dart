import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/user/userDAO.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/popup/popup.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';
import 'package:vigilancia_app/views/user/singletonUser.dart';

String _name = "";
String _matricula = "";
String _senha = "";
bool _obscureText = true;

class UserEditionNoAdminPermitionPage extends StatefulWidget {
  @override
  _UserEditionNoAdminPermitionPageState createState() =>
      _UserEditionNoAdminPermitionPageState();
}

class _UserEditionNoAdminPermitionPageState
    extends State<UserEditionNoAdminPermitionPage> {
  @override
  void initState() {
    // TODO: implement initState
    if (SingletonUser().isUpdate) {
      _name = SingletonUser().user.name;
      _matricula = SingletonUser().user.matricula;
      _senha = "";
    } else {
      _name = "";
      _matricula = "";
      _senha = "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternalHeader(
      title: "Editar Usuário",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      body: UserRegistrationNoAdminSubPage(),
    );
  }
}

class UserRegistrationNoAdminSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  _UserRegistrationNoAdminSubPageState createState() =>
      _UserRegistrationNoAdminSubPageState();
}

class _UserRegistrationNoAdminSubPageState
    extends State<UserRegistrationNoAdminSubPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: widget._formKey,
      child: ListView(
        children: [
          AppTextFormField(
            initialValue: _name,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _name = text;
            },
          ),
          AppTextFormField(
            keyboardInputType: TextInputType.number,
            readOnly: true,
            initialValue: _matricula,
            labelText: "Matrícula",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _matricula = text;
            },
          ),
          Text("A matrícula não pode ser alterada.", style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
          AppTextFormField(
            textCapitalization: TextCapitalization.none,
            suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            obscureText: _obscureText,
            initialValue: _senha,
            labelText: "Senha",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (SingletonUser().isUpdate == false) {
                if (text.isEmpty) return "Campo Vazio";
              }
            },
            onChangedFunction: (text) {
              _senha = text;
            },
          ),
          Visibility(
              visible: SingletonUser().isUpdate,
              child: Container(
                width: size.width,
                padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                child: Row(
                  children: [
                    Text(
                      "Atenção: ",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    Expanded(
                        child: Text(
                      "Caso NÃO deseje alterar a senha, deixe em branco",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ))
                  ],
                ),
              )),
          AppButton(
            labelText: "Atualizar",
            onPressedFunction: () async {
              if (widget._formKey.currentState.validate()) {
                var bytes = utf8.encode(_senha); // data being hashed
                var digest = sha1.convert(bytes);

                User newUser = User(
                    id: SingletonUser().isUpdate ? SingletonUser().user.id : 0,
                    name: _name,
                    matricula: _matricula,
                    senha: digest.toString());
                if (_senha.isEmpty) {
                  await updateUserWithoutPassword(newUser, context);
                } else {
                  await updateUserWithPassword(newUser, context);
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
