import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/schedule/sort/sortAlgorithm.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';

class SortResultsPage extends StatefulWidget {
  @override
  _SortResultsPageState createState() => _SortResultsPageState();
}

class _SortResultsPageState extends State<SortResultsPage> {
  bool isDaytime = SingletonSchedule().isDaytime;

  @override
  Widget build(BuildContext context) {
    return InternalHeader(
      title: "Resultado",
      rightIcon1: Icons.copy,
      rightIcon1Function: () {
        setState(() {});
      },
      leftIconFunction: () {
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      rightIcon2: Icons.sync,
      rightIcon2Function: (){
        setState(() {
          sortGuards();
        });
      },
      body: SortResultsSubPage(),
    );
  }
}

class SortResultsSubPage extends StatefulWidget {
  @override
  _SortResultsSubPageState createState() => _SortResultsSubPageState();
}

class _SortResultsSubPageState extends State<SortResultsSubPage> {
    @override
  Widget build(BuildContext context) {

    //print(SingletonSchedule().selectedWorkplacesWithGuards);

    return Container(
      child: ListView.builder(
        itemCount: SingletonSchedule().schedule.workPlacesWithGuards.length,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

Widget itemBuilder(BuildContext context, int index) {

  print("nãosei rapaz");
  print(SingletonSchedule().schedule.workPlacesWithGuards);

  Map<dynamic,dynamic> tempMap = new Map();
  tempMap = SingletonSchedule().schedule.workPlacesWithGuards[index.toString()]['guards'];
  List<Guard> guardList = List();
  tempMap.forEach((key, value) {
    Map<dynamic, dynamic> tempMap2 = value;
    Guard newGuard = new Guard();
    tempMap2.forEach((key, value) {
      if(key == 'name'){
        newGuard.name = value;
      }
      if(key == 'type'){
        newGuard.type = value;
      }
      if(key == 'cpf'){
        newGuard.cpf = value;
      }
      if(key == 'id'){
        newGuard.id = value;
      }
    });
    guardList.add(newGuard);
  });

  tempMap = SingletonSchedule().schedule.workPlacesWithGuards[index.toString()]['doormans'];
  List<Guard> doormansList = List();
  tempMap.forEach((key, value) {
    Map<dynamic, dynamic> tempMap2 = value;
    Guard newGuard = new Guard();
    tempMap2.forEach((key, value) {
      if(key == 'name'){
        newGuard.name = value;
      }
      if(key == 'type'){
        newGuard.type = value;
      }
      if(key == 'cpf'){
        newGuard.cpf = value;
      }
      if(key == 'id'){
        newGuard.id = value;
      }
    });
    doormansList.add(newGuard);
  });

  return Column(
    children: [
      TitleBuilder(padding: EdgeInsets.only(top: index == 0 ? 10 : 25, bottom: 5),
          title:
              SingletonSchedule().schedule.workPlacesWithGuards[index.toString()]['name']),
      ...doormansList.map((e) => RowBuilder(subject:"Porteiro: ", text: e.name, padding: EdgeInsets.only(left: 8))).toList(),
      ...guardList.map((e) => RowBuilder(subject:"Vigilante: ", text: e.name, padding: EdgeInsets.only(left: 8))).toList(),
      //Text(SingletonSchedule().selectedWorkplacesWithGuards.toString(), style: TextStyle(fontSize: 19),)
    ],
  );
}
