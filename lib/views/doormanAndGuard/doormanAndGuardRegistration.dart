import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/appTextFormField/formatedTextField.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';

String name = "";
String cpf = "";

class DoormanAndGuardRegistrationPage extends StatefulWidget {
  bool isDoormanAndGuardUpdate = false;

  @override
  _DoormanAndGuardRegistrationPageState createState() =>
      _DoormanAndGuardRegistrationPageState();
}

class _DoormanAndGuardRegistrationPageState
    extends State<DoormanAndGuardRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    name = "";
    cpf = "";
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      text1: "Vigilante",
      text2: "Porteiro",
      title: widget.isDoormanAndGuardUpdate
          ? "Atualizar Colaborador"
          : "Novo Colaborador",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {},
      rightIcon1: widget.isDoormanAndGuardUpdate == false ? Icons.delete : null,
      rightIcon1Function: () {
        if (widget.isDoormanAndGuardUpdate == false) {}
      },
      widget1: UserRegistrationSubPage(isDoormanAndGuardUpdate: widget.isDoormanAndGuardUpdate,),
      widget2: UserRegistrationSubPage(isDoormanAndGuardUpdate: widget.isDoormanAndGuardUpdate,),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  bool isDoormanAndGuardUpdate;

  UserRegistrationSubPage({Key key, this.isDoormanAndGuardUpdate})
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
            onChangedFunction: (text) {
              name = text;
            },
            initialValue: name,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
          ),
          AppTextFormField(
            onChangedFunction: (text) {
              cpf = text;
            },
            initialValue: cpf,
            labelText: "CPF",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
          ),
          AppButton(
            labelText: widget.isDoormanAndGuardUpdate == false ? "Cadastrar" : "Atualizar",
            onPressedFunction: (){

            },
          ),
        ],
      ),
    );
  }
}
