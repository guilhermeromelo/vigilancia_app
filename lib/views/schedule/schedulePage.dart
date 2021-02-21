import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/cards/workplaceCard.dart';
import 'package:vigilancia_app/views/shared/components/dateFormat/dateFormat.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    scheduleStream =
        FirebaseFirestore.instance.collection("schedule").orderBy("id", descending: true).limit(30).snapshots();

    return InternalHeader(
      title: "Escala Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {},
      rightIcon2: Icons.wb_sunny,
      rightIcon2Function: () {
        SingletonSchedule().isDaytime = true;
        Navigator.pushNamed(context, 'schedule/selectGuardsPage');
      },
      rightIcon1: Icons.nightlight_round,
      rightIcon1Function: () {
        SingletonSchedule().isDaytime = false;
        Navigator.pushNamed(context, 'schedule/selectGuardsPage');
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
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 78,
              color: AppColors.lightBlue,
            ),
            AppTextFormField(
              labelText: "Pesquisar",
              externalPadding: EdgeInsets.only(top: 15, left: 10, right: 10),
              validatorFunction: (text) {
                if (text.isEmpty) return "Campo Vazio";
              },
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
    Schedule scheduleToShow = docToSchedule(widget.snapshotGlobal.data.docs.elementAt(index));
    return Column(children: [
      Padding(padding: EdgeInsets.only(bottom: 12),child: WorkplaceAndScheduleCard(
        title: DateFormat("dd/MM/yy")
            .format(scheduleToShow.scheduleDateTime)
            .toString() + " - " +dayOfWeekIntToString(scheduleToShow.scheduleDateTime.weekday),
        line1: scheduleToShow.type == 0 ? "Diurno" : "Noturno",
        line2: scheduleToShow.workPlacesWithGuards.length.toString() + (scheduleToShow.workPlacesWithGuards.length == 1 ? " Posto de Trabalho" : " Postos de Trabalho"),
        line3: scheduleToShow.creatorUser,
        icon2: Icons.wb_shade,
        icon3: Icons.person,
      ),)
    ],);
  }
}

var scheduleStream =
    FirebaseFirestore.instance.collection("schedule").orderBy("id", descending: true).limit(30).snapshots();
