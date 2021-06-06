import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/cards/workplaceCard.dart';
import 'package:vigilancia_app/views/shared/components/comboBox/comboBox.dart';
import 'package:vigilancia_app/views/shared/components/dateFormat/dateFormat.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';

class ScheduleHistoryPage extends StatefulWidget {
  @override
  _ScheduleHistoryPageState createState() => _ScheduleHistoryPageState();
}

class _ScheduleHistoryPageState extends State<ScheduleHistoryPage> {
  @override
  Widget build(BuildContext context) {
    scheduleStream = FirebaseFirestore.instance
        .collection("schedule")
        .orderBy("id", descending: true)
        .snapshots();

    return InternalHeader(
      title: "Escala Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      rightIcon1Function: () {
        setState(() {});
      },
      body: ScheduleSubPage(),
    );
  }
}

class ScheduleSubPage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  AsyncSnapshot<QuerySnapshot> snapshotGlobal;
  String dateToFilter = "";
  String creatorToFilter = "";
  DateTime _selectedDate;

  @override
  _ScheduleSubPageState createState() => _ScheduleSubPageState();
}

class _ScheduleSubPageState extends State<ScheduleSubPage> {
  @override
  void initState() {
    // TODO: implement initState
    widget.dateToFilter = "";
    widget.creatorToFilter = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 68,
              color: AppColors.lightBlue,
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: size.width / 2,
                      child: Column(
                        children: [
                          Form(
                            key: widget._formKey,
                            child: AppTextFormField(
                              textStyle: TextStyle(fontSize: 16),
                              externalPadding: EdgeInsets.only(left: size.width*0.03, right: size.width*0.03),
                              readOnly: true,
                              labelText: "Data",
                              inputFormatterField: AppMasks.dataMask,
                              initialValue: (widget._selectedDate == null)
                                  ? null
                                  : DateFormat("dd/MM/yy")
                                      .format(widget._selectedDate)
                                      .toString(),
                              keyboardInputType: TextInputType.number,
                              onChangedFunction: (text) {},
                              suffixIcon: (widget.dateToFilter == "")
                                  ? Icons.calendar_today
                                  : Icons.clear,
                              suffixIconColor: (widget.dateToFilter == "")
                                  ? AppColors.mainBlue
                                  : Colors.red,
                              suffixIconOnPressed: () {
                                (widget.dateToFilter == "")
                                    ? _selectDate(context)
                                    : setState(() {
                                        widget.dateToFilter = "";
                                        widget._selectedDate = null;
                                      });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .orderBy("name", descending: false)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        List<String> users = [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            child: CircularProgressIndicator(),
                            alignment: Alignment.center,
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          users.clear();
                          users.add("Todos");
                          snapshot.data.docs.forEach((element) {
                            users.add(element["name"]);
                          });
                          return Container(
                              width: (size.width / 2) - size.width * 0.040,
                              child: Column(children: [
                                ComboBox(
                                  currentObject: (widget.creatorToFilter == "")
                                      ? null
                                      : widget.creatorToFilter,
                                  placeholder: "Criador",
                                  paddingExterno: EdgeInsets.only(top: 10),
                                  objects: users,
                                  onTapFunction: (text) {
                                    setState(() {
                                      widget.creatorToFilter = text;
                                    });
                                  },
                                )
                              ]));
                        } else {
                          return Container(
                            child: CircularProgressIndicator(),
                            alignment: Alignment.center,
                          );
                        }
                      },
                    ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget._selectedDate)
      setState(() {
        widget._selectedDate = picked;
        getItem(widget._selectedDate);
        widget.dateToFilter = DateFormat("dd/MM/yy").format(picked);
      });
  }

  void getItem(DateTime date) {
    widget._selectedDate = date;
  }

  Widget scheduleItemBuilder(BuildContext context, int index) {
    Schedule scheduleToShow =
        docToSchedule(widget.snapshotGlobal.data.docs.elementAt(index));
    //NOTHING TO FILTER, RETURN ALL CARS----------------------------------------------------
    if ((widget.creatorToFilter == "" || widget.creatorToFilter == "Todos") &&
        widget.dateToFilter == "") {
      return buildCard(context, scheduleToShow);
    } else {
      //FILTER BY CREATOR ------------------------------------------------------------------
      if ((widget.creatorToFilter != "" && widget.creatorToFilter != "Todos") &&
          widget.dateToFilter == "") {
        if (scheduleToShow.creatorUser.contains(widget.creatorToFilter)) {
          return buildCard(context, scheduleToShow);
        } else {
          return Container(
            height: 0,
          );
        }
        //FILTER BY DATE --------------------------------------------------------------------
      } else if ((widget.creatorToFilter == "" ||
              widget.creatorToFilter == "Todos") &&
          (widget.dateToFilter != "" && widget.dateToFilter.length == 8)) {
        String scheduleDate =
            DateFormat("dd/MM/yy").format(scheduleToShow.scheduleDateTime);
        if (scheduleDate == widget.dateToFilter) {
          return buildCard(context, scheduleToShow);
        } else {
          return Container(height: 0);
        }
        //FILTER BY CREATOR AND DATE ---------------------------------------------------------
      } else if ((widget.creatorToFilter != "" &&
              widget.creatorToFilter != "Todos") &&
          (widget.dateToFilter != "" && widget.dateToFilter.length == 8)) {
        String scheduleDate =
            DateFormat("dd/MM/yy").format(scheduleToShow.scheduleDateTime);
        if (scheduleDate == widget.dateToFilter &&
            scheduleToShow.creatorUser.contains(widget.creatorToFilter)) {
          return buildCard(context, scheduleToShow);
        } else {
          return Container(height: 0);
        }
      } else {
        return Container(height: 0);
      }
    }
  }

  Widget buildCard(BuildContext context, Schedule scheduleToShow) {
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
    .snapshots();
