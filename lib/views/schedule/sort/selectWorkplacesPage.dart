import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/cards/workplaceEdititableCard.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';

Size size;
Map<dynamic, dynamic> map2 = new Map();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return InternalHeader(
      title: "Sortear - " + (isDaytime ? "Diurno" : "Noturno"),
      rightIcon1: Icons.refresh,
      rightIcon1Function: () {
        setState(() {});
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
          return Container(
              alignment: Alignment.center,
              child: Text("Erro Encontrado :( \n" + snapshot.error.toString()));
        } else if (snapshot.hasData) {

          List<Map<dynamic, dynamic>> list = List();
          snapshot.data.docs.forEach((element) {
            list.add({
              'name': element['name'],
              'guardQt': element['guardQt'],
              'doormanQt': element['doormanQt'],
              'id': element['id'],
              'type': element['type'],
              'isChecked': false
            });
          });
          map2 = list.asMap();
          print(map2);
          return ListView.builder(
            itemCount: map2.length,
            itemBuilder: ItemBuilder,
          );
        } else {
          return Container(
              alignment: Alignment.center, child: Text("Erro Encontrado :("));
        }
      },
    );
  }

  Widget ItemBuilder(BuildContext context, int index) {
    if (index == map2.length - 1) {
      return Column(
        children: [
          WorkplaceCardBuilder(index),
          Container(
            width: size.width,
            child: AppButton(
              labelText: "SORTEAR",
              onPressedFunction: () {
                print(map2);
                SingletonSchedule().workplacesMap = map2;
                Navigator.pushNamed(context, 'schedule/resultsPage');
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
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: WorkplaceEditableCard(
        name: map2[index]['name'],
        guardQt: map2[index]['guardQt'],
        doormanQt: map2[index]['doormanQt'],
        isChecked: map2[index]['isChecked'],
        doormanFunction: (newValue) {
          map2[index]['doormanQt'] = int.parse(newValue);
        },
        guardFunction: (newValue) {
          map2[index]['guardQt'] = int.parse(newValue);
        },
        checkFunction: (newValue) {
          map2[index]['isChecked'] = newValue;
        },
      ),
    );
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
