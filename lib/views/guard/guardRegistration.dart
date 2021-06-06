import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/guard/guardDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/guard/singletonGuard.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/comboBox/comboBox.dart';
import 'package:vigilancia_app/views/shared/components/popup/popup.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';

String _name = "";
String _matricula = "";
String _team = "";
int _initialIndex = 0;

class GuardRegistrationPage extends StatefulWidget {
  @override
  _GuardRegistrationPageState createState() => _GuardRegistrationPageState();
}

class _GuardRegistrationPageState extends State<GuardRegistrationPage> {
  @override
  void initState() {
    // TODO: implement initState
    if (SingletonGuard().isUpdate) {
      _name = SingletonGuard().guard.name;
      _matricula = SingletonGuard().guard.matricula;
      _team = SingletonGuard().guard.team;
      _initialIndex = SingletonGuard().guard.type;
    } else {
      _name = "";
      _matricula = "";
      _team = "";
      _initialIndex = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternalHeaderWithTabBar(
      initialIndex: _initialIndex,
      tabQuantity_x2_or_x3: 2,
      text1: "Vigilante",
      text2: "Porteiro",
      title:
          SingletonGuard().isUpdate ? "Editar Colaborador" : "Novo Colaborador",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      rightIcon1: SingletonGuard().isUpdate ? Icons.delete : null,
      rightIcon1Function: SingletonGuard().isUpdate
          ? () {
              if (SingletonGuard().isUpdate) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PopUpYesOrNo(
                      title: 'Deletar ' +
                          (SingletonGuard().guard.type == 0
                              ? "Vigilante"
                              : "Porteiro"),
                      text: 'Deseja realmente deletar este ' +
                          (SingletonGuard().guard.type == 0
                              ? "Vigilante ?"
                              : "Porteiro ?"),
                      onYesPressed: () async {
                        await deleteGuard(SingletonGuard().guard.id, context);
                        await Navigator.popUntil(
                            context, ModalRoute.withName('menu'));

                        switch (SingletonGuard().guard.team) {
                          case "A":
                            {
                              SingletonGuard().currentIndexForGuardListPage = 1;
                              break;
                            }
                          case "B":
                            {
                              SingletonGuard().currentIndexForGuardListPage = 2;
                              break;
                            }
                          case "C":
                            {
                              SingletonGuard().currentIndexForGuardListPage = 3;
                              break;
                            }
                          case "D":
                            {
                              SingletonGuard().currentIndexForGuardListPage = 4;
                              break;
                            }
                        }

                        Navigator.pushNamed(context, 'guard/list');
                      },
                      onNoPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              }
            }
          : null,
      widget1: UserRegistrationSubPage(
        index: 0,
      ),
      widget2: UserRegistrationSubPage(
        index: 1,
      ),
    );
  }
}

class UserRegistrationSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  int index;

  UserRegistrationSubPage({Key key, this.index}) : super(key: key);

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
            inputFormatterField: AppMasks.matriculaMask,
            keyboardInputType: TextInputType.number,
            onChangedFunction: (text) {
              _matricula = text;
            },
            initialValue: _matricula,
            labelText: "Matrícula",
            externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
            validatorFunction: (text) {
              if (text.isEmpty) return "Campo Vazio";
              if (text.length<=3) return "Matrícula Inválida";
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
            labelText:
                SingletonGuard().isUpdate == false ? "Cadastrar" : "Atualizar",
            onPressedFunction: () async {
              if (widget._formKey.currentState.validate()) {
                Guard guard = Guard(
                    id: SingletonGuard().isUpdate
                        ? SingletonGuard().guard.id
                        : 0,
                    name: _name,
                    matricula: _matricula,
                    type: widget.index,
                    team: _team);
                if (SingletonGuard().isUpdate) {
                  await updateGuard(guard, context);
                } else {
                  await addGuard(guard, context);
                }

                switch (_team) {
                  case "A":
                    {
                      SingletonGuard().currentIndexForGuardListPage = 1;
                      break;
                    }
                  case "B":
                    {
                      SingletonGuard().currentIndexForGuardListPage = 2;
                      break;
                    }
                  case "C":
                    {
                      SingletonGuard().currentIndexForGuardListPage = 3;
                      break;
                    }
                  case "D":
                    {
                      SingletonGuard().currentIndexForGuardListPage = 4;
                      break;
                    }
                }

                await Navigator.popUntil(context, ModalRoute.withName('menu'));
                Navigator.pushNamed(context, 'guard/list');
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
