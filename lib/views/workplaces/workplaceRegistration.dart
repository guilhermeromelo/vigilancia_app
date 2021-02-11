import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/appTextFormField/formatedTextField.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/contSpinner/cont_spinner.dart';
import 'package:vigilancia_app/views/shared/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/titleOrRowBuilder/TitleOrRowBuilder.dart';

String placeName = "";
int doormanQt = 0;
int guardQt = 0;

class WorkplaceRegistrationPage extends StatefulWidget {
  bool isUserUpdate = false;

  @override
  _WorkplaceRegistrationPageState createState() =>
      _WorkplaceRegistrationPageState();
}

class _WorkplaceRegistrationPageState extends State<WorkplaceRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    placeName = "";
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      text1: "Diurno",
      text2: "Noturno",
      title: widget.isUserUpdate
          ? "Atualizar Posto Trabalho"
          : "Novo Posto Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {},
      rightIcon1: widget.isUserUpdate == false ? Icons.delete : null,
      rightIcon1Function: () {
        if (widget.isUserUpdate == false) {}
      },
      widget1: WorkplaceRegistrationSubPage(
        isUserUpdate: widget.isUserUpdate,
      ),
      widget2: WorkplaceRegistrationSubPage(
        isUserUpdate: widget.isUserUpdate,
      ),
    );
  }
}

class WorkplaceRegistrationSubPage extends StatefulWidget {
  bool isUserUpdate;
  final _formKey = GlobalKey<FormState>();

  WorkplaceRegistrationSubPage({Key key, this.isUserUpdate}) : super(key: key);

  @override
  _WorkplaceRegistrationSubPageState createState() =>
      _WorkplaceRegistrationSubPageState();
}

class _WorkplaceRegistrationSubPageState
    extends State<WorkplaceRegistrationSubPage> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: ListView(
        children: [
          AppTextFormField(
            initialValue: placeName,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              placeName = text;
            },
          ),
          TitleBuilder(
              padding: EdgeInsets.only(top: 15, bottom: 5), title: "Porteiros"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContSpinner(
                initialValue: doormanQt,
                onChangeFunction: (text) {
                  doormanQt = int.parse(text);
                },
              )
            ],
          ),
          TitleBuilder(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              title: "Vigilantes"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContSpinner(
                initialValue: guardQt,
                onChangeFunction: (text) {
                  guardQt = int.parse(text);
                },
              )
            ],
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
