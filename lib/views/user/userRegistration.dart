import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/user/userDAO.dart';
import 'package:vigilancia_app/models/user/user.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';

String _name = "";
String _cpf = "";
String _senha = "";
bool _obscureText = true;

class UserRegistrationPage extends StatefulWidget {
  bool _isUserUpdate = false;

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    _name = "";
    _cpf = "";
    _senha = "";
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      text1: "Administrador",
      text2: "Líder Equipe",
      title: widget._isUserUpdate ? "Atualizar Usuário" : "Novo Usuário",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      widget1: UserRegistrationSubPage(
        isUserUpdate: widget._isUserUpdate,
        index: 0,
      ),
      widget2: UserRegistrationSubPage(
        isUserUpdate: widget._isUserUpdate,
        index: 1,
      ),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {
  bool isUserUpdate;
  final _formKey = GlobalKey<FormState>();
  int index;

  UserRegistrationSubPage({Key key, this.isUserUpdate, this.index})
      : super(key: key);

  @override
  _UserRegistrationSubPageState createState() =>
      _UserRegistrationSubPageState();
}

class _UserRegistrationSubPageState extends State<UserRegistrationSubPage> {
  @override
  Widget build(BuildContext context) {
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
            inputFormatterField: AppMasks.cpfMask,
            initialValue: _cpf,
            labelText: "CPF",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _cpf = text;
            },
          ),
          AppTextFormField(
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
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _senha = text;
            },
          ),
          AppButton(
            labelText: widget.isUserUpdate == false ? "Cadastrar" : "Atualizar",
            onPressedFunction: () {
              if (widget._formKey.currentState.validate()) {
                var bytes = utf8.encode(_senha); // data being hashed
                var digest = sha1.convert(bytes);

                User newUser = User(
                    id: 0,
                    name: _name,
                    cpf: _cpf,
                    type: widget.index,
                    senha: digest.toString());
                addUser(newUser, context);
              }
            },
          ),
        ],
      ),
    );
  }
}
