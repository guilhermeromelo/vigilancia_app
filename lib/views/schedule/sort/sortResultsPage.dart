import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';

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
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(SingletonSchedule().selectedWorkplaces.toString()),
          )
        ],
      ),
    );
  }
}
