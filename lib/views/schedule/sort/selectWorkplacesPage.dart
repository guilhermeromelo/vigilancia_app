import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/controllers/schedule/dateValidation.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';
import 'package:vigilancia_app/views/login/singletonLogin.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/schedule/sort/selectGuardsPage.dart';
import 'file:///C:/Users/Guilherme/Desktop/Programacao/vigilancia_app/lib/controllers/schedule/sortAlgorithm.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/cards/workplaceEdititableCard.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/popup/popup.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';

List<Map<String, dynamic>> _list = List();
int _isAllSelected = 0;
List<int> _idSelected = new List();
List<TempModification> _tempModification = new List();
DateTime _selectedDate = DateTime.now();
int dormanCont = 0;
int guardCount = 0;
int dormanPlacesCont = 0;
int guardPlacesCont = 0;

//FUTURE
var _workplaceQuery = SingletonSchedule().isDaytime
    ? FirebaseFirestore.instance
        .collection("workplaces")
        .where('visible', isEqualTo: true)
        .where('type', isEqualTo: 0)
        .orderBy("name")
        .get()
    : FirebaseFirestore.instance
        .collection("workplaces")
        .where('visible', isEqualTo: true)
        .where('type', isEqualTo: 1)
        .orderBy("name")
        .get();

class SelectWorkplacePage extends StatefulWidget {
  List<int> _selectedIndex = List();

  @override
  _SelectWorkplacePageState createState() => _SelectWorkplacePageState();
}

class _SelectWorkplacePageState extends State<SelectWorkplacePage> {
  bool _isDaytime = SingletonSchedule().isDaytime;

  @override
  void initState() {
    // TODO: implement initState
    widget._selectedIndex = List();
    _isAllSelected = 0;
    _tempModification.clear();
    _idSelected.clear();
    dormanCont = 0;
    guardCount = 0;
    guardPlacesCont = SingletonSchedule().selectedGuards.length;
    dormanPlacesCont = SingletonSchedule().selectedDoormans.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _workplaceQuery = SingletonSchedule().isDaytime
        ? FirebaseFirestore.instance
            .collection("workplaces")
            .where('visible', isEqualTo: true)
            .where('type', isEqualTo: 0)
            .orderBy("name")
            .get()
        : FirebaseFirestore.instance
            .collection("workplaces")
            .where('visible', isEqualTo: true)
            .where('type', isEqualTo: 1)
            .orderBy("name")
            .get();

    return InternalHeader(
      title: "Sortear - " + (_isDaytime ? "Diurna" : "Noturna"),
      rightIcon1: Icons.refresh,
      rightIcon1Function: () {
        setState(() {
          _tempModification.clear();
        });
      },
      leftIconFunction: () {
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      body: SelectWorkplaceSubPage(
        selectedIndex: widget._selectedIndex,
      ),
    );
  }
}

class SelectWorkplaceSubPage extends StatefulWidget {
  List<int> selectedIndex = List();

  String _creatorName = SingletonLogin().loggedUser.id.toString() +
      "- " +
      SingletonLogin().loggedUser.name;

  SelectWorkplaceSubPage({Key key, this.selectedIndex}) : super(key: key);

