import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/workplace/workplaceDAO.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';
import 'package:vigilancia_app/views/shared/components//appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components//button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components//contSpinner/cont_spinner.dart';
import 'package:vigilancia_app/views/shared/components//header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/components//titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/components/popup/popup.dart';
import 'package:vigilancia_app/views/workplace/singletonWorkplace.dart';

String _placeName = "";
int _doormanQt = 0;
int _guardQt = 0;
int _initialIndex = 0;

class WorkplaceRegistrationPage extends StatefulWidget {
  @override
  _WorkplaceRegistrationPageState createState() =>
      _WorkplaceRegistrationPageState();
}

class _WorkplaceRegistrationPageState extends State<WorkplaceRegistrationPage> {
  @override
  void initState() {
    // TODO: implement initState
    if (SingletonWorkplace().isUpdate) {
      _placeName = SingletonWorkplace().workplace.name;
      _doormanQt = SingletonWorkplace().workplace.doormanQt;
      _guardQt = SingletonWorkplace().workplace.guardQt;
      _initialIndex = SingletonWorkplace().workplace.type;
    } else {
      _placeName = "";
      _doormanQt = 0;
      _guardQt = 0;
      _initialIndex = SingletonWorkplace().currentIndexForWorkplaceListPage;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternalHeaderWithTabBar(
      initialIndex: _initialIndex,
      tabQuantity_x2_or_x3: 2,
      text1: "Diurno",
      text2: "Noturno",
      title: SingletonWorkplace().isUpdate ? "Editar Posto" : "Novo Posto",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      rightIcon1: SingletonWorkplace().isUpdate ? Icons.delete : null,
      rightIcon1Function: SingletonWorkplace().isUpdate ?() {
        if (SingletonWorkplace().isUpdate) {
          showDialog(
            context: context,
            builder: (context) {
              return PopUpYesOrNo(
                title: 'Deletar Posto de Trabalho',
                text: 'Deseja realmente deletar este posto de trabalho?',
                onYesPressed: () async {
                  SingletonWorkplace().currentIndexForWorkplaceListPage =  SingletonWorkplace().workplace.type;
                  await deleteWorkplace(
                      idDeleteWorkplace: SingletonWorkplace().workplace.id,
                      context: context);
                  await Navigator.popUntil(
                      context, ModalRoute.withName('menu'));
                  Navigator.pushNamed(context, 'workplace/list');
                },
                onNoPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }
      } : null,
      widget1: WorkplaceRegistrationSubPage(
        index: 0,
      ),
      widget2: WorkplaceRegistrationSubPage(
        index: 1,
      ),
    );
  }
}

class WorkplaceRegistrationSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  int index;

  WorkplaceRegistrationSubPage({Key key, this.index}) : super(key: key);

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
            labelText: SingletonWorkplace().isUpdate == false
                ? "Cadastrar"
                : "Atualizar",
            onPressedFunction: () async {
              if (widget._formKey.currentState.validate()) {
                Workplace newWorkplace = Workplace(
                    id: SingletonWorkplace().isUpdate
                        ? SingletonWorkplace().workplace.id
                        : 0,
                    guardQt: _guardQt,
                    name: _placeName,
                    doormanQt: _doormanQt,
                    type: widget.index);
                SingletonWorkplace().currentIndexForWorkplaceListPage =  widget.index;
                SingletonWorkplace().isUpdate
                    ? await updateWorkplace(newWorkplace, context)
                    : await addWorkplace(newWorkplace, context);

                await Navigator.popUntil(
                    context, ModalRoute.withName('menu'));
                Navigator.pushNamed(context, 'workplace/list');
              }
            },
          ),
        ],
      ),
    );
  }
}
