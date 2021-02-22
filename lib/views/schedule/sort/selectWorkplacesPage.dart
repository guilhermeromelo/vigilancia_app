import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/schedule/sort/selectGuardsPage.dart';
import 'package:vigilancia_app/views/schedule/sort/sortAlgorithm.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _workplaceQuery = SingletonSchedule().isDaytime
        ? FirebaseFirestore.instance
            .collection("workplaces")
            .where('visible', isEqualTo: true)
            .where('type', isEqualTo: 0)
            .get()
        : FirebaseFirestore.instance
            .collection("workplaces")
            .where('visible', isEqualTo: true)
            .where('type', isEqualTo: 1)
            .get();

    return InternalHeader(
      title: "Sortear - " + (_isDaytime ? "Diurno" : "Noturno"),
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

  String _creatorName = "1- Mudar Nome Usuário";

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
      return Column(
        children: [
          Row(
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
                        });
                      } else {
                        _idSelected.clear();
                      }
                    });
                  }),
              Text(
                "Selecionar Todos",
                style: TextStyle(fontSize: 19),
              )
            ],
          ),
          WorkplaceCardBuilder(index)
        ],
      );
    } else if (index == _list.length - 1) {
      return Column(
        children: [
          WorkplaceCardBuilder(index),
          Container(
            width: _size.width,
            child: AppButton(
              labelText: "Sortear",
              onPressedFunction: () {
                //print(list);

                showDialog(
                  context: context,
                  builder: (context) {
                    return PopUpSchedule(
                      onButtonPressed: () async {
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
                            type: SingletonSchedule().isDaytime ? 0 : 1);

                        await Navigator.popUntil(context,
                            ModalRoute.withName('schedule/schedulePage'));
                        Navigator.pushNamed(context, 'schedule/resultsPage');
                      },
                      onFormTextFieldChange: getItem,
                      formTextFieldValidator: (text) {
                        if (text.isEmpty) return "Campo Vazio";
                      },
                    );
                  },
                );
              },
            ),
          )
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
        },
        guardFunction: (newValue) {
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
            print(_list);
            print(_idSelected);
          });
        },
      ),
    );
  }

  void getItem(DateTime date) {
    _selectedDate = date;
    print(_selectedDate);
  }
}

//FUTURE
var _workplaceQuery = SingletonSchedule().isDaytime
    ? FirebaseFirestore.instance
        .collection("workplaces")
        .where('visible', isEqualTo: true)
        .where('type', isEqualTo: 0)
        .get()
    : FirebaseFirestore.instance
        .collection("workplaces")
        .where('visible', isEqualTo: true)
        .where('type', isEqualTo: 1)
        .get();
