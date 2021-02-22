import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/comboBox/comboBox.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';

String _name = "";
String _cpf = "";
String _team = "";

class GuardRegistrationPage extends StatefulWidget {
  bool isDoormanAndGuardUpdate = false;

  @override
  _GuardRegistrationPageState createState() => _GuardRegistrationPageState();
}

class _GuardRegistrationPageState extends State<GuardRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    _name = "";
    _cpf = "";
    _team = "";
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      text1: "Vigilante",
      text2: "Porteiro",
      title: widget.isDoormanAndGuardUpdate
          ? "Atualizar Colaborador"
          : "Novo Colaborador",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      widget1: UserRegistrationSubPage(
        isDoormanAndGuardUpdate: widget.isDoormanAndGuardUpdate,
        index: 0,
      ),
      widget2: UserRegistrationSubPage(
        isDoormanAndGuardUpdate: widget.isDoormanAndGuardUpdate,
        index: 1,
      ),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  int index;
  bool isDoormanAndGuardUpdate;

  UserRegistrationSubPage({Key key, this.isDoormanAndGuardUpdate, this.index})
      : super(key: key);

  @override
  _UserRegistrationSubPageState createState() =>
      _UserRegistrationSubPageState();
}

class _UserRegistrationSubPageState extends State<UserRegistrationSubPage> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.94;
    return Form(
      key: widget._formKey,
      child: ListView(
        children: [
          AppTextFormField(
            onChangedFunction: (text) {
              _name = text;
            },
            initialValue: _name,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
          ),
          AppTextFormField(
            onChangedFunction: (text) {
              _cpf = text;
            },
            initialValue: _cpf,
            labelText: "CPF",
            inputFormatterField: AppMasks.cpfMask,
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 15, left: (width - 150) / 2, right: (width - 150) / 2),
            child: ComboBox(
              currentObject: _team.isNotEmpty ? _team : null,
              title: "Time",
              objects: [
                "A",
                "B",
                "C",
                "D",
              ],
              onTapFunction: getComboBoxItem,
              validatorFunction: (text) {
                if (_team.isEmpty) return "Campo Vazio";
              },
            ),
          ),
          AppButton(
            labelText: widget.isDoormanAndGuardUpdate == false
                ? "Cadastrar"
                : "Atualizar",
            onPressedFunction: () {
              if (widget._formKey.currentState.validate()) {
                Guard guard = Guard(
                    id: 0,
                    name: _name,
                    cpf: _cpf,
                    type: widget.index,
                    team: _team);
                addGuard(guard, context);
              }
            },
          ),
        ],
      ),
    );
  }

  void getComboBoxItem(String text) {
    _team = text;
  }
}
