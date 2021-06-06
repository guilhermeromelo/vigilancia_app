import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';
import 'package:vigilancia_app/views/shared/components/cards/workplaceCard.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';
import 'package:vigilancia_app/views/shared/components/widgetStreamOrFutureBuilder/widgetStreamOrFutureBuilder.dart';
import 'package:vigilancia_app/views/workplace/singletonWorkplace.dart';

var _workplaceFuture =
    FirebaseFirestore.instance.collection("workplaces").where("visible", isEqualTo: true).orderBy("name").get();

class WorkplaceListPage extends StatefulWidget {
  @override
  _WorkplaceListPageState createState() => _WorkplaceListPageState();
}

class _WorkplaceListPageState extends State<WorkplaceListPage> {
  @override
  Widget build(BuildContext context) {
    _workplaceFuture =
        FirebaseFirestore.instance.collection("workplaces").where("visible", isEqualTo: true).orderBy("name").get();
    return FutureBuilder(
      future: _workplaceFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return workplaceListHeader(
              widget1: containerWithCircularProgress(),
              widget2: containerWithCircularProgress());
        } else if (snapshot.hasError) {
          return workplaceListHeader(
              widget1: containerWithErrorMessage(snapshot.error.toString()),
              widget2: containerWithErrorMessage(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          return workplaceListHeader(
              widget1: WorkplaceListSubPage(
                index: 0,
                snapshot: snapshot,
              ),
              widget2: WorkplaceListSubPage(
                index: 1,
                snapshot: snapshot,
              ));
        } else {
          return workplaceListHeader(
              widget1: containerWithErrorMessage(""),
              widget2: containerWithErrorMessage(""));
        }
      },
    );
  }

  Widget workplaceListHeader({Key key, Widget widget1, Widget widget2}) {
    return InternalHeaderWithTabBar(
      initialIndex: SingletonWorkplace().currentIndexForWorkplaceListPage ?? 0,
      tabQuantity_x2_or_x3: 2,
      title: "Postos de Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: () {
        Navigator.pop(context);
      },
      rightIcon2: Icons.add,
      rightIcon2Function: () {
        SingletonWorkplace().isUpdate = false;
        Navigator.pushNamed(context, 'workplace/registration');
      },
      rightIcon1: Icons.sync,
      rightIcon1Function: () {
        setState(() {});
      },
      text1: "Diurno",
      text2: "Noturno",
      widget1: widget1,
      widget2: widget2,
    );
  }
}

class WorkplaceListSubPage extends StatefulWidget {
  int index;
  AsyncSnapshot<QuerySnapshot> snapshot;

  WorkplaceListSubPage({Key key, this.index, this.snapshot}) : super(key: key);

  @override
  _WorkplaceListSubPageState createState() => _WorkplaceListSubPageState();
}

class _WorkplaceListSubPageState extends State<WorkplaceListSubPage> {
  @override
  Widget build(BuildContext context) {
    SingletonWorkplace().currentIndexForWorkplaceListPage = widget.index;
    if (widget.snapshot.data.docs.length == 0) {
      return containerWithNotFoundMessage(
          "Desculpe! Não encontrei ninguém cadastrado neste time :(");
    } else {
      return ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: widget.snapshot.data.docs.length,
        itemBuilder: workplaceItemBuilder,
      );
    }
  }

  Widget workplaceItemBuilder(BuildContext context, int index) {
    Workplace workplaceToShow =
        docToWorkplace(widget.snapshot.data.docs.elementAt(index));
    if (workplaceToShow.type == widget.index)
      return workplaceCardBuilder(workplaceToShow);
    else
      return Container(
        height: 0,
      );
  }

  Widget workplaceCardBuilder(Workplace workplaceToShow) {
    return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          child: WorkplaceAndScheduleCard(
            title: workplaceToShow.name,
            line1: workplaceToShow.type == 0 ? "Diurno" : "Noturno",
            line2: workplaceToShow.doormanQt.toString() +
                (workplaceToShow.doormanQt != 1
                    ? " Porteiros"
                    : (workplaceToShow.doormanQt == 1 ? " Porteiro" : "")),
            line3: workplaceToShow.guardQt.toString() +
                (workplaceToShow.guardQt != 1
                    ? " Vigilantes"
                    : (workplaceToShow.guardQt == 1 ? " Vigilante" : "")),
            onTapFunction: () {
              SingletonWorkplace().isUpdate = true;
              SingletonWorkplace().workplace = workplaceToShow;
              Navigator.pushNamed(context, 'workplace/registration');
            },
          ),
        ));
  }
}
