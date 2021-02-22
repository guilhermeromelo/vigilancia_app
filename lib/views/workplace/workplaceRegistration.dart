import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/workplace/workplaceDAO.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';
import 'package:vigilancia_app/views/shared/components//appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components//button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components//contSpinner/cont_spinner.dart';
import 'package:vigilancia_app/views/shared/components//header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/components//titleOrRowBuilder/TitleOrRowBuilder.dart';

String _placeName = "";
int _doormanQt = 0;
int _guardQt = 0;

class WorkplaceRegistrationPage extends StatefulWidget {
  bool _isWorkplaceUpdate = false;

  @override
  _WorkplaceRegistrationPageState createState() =>
      _WorkplaceRegistrationPageState();
}

class _WorkplaceRegistrationPageState extends State<WorkplaceRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      text1: "Diurno",
      text2: "Noturno",
      title: widget._isWorkplaceUpdate
          ? "Atualizar Posto Trabalho"
          : "Novo Posto Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      widget1: WorkplaceRegistrationSubPage(
        isUserUpdate: widget._isWorkplaceUpdate,
        index: 0,
      ),
      widget2: WorkplaceRegistrationSubPage(
        isUserUpdate: widget._isWorkplaceUpdate,
        index: 1,
      ),
    );
  }
}

class WorkplaceRegistrationSubPage extends StatefulWidget {
  bool isUserUpdate;
  final _formKey = GlobalKey<FormState>();
  int index;

  WorkplaceRegistrationSubPage({Key key, this.isUserUpdate, this.index})
      : super(key: key);

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
            initialValue: _placeName,
            labelText: "Nome",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
            },
            onChangedFunction: (text) {
              _placeName = text;
            },
          ),
          TitleBuilder(
              padding: EdgeInsets.only(top: 15, bottom: 5), title: "Porteiros"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContSpinner(
                initialValue: _doormanQt,
                onChangeFunction: (text) {
                  _doormanQt = int.parse(text);
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
                initialValue: _guardQt,
                onChangeFunction: (text) {
                  _guardQt = int.parse(text);
                },
              )
            ],
          ),
          AppButton(
            labelText: widget.isUserUpdate == false ? "Cadastrar" : "Atualizar",
            onPressedFunction: () {
              if (widget._formKey.currentState.validate()) {
                Workplace newWorkplace = Workplace(
                    id: 0,
                    guardQt: _guardQt,
                    name: _placeName,
                    doormanQt: _doormanQt,
                    type: widget.index);
                addWorkplace(newWorkplace, context);
              }
            },
          ),
        ],
      ),
    );
  }
}
