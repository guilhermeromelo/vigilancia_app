import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/components/header/InternalHeaderWithTabBar.dart';

class WorkplaceListPage extends StatefulWidget {
  @override
  _WorkplaceListPageState createState() => _WorkplaceListPageState();
}

class _WorkplaceListPageState extends State<WorkplaceListPage> {
  @override
  Widget build(BuildContext context) {
    return InternalHeaderWithTabBar(
      tabQuantity_x2_or_x3: 2,
      title: "Postos de Trabalho",
      leftIcon: Icons.arrow_back_ios,
      leftIconFunction: (){Navigator.pop(context);},
      rightIcon1: Icons.add,
      rightIcon1Function: (){
        Navigator.pushNamed(context, 'workplace/registration');
      },
      text1: "Diurno",
      text2: "Noturno",
      widget1: WorkplaceListSubPage(index: 0,),
      widget2: WorkplaceListSubPage(index: 1,),


    );
  }
}

class WorkplaceListSubPage extends StatefulWidget {
  int index;

  WorkplaceListSubPage({Key key, this.index}) : super(key: key);

  @override
  _WorkplaceListSubPageState createState() => _WorkplaceListSubPageState();
}

class _WorkplaceListSubPageState extends State<WorkplaceListSubPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
