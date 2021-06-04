import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/cards/workplaceCard.dart';
import 'package:vigilancia_app/views/shared/components/dateFormat/dateFormat.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';

class ScheduleListPage extends StatefulWidget {
  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  @override
  Widget build(BuildContext context) {
    scheduleStream = FirebaseFirestore.instance
        .collection("schedule")
        .orderBy("id", descending: true)
        .limit(30)
        .snapshots();

    return InternalHeader(
      title: "Escala Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      body: ScheduleSubPage(),
    );
  }
}

class ScheduleSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  AsyncSnapshot<QuerySnapshot> snapshotGlobal;

  @override
  _ScheduleSubPageState createState() => _ScheduleSubPageState();
}

class _ScheduleSubPageState extends State<ScheduleSubPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 155,
              color: AppColors.lightBlue,
            ),
            Column(
              children: [
                AppTextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  labelText: "Pesquisar",
                  externalPadding:
                      EdgeInsets.only(top: 15, left: 10, right: 10),
                  validatorFunction: (text) {
                    if (text.isEmpty) return "Campo Vazio";
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "Sortear Escala:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: AppButton(
                        externalPadding: EdgeInsets.only(right: 5),
                        backgroundColor: AppColors.secondBlue,
                        labelText: "Diurna",
                        onPressedFunction: () {
                          SingletonSchedule().isDaytime = true;
                          Navigator.pushNamed(context, 'schedule/selectGuardsPage');
                        },
                      ),
                      width: (size.width * 0.70) / 2,
                    ),
                    Container(
                      child: AppButton(
                        externalPadding: EdgeInsets.only(left: 5),
                        backgroundColor: AppColors.green,
                        labelText: "Noturna",
                        onPressedFunction: () {
                          SingletonSchedule().isDaytime = false;
                          Navigator.pushNamed(context, 'schedule/selectGuardsPage');
                        },
                      ),
                      width: (size.width * 0.70) / 2,
                    )
                  ],
                )
              ],
            )
          ],
        ),
        Expanded(
            child: StreamBuilder(
          stream: scheduleStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return containerWithCircularProgress();
            } else if (snapshot.hasError) {
              return containerWithErrorMessage(snapshot.error.toString());
            } else if (snapshot.hasData) {
              if (snapshot.data.docs.length == 0) {
                return containerWithNotFoundMessage(
                    "Desculpe! Não encontrei nenhuma escala de trabalho cadastrada :(");
              } else {
                widget.snapshotGlobal = snapshot;
                return ListView.builder(
                  padding: EdgeInsets.only(top: 20),
                  itemBuilder: scheduleItemBuilder,
                  itemCount: widget.snapshotGlobal.data.docs.length,
                );
              }
            } else {
              return containerWithErrorMessage("");
            }
          },
        ))
      ],
    );
  }

  Widget scheduleItemBuilder(BuildContext context, int index) {
    Schedule scheduleToShow =
        docToSchedule(widget.snapshotGlobal.data.docs.elementAt(index));
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: WorkplaceAndScheduleCard(
            onTapFunction: () {
              SingletonSchedule().schedule = scheduleToShow;
              Navigator.pushNamed(context, 'schedule/resultsPage');
            },
            title: DateFormat("dd/MM/yy")
                    .format(scheduleToShow.scheduleDateTime)
                    .toString() +
                " - " +
                dayOfWeekIntToString(scheduleToShow.scheduleDateTime.weekday),
            line1: scheduleToShow.type == 0 ? "Diurno" : "Noturno",
            line2: scheduleToShow.workPlacesWithGuards.length.toString() +
                (scheduleToShow.workPlacesWithGuards.length == 1
                    ? " Posto de Trabalho"
                    : " Postos de Trabalho"),
            line3: scheduleToShow.creatorUser,
            icon2: Icons.wb_shade,
            icon3: Icons.person,
          ),
        )
      ],
    );
  }
}

var scheduleStream = FirebaseFirestore.instance
    .collection("schedule")
    .orderBy("id", descending: true)
    .limit(30)
    .snapshots();
