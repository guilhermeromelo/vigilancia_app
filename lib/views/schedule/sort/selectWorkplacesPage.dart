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
import 'package:vigilancia_app/views/workplaces/workplaceRegistration.dart';

Size size;
List<Map<String, dynamic>> list = List();
int isAllSelected = 0;
List<int> idSelected = new List();
List<TempModification> tempModification = new List();
DateTime selectedDate = DateTime.now();

class SelectWorkplacePage extends StatefulWidget {
  List<int> selectedIndex = List();
  @override
  _SelectWorkplacePageState createState() => _SelectWorkplacePageState();
}

class _SelectWorkplacePageState extends State<SelectWorkplacePage> {
  bool isDaytime = SingletonSchedule().isDaytime;

  @override
  void initState() {
    // TODO: implement initState
    widget.selectedIndex = List();
    isAllSelected = 0;
    tempModification.clear();
    idSelected.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    workplaceQuery = SingletonSchedule().isDaytime
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
      title: "Sortear - " + (isDaytime ? "Diurno" : "Noturno"),
      rightIcon1: Icons.refresh,
      rightIcon1Function: () {
        setState(() {
          tempModification.clear();
        });
      },
      leftIconFunction: () {
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      body: SelectWorkplaceSubPage(
        selectedIndex: widget.selectedIndex,
      ),
    );
  }
}

class SelectWorkplaceSubPage extends StatefulWidget {
  List<int> selectedIndex = List();

  String creatorName = "1- Mudar Nome Usuário";

  bool isChecked = false;
  int doormanQt = 1;
  int guardQt = 1;

  SelectWorkplaceSubPage({Key key, this.selectedIndex}) : super(key: key);

  @override
  _SelectWorkplaceSubPageState createState() => _SelectWorkplaceSubPageState();
}

class _SelectWorkplaceSubPageState extends State<SelectWorkplaceSubPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: workplaceQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return ContainerWithErrorMessage(snapshot.error.toString());
        } else if (snapshot.hasData) {
          list = List();
          int i=0;
          snapshot.data.docs.forEach((element) {
            list.add({
              'name': element['name'],
              'guardQt': element['guardQt'],
              'doormanQt': element['doormanQt'],
              'initialGuardQt': element['guardQt'],
              'initialDoormanQt': element['doormanQt'],
              'id': element['id'],
              'type': element['type'],
              'isChecked': idSelected.contains(element['id']) ? true : false
            });
            i++;
          });
          //map2 = list.asMap();
          //print(map2);
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: ItemBuilder,
          );
        } else {
          return ContainerWithErrorMessage("");
        }
      },
    );
  }

  Widget ItemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(isAllSelected == 0
                      ? Icons.check_box_outline_blank
                      : isAllSelected == 1
                          ? Icons.indeterminate_check_box_outlined
                          : Icons.check_box_outlined),
                  onPressed: () {
                    setState(() {
                      if (isAllSelected == 2) {
                        isAllSelected = 0;
                      } else {
                        isAllSelected = 2;
                      }
                      if (isAllSelected == 2) {
                        list.forEach((element) {
                          idSelected.add(element['id']);
                        });
                      } else {
                        idSelected.clear();
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
    } else if (index == list.length - 1) {
      return Column(
        children: [
          WorkplaceCardBuilder(index),
          Container(
            width: size.width,
            child: AppButton(
              labelText: "Sortear",
              onPressedFunction: () {
                //print(list);

                showDialog(
                  context: context,
                  builder: (context){
                    return PopUpSchedule(
                      onButtonPressed: () async {
                        List<Map<String, dynamic>> selectedWorkplaces = new List();
                        list.forEach((element) {
                          if (element['isChecked'] == true) {
                            selectedWorkplaces.add(element);
                          }
                        });
                        print(selectedWorkplaces);
                        SingletonSchedule().selectedWorkplaces = selectedWorkplaces;
                        sortGuards(creator: widget.creatorName, date: selectedDate, context: context, type: SingletonSchedule().isDaytime ? 0 : 1);

                        await Navigator.popUntil(context,
                            ModalRoute.withName('schedule/schedulePage'));
                        Navigator.pushNamed(context, 'schedule/resultsPage');
                      },
                      onFormTextFieldChange: getItem,
                      formTextFieldValidator: (text){
                        if(text.isEmpty) return "Campo Vazio";
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
    tempModification.forEach((element) {
      if(element.id == list[index]['id']){
        list[index]['guardQt'] = element.guardQt;
        list[index]['doormanQt'] = element.doormanQt;
      }
    });

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: WorkplaceEditableCard(
        name: list[index]['name'],
        guardQt: list[index]['guardQt'],
        doormanQt: list[index]['doormanQt'],
        initialDoormanQt:  list[index]['initialDoormanQt'],
        isChecked: list[index]['isChecked'],
        initialGuardQt: list[index]['initialGuardQt'],

        doormanFunction: (newValue) {
          list[index]['doormanQt'] = int.parse(newValue);
          bool achou = false;
          tempModification.forEach((element) {
            if(element.id == list[index]['id']){
              element.doormanQt = int.parse(newValue);
              achou = true;
            }
          });
          if(achou == false){
            TempModification newMod = TempModification(id: list[index]['id'],doormanQt: int.parse(newValue), guardQt: list[index]['initialGuardQt'] );
            tempModification.add(newMod);
          }
        },
        guardFunction: (newValue) {
          list[index]['guardQt'] = int.parse(newValue);
          bool achou = false;
          tempModification.forEach((element) {
            if(element.id == list[index]['id']){
              element.guardQt = int.parse(newValue);
              achou = true;
            }
          });
          if(achou == false){
            TempModification newMod = TempModification(id: list[index]['id'],doormanQt: list[index]['initialDoormanQt'], guardQt: int.parse(newValue));
            tempModification.add(newMod);
          }
        },
        checkFunction: (newValue) {
          setState(() {
            list[index]['isChecked'] = newValue;
            if (newValue == true) {
              bool isAllSelectedLocal = true;
              list.forEach((element) {
                if (element['isChecked'] == false) {
                  isAllSelectedLocal = false;
                }
              });
              if (isAllSelectedLocal == true) {
                isAllSelected = 2;
              } else {
                isAllSelected = 1;
              }
              idSelected.add(list[index]['id']);
            } else {
              bool isAllUnselectedLocal = true;
              list.forEach((element) {
                if (element['isChecked'] == true) {
                  isAllUnselectedLocal = false;
                }
              });
              if (isAllUnselectedLocal == true) {
                isAllSelected = 0;
              } else {
                isAllSelected = 1;
              }
              idSelected.remove(list[index]['id']);
            }
            print(list);
            print(idSelected);
          });
        },
      ),
    );
  }
  
  void getItem(DateTime date){
    selectedDate = date;
    print(selectedDate);
  }
}

//FUTURE
var workplaceQuery = SingletonSchedule().isDaytime
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

