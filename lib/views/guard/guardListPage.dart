import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/cards/guardCard.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeaderWithTabBarx5.dart';
import 'package:vigilancia_app/views/shared/components/titleOrRowBuilder/TitleOrRowBuilder.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';

List<Guard> _guardList = List();
List<Guard> _doormanList = List();

class GuardListPage extends StatefulWidget {
  @override
  _GuardListPageState createState() => _GuardListPageState();
}

class _GuardListPageState extends State<GuardListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _GuardFuture = FirebaseFirestore.instance
        .collection("guards")
        .where('visible', isEqualTo: true)
        .orderBy('name')
        .get();
    return FutureBuilder(
      future: _GuardFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return guardListPageHeader(
              widget1: containerWithCircularProgress(),
              widget2: containerWithCircularProgress(),
              widget3: containerWithCircularProgress(),
              widget4: containerWithCircularProgress(),
              widget5: containerWithCircularProgress());
        } else if (snapshot.hasError) {
          return guardListPageHeader(
              widget1: containerWithErrorMessage(snapshot.error.toString()),
              widget2: containerWithErrorMessage(snapshot.error.toString()),
              widget3: containerWithErrorMessage(snapshot.error.toString()),
              widget4: containerWithErrorMessage(snapshot.error.toString()),
              widget5: containerWithErrorMessage(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          _doormanList.clear();
          _guardList.clear();
          snapshot.data.docs.forEach((element) {
            if (element['type'] == 0) {
              _guardList.add(docToGuard(element));
            } else {
              _doormanList.add(docToGuard(element));
            }
          });
          return guardListPageHeader(
            widget1: SelectGuardsSubPage(
              tabBarIndex: 0,
            ),
            widget2: SelectGuardsSubPage(
              tabBarIndex: 1,
            ),
            widget3: SelectGuardsSubPage(
              tabBarIndex: 2,
            ),
            widget4: SelectGuardsSubPage(
              tabBarIndex: 3,
            ),
            widget5: SelectGuardsSubPage(
              tabBarIndex: 4,
            ),
          );
        } else {
          return guardListPageHeader(
              widget1: containerWithErrorMessage(""),
              widget2: containerWithErrorMessage(""),
              widget3: containerWithErrorMessage(""),
              widget4: containerWithErrorMessage(""),
              widget5: containerWithErrorMessage(""));
        }
      },
    );
  }

  Widget guardListPageHeader(
      {Key key,
      Widget widget1,
      Widget widget2,
      Widget widget3,
      Widget widget4,
      Widget widget5}) {
    return InternalHeaderWithTabBarx5(
      title: "Colaboradores",
      rightIcon1: Icons.refresh,
      rightIcon1Function: () {
        setState(() {});
      },
      rightIcon2: Icons.add,
      rightIcon2Function: () {
        Navigator.pushNamed(context, 'guard/registration');
      },
      leftIconFunction: () {
        Navigator.of(context).pop();
      },
      leftIcon: Icons.arrow_back_ios,
      text1: "A-D",
      text2: "A",
      text3: "B",
      text4: "C",
      text5: "D",
      widget1: widget1,
      widget2: widget2,
      widget3: widget3,
      widget4: widget4,
      widget5: widget5,
    );
  }
}

class SelectGuardsSubPage extends StatefulWidget {
  List<Guard> _doormanListLocal = List();
  List<Guard> _guardListLocal = List();

  int tabBarIndex;

  SelectGuardsSubPage({
    Key key,
    this.tabBarIndex,
  }) : super(key: key);

  @override
  _SelectGuardsSubPageState createState() => _SelectGuardsSubPageState();
}

class _SelectGuardsSubPageState extends State<SelectGuardsSubPage> {
  String _team;

  @override
  Widget build(BuildContext context) {
    switch (widget.tabBarIndex) {
      case 0:
        {
          _team = "";
          break;
        }
      case 1:
        {
          _team = "A";
          break;
        }
      case 2:
        {
          _team = "B";
          break;
        }
      case 3:
        {
          _team = "C";
          break;
        }
      case 4:
        {
          _team = "D";
          break;
        }
    }

    widget._doormanListLocal.clear();
    widget._guardListLocal.clear();
    if (_team.isEmpty) {
      widget._doormanListLocal.addAll(_doormanList);
      widget._guardListLocal.addAll(_guardList);
    } else {
      _doormanList.forEach((element) {
        if (element.team == _team) {
          widget._doormanListLocal.add(element);
        }
      });
      _guardList.forEach((element) {
        if (element.team == _team) {
          widget._guardListLocal.add(element);
        }
      });
    }

    if (widget._doormanListLocal.length + widget._guardListLocal.length == 0) {
      return containerWithNotFoundMessage(
          "Desculpe! Não encontrei ninguém cadastrado neste time :(");
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount:
            widget._doormanListLocal.length + widget._guardListLocal.length,
        itemBuilder: guardItemBuiler,
      );
    }
  }

  //ItemBuilder
  Widget guardItemBuiler(BuildContext context, int index) {
    if (widget._doormanListLocal.length != 0 &&
        index <= (widget._doormanListLocal.length - 1)) {
      if (index == 0) {
        if (widget._guardListLocal.length == 0 &&
            widget._doormanListLocal.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget._doormanListLocal.elementAt(index)),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "PORTEIROS", padding: EdgeInsets.only(bottom: 5)),
              guardCardBuilder(widget._doormanListLocal.elementAt(index))
            ],
          );
        }
      } else if (widget._guardListLocal.length == 0 &&
          index == (widget._doormanListLocal.length - 1)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget._doormanListLocal.elementAt(index)),
          ],
        );
      } else {
        return guardCardBuilder(widget._doormanListLocal.elementAt(index));
      }
    } else if (widget._guardListLocal.length != 0 &&
        index > (widget._doormanListLocal.length - 1)) {
      if (index == widget._doormanListLocal.length) {
        if (widget._guardListLocal.length == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget._guardListLocal
                  .elementAt(index - widget._doormanListLocal.length)),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBuilder(
                  title: "VIGILANTES",
                  padding: EdgeInsets.only(bottom: 5, top: 20)),
              guardCardBuilder(widget._guardListLocal
                  .elementAt(index - widget._doormanListLocal.length))
            ],
          );
        }
      } else if (index ==
          widget._guardListLocal.length + widget._doormanListLocal.length - 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            guardCardBuilder(widget._guardListLocal
                .elementAt(index - widget._doormanListLocal.length)),
          ],
        );
      } else {
        return guardCardBuilder(widget._guardListLocal
            .elementAt(index - widget._doormanListLocal.length));
      }
    } else {
      return containerWithErrorMessage("");
    }
  }

  Widget guardCardBuilder(Guard guard) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: GuardCard(
            onCardTap: () {
              print("tela de info guard: " + guard.id.toString());
            },
            name: guard.name,
            id: guard.id,
            type: guard.type,
            cpf: guard.cpf,
            hasCkeckBox: false,
          ),
        ));
  }
}

//Future
var _GuardFuture = FirebaseFirestore.instance
    .collection("guards")
    .where('visible', isEqualTo: true)
    .orderBy('name')
    .get();
