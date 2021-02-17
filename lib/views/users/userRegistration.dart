import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';

String name = "";
String cpf = "";
String senha = "";
bool obscureText = true;

class UserRegistrationPage extends StatefulWidget {
  bool isUserUpdate = false;

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    name = "";
    cpf = "";
    senha = "";
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      text1: "Administrador",
      text2: "Líder Equipe",
      title: widget.isUserUpdate ? "Atualizar Usuário" : "Novo Usuário",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {},
      rightIcon1: widget.isUserUpdate == false ? Icons.delete : null,
      rightIcon1Function: () {
        if (widget.isUserUpdate == false) {}
      },
      widget1: UserRegistrationSubPage(
        isUserUpdate: widget.isUserUpdate,
      ),
      widget2: UserRegistrationSubPage(
        isUserUpdate: widget.isUserUpdate,
      ),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {
  bool isUserUpdate;
  final _formKey = GlobalKey<FormState>();

  UserRegistrationSubPage({Key key, this.isUserUpdate}) : super(key: key);

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
            initialValue: name,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text){
              name = text;
            },
          ),
          AppTextFormField(
            initialValue: cpf,
            labelText: "CPF",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text){
              cpf = text;
            },
          ),
          AppTextFormField(
            suffixIcon: obscureText ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: (){
              setState(() {
                obscureText = !obscureText;
              });
            },
            obscureText: obscureText,
            initialValue: senha,
            labelText: "Senha",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text){
              senha = text;
            },
          ),
          AppButton(
            labelText: widget.isUserUpdate == false ? "Cadastrar" : "Atualizar",
            onPressedFunction: () {},
          ),
        ],
      ),
    );
  }
}
