import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/appTextFormField/formatedTextField.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';

final _formKey = GlobalKey<FormState>();

class UserRegistrationPage extends StatefulWidget {
  bool isUserUpdate = false;

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return InternalHeader(
      title: widget.isUserUpdate ? "Atualizar Usuário" : "Novo Usuário",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {},
      rightIcon1: Icons.filter_alt,
      rightIcon1Function: () {
        _formKey.currentState.validate();
      },
      body: UserRegistrationSubPage(),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {


  @override
  _UserRegistrationSubPageState createState() => _UserRegistrationSubPageState();
}

class _UserRegistrationSubPageState extends State<UserRegistrationSubPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          AppTextFormField(
            labelText: "Pesquisar",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text){
              if(text.isEmpty) return "Campo Vazio";
            },
          ),
          AppTextFormField(
            labelText: "Pesquisar",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text){
              if(text.isEmpty) return "Campo Vazio";
            },
          ),            AppTextFormField(
            labelText: "Pesquisar",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text){
              if(text.isEmpty) return "Campo Vazio";
            },
          ),
          AppTextFormField(
            labelText: "Pesquisar",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text){
              if(text.isEmpty) return "Campo Vazio";
            },
          )
        ],
      ),
    );
  }
}
