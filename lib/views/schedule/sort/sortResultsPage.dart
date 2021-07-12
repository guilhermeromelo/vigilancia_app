import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vigilancia_app/controllers/schedule/scheduleDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

String note;

class SortResultsPage extends StatefulWidget {
  Schedule _scheduleToShow;
  bool isButtonVisible = true;

  @override
  _SortResultsPageState createState() => _SortResultsPageState();
}

class _SortResultsPageState extends State<SortResultsPage> {
  ScreenshotController screenshotController = ScreenshotController();
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
      rightIcon1Function: () {
        setState(() {
          widget.isButtonVisible = false;
        });
        _takeScreenshotandShare();
      },
      rightIcon1: Icons.share,
      body: SortResultsSubPage(
        scheduleToShow: widget._scheduleToShow,
        screenshotController: screenshotController,
        isButtonVisible: widget.isButtonVisible,
      ),
    );
  }

  _takeScreenshotandShare() async {
    Uint8List _imageFile;
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((Uint8List image) async {
      _imageFile = image;
      setState(() {
        _imageFile = image;
        widget.isButtonVisible = true;
      });
      await Share.file('Anupam', 'screenshot.png', _imageFile, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }
}

class SortResultsSubPage extends StatefulWidget {
  Schedule scheduleToShow;
  bool isButtonVisible;
  ScreenshotController screenshotController;

  SortResultsSubPage(
      {Key key,
      this.scheduleToShow,
      this.screenshotController,
      this.isButtonVisible})
      : super(key: key);

  @override
  _SortResultsSubPageState createState() => _SortResultsSubPageState();
}

class _SortResultsSubPageState extends State<SortResultsSubPage> {
  Size get size => MediaQuery.of(context).size;
  File _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    note = widget.scheduleToShow.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(SingletonSchedule().selectedWorkplacesWithGuards);
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Screenshot(
          child: Container(
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.scheduleToShow.workPlacesWithGuards.length,
              itemBuilder: itemBuilder,
            ),
            color: Colors.white,
          ),
          controller: widget.screenshotController,
        ),
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
        if (key == 'matricula') {
          newGuard.matricula = value;
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
        if (key == 'matricula') {
          newGuard.matricula = value;
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
          fontWeight: FontWeight.bold,
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
            textCapitalization: TextCapitalization.sentences,
            labelText: "Observações: ",
            minLines: 3,
            maxLines: 3,
            onChangedFunction: (text) {
              note = text;
            },
            initialValue: note,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 20),
          width: size.width,
          child: Visibility(
            visible: widget.isButtonVisible,
            child: AppButton(
              externalPadding: EdgeInsets.only(left: 15, right: 15, top: 15),
              backgroundColor: Colors.black,
              labelText: "Atualizar Observações",
              onPressedFunction: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                await updateNoteSchedule(
                    context: context, note: note, id: schedule.id);
              },
            ),
          ),
        ),
        Visibility(
          visible: !widget.isButtonVisible,
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 15),
            child: Image.asset(
              "assets/logo_nome_azul.png",
              width: 120,
            ),
          ),
        ),
      ],
    );
  }

  Widget scheduleHeader({Key key, Schedule schedule}) {
    return Column(
      children: [
        TitleBuilder(
            fontWeight: FontWeight.bold,
            title: "Informações da Escala",
            padding: EdgeInsets.only(top: 10, bottom: 5)),
        RowBuilderx2(
          flex1: 50,
          flex2: 50,
          padding: EdgeInsets.only(left: 8),
          subject2: "Turno: ",
          text2: schedule.type == 0
              ? "Diurno"
              : (schedule.type == 1 ? "Noturno" : "Erro"),
          subject1: "Data: ",
          text1: DateFormat("dd/MM/yy")
              .format(schedule.scheduleDateTime)
              .toString(),
        ),
        RowBuilder(
            subject: "Criador: ",
            text: schedule.creatorUser,
            padding: EdgeInsets.only(left: 8))
      ],
    );
  }
}