  @override
  _SelectWorkplaceSubPageState createState() => _SelectWorkplaceSubPageState();
}

class _SelectWorkplaceSubPageState extends State<SelectWorkplaceSubPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _workplaceQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return containerWithErrorMessage(snapshot.error.toString());
        } else if (snapshot.hasData) {
          if (snapshot.data.docs.length == 0) {
            return containerWithNotFoundMessage(
                "Desculpe! Não encontrei nenhum posto de trabalho cadastrado :(");
          } else {
            _list = List();
            int i = 0;
            snapshot.data.docs.forEach((element) {
              _list.add({
                'name': element['name'],
                'guardQt': element['guardQt'],
                'doormanQt': element['doormanQt'],
                'initialGuardQt': element['guardQt'],
                'initialDoormanQt': element['doormanQt'],
                'id': element['id'],
                'type': element['type'],
                'isChecked': _idSelected.contains(element['id']) ? true : false
              });
              i++;
            });
            //map2 = list.asMap();
            //print(map2);
            return ListView.builder(
              itemCount: _list.length,
              itemBuilder: ItemBuilder,
            );
          }
        } else {
          return containerWithErrorMessage("");
        }
      },
    );
  }

  Widget ItemBuilder(BuildContext context, int index) {
    Size _size = MediaQuery.of(context).size;
    if (index == 0) {
      if(_list.length == 1){
        return Column(
          children: [SubPageHeaderBuilder(), WorkplaceCardBuilder(index), subPageFooter(_size)],
        );
      }else{
        return Column(
          children: [SubPageHeaderBuilder(), WorkplaceCardBuilder(index)],
        );
      }

    } else if (index == _list.length - 1) {
      return Column(
        children: [
          WorkplaceCardBuilder(index),
          subPageFooter(_size)
        ],
      );
    } else {
      return Column(
        children: [WorkplaceCardBuilder(index)],
      );
    }
  }

  Widget WorkplaceCardBuilder(int index) {
    _tempModification.forEach((element) {
      if (element.id == _list[index]['id']) {
        _list[index]['guardQt'] = element.guardQt;
        _list[index]['doormanQt'] = element.doormanQt;
      }
    });
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: WorkplaceEditableCard(
        name: _list[index]['name'],
        guardQt: _list[index]['guardQt'],
        doormanQt: _list[index]['doormanQt'],
        initialDoormanQt: _list[index]['initialDoormanQt'],
        isChecked: _list[index]['isChecked'],
        initialGuardQt: _list[index]['initialGuardQt'],
        doormanFunction: (newValue) {
          setState(() {
            _list[index]['doormanQt'] = int.parse(newValue);
            bool achou = false;
            _tempModification.forEach((element) {
              if (element.id == _list[index]['id']) {
                element.doormanQt = int.parse(newValue);
                achou = true;
              }
            });
            if (achou == false) {
              TempModification newMod = TempModification(
                  id: _list[index]['id'],
                  doormanQt: int.parse(newValue),
                  guardQt: _list[index]['initialGuardQt']);
              _tempModification.add(newMod);
            }
            updateCont();
          });
        },
        guardFunction: (newValue) {
          setState(() {
            _list[index]['guardQt'] = int.parse(newValue);
            bool achou = false;
            _tempModification.forEach((element) {
              if (element.id == _list[index]['id']) {
                element.guardQt = int.parse(newValue);
                achou = true;
              }
            });
            if (achou == false) {
              TempModification newMod = TempModification(
                  id: _list[index]['id'],
                  doormanQt: _list[index]['initialDoormanQt'],
                  guardQt: int.parse(newValue));
              _tempModification.add(newMod);
            }
            updateCont();
          });
        },
        checkFunction: (newValue) {
          setState(() {
            _list[index]['isChecked'] = newValue;
            if (newValue == true) {
              bool isAllSelectedLocal = true;
              _list.forEach((element) {
                if (element['isChecked'] == false) {
                  isAllSelectedLocal = false;
                }
              });
              if (isAllSelectedLocal == true) {
                _isAllSelected = 2;
              } else {
                _isAllSelected = 1;
              }
              _idSelected.add(_list[index]['id']);
            } else {
              bool isAllUnselectedLocal = true;
              _list.forEach((element) {
                if (element['isChecked'] == true) {
                  isAllUnselectedLocal = false;
                }
              });
              if (isAllUnselectedLocal == true) {
                _isAllSelected = 0;
              } else {
                _isAllSelected = 1;
              }
              _idSelected.remove(_list[index]['id']);
            }

            ///print(_list);
            ///print(_idSelected);
            updateCont();
          });
        },
      ),
    );
  }

  Widget SubPageHeaderBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(_isAllSelected == 0
                ? Icons.check_box_outline_blank
                : _isAllSelected == 1
                    ? Icons.indeterminate_check_box_outlined
                    : Icons.check_box_outlined),
            onPressed: () {
              setState(() {
                if (_isAllSelected == 2) {
                  _isAllSelected = 0;
                } else {
                  _isAllSelected = 2;
                }
                if (_isAllSelected == 2) {
                  _list.forEach((element) {
                    _idSelected.add(element['id']);
                    element['isChecked'] = true;
                  });
                  updateCont();
                } else {
                  _idSelected.clear();
                  _list.forEach((element) {
                    element['isChecked'] = false;
                  });
                  updateCont();
                }
              });
            }),
        Text(
          "Selecionar Todos",
          style: TextStyle(fontSize: 19),
        )
      ],
    );
  }

  Widget subPageFooter(Size _size){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text(
            "Porteiros - Disp.: ${dormanPlacesCont}/ Alocados: ${dormanCont}",
            style: TextStyle(
                fontSize: 20,
                color: (dormanPlacesCont == dormanCont)
                    ? Colors.green
                    : Colors.red),
          ),
        ),
        Text(
          "Vigilantes - Disp.: ${guardPlacesCont}/ Alocados: ${guardCount}",
          style: TextStyle(
              fontSize: 20,
              color: (guardPlacesCont == guardCount)
                  ? Colors.green
                  : Colors.red),
        ),
        Container(
          width: _size.width,
          child: AppButton(
            externalPadding:
            EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
            labelText: "Sortear",
            onPressedFunction: () {
              //print(_tempModification);
              print(_list);

              updateCont();

              showDialog(
                context: context,
                builder: (context) {
                  return (dormanCont == dormanPlacesCont &&
                      guardPlacesCont == guardCount)
                      ? PopUpSchedule(
                    onButtonPressed: () async {
                      if (await isDateValid(_selectedDate,
                          SingletonSchedule().isDaytime)) {
                        List<Map<String, dynamic>> selectedWorkplaces =
                        new List();
                        _list.forEach((element) {
                          if (element['isChecked'] == true) {
                            selectedWorkplaces.add(element);
                          }
                        });
                        //print(selectedWorkplaces);
                        SingletonSchedule().selectedWorkplaces =
                            selectedWorkplaces;
                        sortGuards(
                            creator: widget._creatorName,
                            date: _selectedDate,
                            context: context,
                            type:
                            SingletonSchedule().isDaytime ? 0 : 1);

                        await Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                                'schedule/schedulePage'));
                        Navigator.pushNamed(
                            context, 'schedule/resultsPage');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PopUpInfo(
                                onOkPressed: () {
                                  Navigator.of(context).pop();
                                },
                                title: "Atenção !",
                                text:
                                "Esta escala já foi sorteada! Verifique o data e o turno e tente novamente.",
                              );
                            });
                      }
                    },
                    onFormTextFieldChange: getItem,
                    formTextFieldValidator: (text) {
                      if (text.isEmpty) return "Campo Vazio";
                    },
                  )
                      : PopUpInfo(
                    onOkPressed: () {
                      Navigator.of(context).pop();
                    },
                    title: "Atenção !",
                    text: (dormanCont != dormanPlacesCont &&
                        guardPlacesCont != guardCount)
                        ? "O Número de Porteiros e Vigilantes disponíveis deve ser igual ao número de Alocados"
                        : ((dormanCont != dormanPlacesCont)
                        ? "O Número de Porteiros disponíveis deve ser igual ao número de Alocados"
                        : (guardPlacesCont != guardCount)
                        ? "O Número de Vigilantes disponíveis deve ser igual ao número de Alocados"
                        : ""),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  void getItem(DateTime date) {
    _selectedDate = date;
    //print(_selectedDate);
  }
}

void updateCont() {
  dormanCont = 0;
  guardCount = 0;

  _list.forEach((element) {
    if (element['isChecked'] == true) {
      dormanCont += element['doormanQt'];
      guardCount += element['guardQt'];
    }
  });
  print("Porteiro: " +
      dormanCont.toString() +
      "Vigilante: " +
      guardCount.toString());
}
