import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/controllers/schedule/scheduleDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/schedule/sort/sortAlgorithm.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class SortResultsPage extends StatefulWidget {
  Schedule _scheduleToShow;

  @override
  _SortResultsPageState createState() => _SortResultsPageState();
}

class _SortResultsPageState extends State<SortResultsPage> {
  bool isDaytime = SingletonSchedule().isDaytime;
  @override
  Widget build(BuildContext context) {
    widget._scheduleToShow = SingletonSchedule().schedule;

    return InternalHeader(
      title: "Resultado",
      leftIconFunction: () {
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      body: SortResultsSubPage(
        scheduleToShow: widget._scheduleToShow,
      ),
    );
  }
}

class SortResultsSubPage extends StatefulWidget {
  Schedule scheduleToShow;
  String note = "";
  SortResultsSubPage({Key key, this.scheduleToShow}) : super(key: key);

  @override
  _SortResultsSubPageState createState() => _SortResultsSubPageState();
}

class _SortResultsSubPageState extends State<SortResultsSubPage> {
  Size get size => MediaQuery.of(context).size;

  @override
  void initState() {
    // TODO: implement initState
    widget.note = widget.scheduleToShow.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(SingletonSchedule().selectedWorkplacesWithGuards);

    return Container(
      child: ListView.builder(
        itemCount: widget.scheduleToShow.workPlacesWithGuards.length,
        itemBuilder: itemBuilder,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map<dynamic, dynamic> tempMap = new Map();
    tempMap =
        widget.scheduleToShow.workPlacesWithGuards[index.toString()]['guards'];
    List<Guard> guardList = List();
    tempMap.forEach((key, value) {
      Map<dynamic, dynamic> tempMap2 = value;
      Guard newGuard = new Guard();
      tempMap2.forEach((key, value) {
        if (key == 'name') {
          newGuard.name = value;
        }
        if (key == 'type') {
          newGuard.type = value;
        }
        if (key == 'cpf') {
          newGuard.cpf = value;
        }
        if (key == 'id') {
          newGuard.id = value;
        }
      });
      guardList.add(newGuard);
    });

    tempMap = widget.scheduleToShow.workPlacesWithGuards[index.toString()]
        ['doormans'];
    List<Guard> doormansList = List();
    tempMap.forEach((key, value) {
      Map<dynamic, dynamic> tempMap2 = value;
      Guard newGuard = new Guard();
      tempMap2.forEach((key, value) {
        if (key == 'name') {
          newGuard.name = value;
        }
        if (key == 'type') {
          newGuard.type = value;
        }
        if (key == 'cpf') {
          newGuard.cpf = value;
        }
        if (key == 'id') {
          newGuard.id = value;
        }
      });
      doormansList.add(newGuard);
    });

    return Column(
      children: [
        index == 0
            ? scheduleHeader(schedule: widget.scheduleToShow)
            : Container(
                height: 0,
              ),
        TitleBuilder(
            padding: EdgeInsets.only(top: 25, bottom: 5),
            title: widget.scheduleToShow.workPlacesWithGuards[index.toString()]
                ['name']),
        ...doormansList
            .map((e) => RowBuilder(
                subject: "Porteiro: ",
                text: e.name,
                padding: EdgeInsets.only(left: 8)))
            .toList(),
        ...guardList
            .map((e) => RowBuilder(
                subject: "Vigilante: ",
                text: e.name,
                padding: EdgeInsets.only(left: 8)))
            .toList(),
        index == widget.scheduleToShow.workPlacesWithGuards.length - 1
            ? scheduleNote(schedule: widget.scheduleToShow)
            : Container(
                height: 0,
              ),
      ],
    );
  }

  Widget scheduleNote({Key key, Schedule schedule}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25, left: 8, right: 8),
          child: AppTextFormField(
            labelText: "Observações: ",
            minLines: 3,
            maxLines: 3,
            onChangedFunction: (text) {
              widget.note = text;
            },
            initialValue: widget.note,
          ),
        ),
        Container(padding: EdgeInsets.only(bottom: 20),
          width: size.width,
          child: AppButton(
            backgroundColor: Colors.black,
            labelText: "Atualizar Observações",
            onPressedFunction: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              await updateNoteSchedule(context: context, note: widget.note, id: schedule.id);
            },
          ),
        ),
        Container(padding: EdgeInsets.only(bottom: 30),
          width: size.width,
          child: AppButton(

            labelText: "Compartilhar Escala",
            onPressedFunction: () async {

            },
          ),
        )
      ],
    );
  }
}

Widget scheduleHeader({Key key, Schedule schedule}) {
  return Column(
    children: [
      TitleBuilder(
          title: "Informações da Escala",
          padding: EdgeInsets.only(top: 10, bottom: 5)),
      RowBuilderx2(
        flex1: 50,
        flex2: 50,
        padding: EdgeInsets.only(left: 8),
        subject1: "Turno: ",
        text1: schedule.type == 0
            ? "Diurno"
            : (schedule.type == 1 ? "Noturno" : "Erro"),
        subject2: "Data: ",
        text2:
            DateFormat("dd/MM/yy").format(schedule.scheduleDateTime).toString(),
      ),
      RowBuilder(
          subject: "Criador: ",
          text: schedule.creatorUser,
          padding: EdgeInsets.only(left: 8))
    ],
  );
}
