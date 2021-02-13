import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/cards/guardCard.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/titleOrRowBuilder/TitleOrRowBuilder.dart';

class SelectGuardsPage extends StatefulWidget {
  List<Guard> selectedGuards = List();
  @override
  _SelectGuardsPageState createState() => _SelectGuardsPageState();
}

class _SelectGuardsPageState extends State<SelectGuardsPage> {
  bool isDaytime = SingletonSchedule().isDaytime;

  @override
  void initState() {
    // TODO: implement initState
    widget.selectedGuards = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternalHeader(
      title: "Sortear - " + (isDaytime ? "Diurno" : "Noturno"),
      rightIcon1: Icons.refresh,
      rightIcon1Function: () {
        setState(() {});
      },
      leftIconFunction: (){
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      body: SelectGuardsSubPage(
        selectedGuards: widget.selectedGuards,
      ),
    );
  }
}

class SelectGuardsSubPage extends StatefulWidget {
  List<Guard> guardList = List();
  List<Guard> doormanList = List();
  List<Guard> selectedGuards = List();

  SelectGuardsSubPage({Key key, this.selectedGuards}) : super(key: key);

  @override
  _SelectGuardsSubPageState createState() => _SelectGuardsSubPageState();
}

class _SelectGuardsSubPageState extends State<SelectGuardsSubPage> {
  Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    GuardStream = FirebaseFirestore.instance
        .collection("guards")
        .where('visible', isEqualTo: true)
        .orderBy('name')
        .get();
    return FutureBuilder(
      future: GuardStream,
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
          if (snapshot.data.size == 0) {
            return Container(
                alignment: Alignment.center,
                child: Text("Nenhum Porteiro ou Vigilante foi encontrado"));
          } else {
            snapshot.data.docs.forEach((element) {
              if (element['type'] == 0) {
                widget.guardList.add(docToGuard(element));
              } else {
                widget.doormanList.add(docToGuard(element));
              }
            });
            /*
            print("\n\n Porteiros:\n");
            widget.doormanList.forEach((element) {
              print(element.toString());
            });
            print("\n\n Vigilantes:\n");
            widget.guardList.forEach((element) {
              print(element.toString());
            });
             */
            return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: widget.doormanList.length + widget.guardList.length,
              itemBuilder: guardItemBuiler,
            );
          }
        } else {
          return Container(
              alignment: Alignment.center, child: Text("Erro Encontrado :("));
        }
      },
    );
  }

  //ItemBuilder
  Widget guardItemBuiler(BuildContext context, int index) {
    if (widget.doormanList.length != 0 &&
        index <= (widget.doormanList.length - 1)) {
      if (index == 0) {
        if (widget.guardList.length == 0 && widget.doormanList.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget.doormanList.elementAt(index)),
              Container(
                width: size.width,
                child: buttonBuilder(),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget.doormanList.elementAt(index))
            ],
          );
        }
      } else if (widget.guardList.length == 0 &&
          index == (widget.doormanList.length - 1)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget.doormanList.elementAt(index)),
            Container(
              width: size.width,
              child: buttonBuilder(),
            ),
          ],
        );
      } else {
        return guardCardBuilder(widget.doormanList.elementAt(index));
      }
    } else if (widget.guardList.length != 0 &&
        index > (widget.doormanList.length - 1)) {
      if (index == widget.doormanList.length) {
        if (widget.guardList.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget.guardList
                  .elementAt(index - widget.doormanList.length)),
              Container(
                width: size.width,
                child: buttonBuilder(),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(
                  widget.guardList.elementAt(index - widget.doormanList.length))
            ],
          );
        }
      } else if (index ==
          widget.guardList.length + widget.doormanList.length - 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(
                widget.guardList.elementAt(index - widget.doormanList.length)),
            Container(
              width: size.width,
              child: buttonBuilder(),
            )
          ],
        );
      } else {
        return guardCardBuilder(
            widget.guardList.elementAt(index - widget.doormanList.length));
      }
    } else {
      return Text("Erro Encontrado :(");
    }
  }

  Widget guardCardBuilder(Guard guard) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: GuardCard(
            name: guard.name,
            id: guard.id,
            type: guard.type,
            cpf: guard.cpf,
            isChecked: (widget.selectedGuards.contains(guard.id)) ? true : false,
            checkFunction: (int id, bool isChecked, String name, int type, String cpf) {
              Guard guard = new Guard(id: id, name: name, type: type, cpf: cpf);
              if (isChecked) {
                widget.selectedGuards.add(guard);
              } else {
                widget.selectedGuards.removeWhere((element) => element.id == guard.id);
              }
            },
          ),
        ));
  }

  Widget buttonBuilder() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: AppButton(
        labelText: "PROSSEGUIR",
        onPressedFunction: () {
          print(widget.selectedGuards.toString());
          List<Guard> singletonSelectedGuards = new List();
          List<Guard> singletonSelectedDoormans = new List();
          widget.selectedGuards.forEach((element) {
            if(element.type == 1){
              singletonSelectedDoormans.add(element);
            }else{
              singletonSelectedGuards.add(element);
            }
          });
          SingletonSchedule().selectedGuards = singletonSelectedGuards;
          SingletonSchedule().selectedDoormans = singletonSelectedDoormans;
          print("selected doormans..."+ singletonSelectedDoormans.toString());
          Navigator.pushNamed(context, 'schedule/selectWorkplacesPage');
        },
      ),
    );
  }
}

//Future
var GuardStream = FirebaseFirestore.instance
    .collection("guards")
    .where('visible', isEqualTo: true)
    .orderBy('name')
    .get();
