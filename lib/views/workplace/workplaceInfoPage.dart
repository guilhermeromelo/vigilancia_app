import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';
import 'package:vigilancia_app/views/shared/components/header/internalHeader.dart';
import 'package:vigilancia_app/views/workplace/singletonWorkplace.dart';

class WorkplaceInfoPage extends StatefulWidget {
  Workplace workplaceToShow = Workplace();

  @override
  _WorkplaceInfoPageState createState() => _WorkplaceInfoPageState();
}

class _WorkplaceInfoPageState extends State<WorkplaceInfoPage> {

  @override
  void initState() {
    // TODO: implement initState
    widget.workplaceToShow = SingletonWorkplace().workplace;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InternalHeader(
      title: widget.workplaceToShow.name,

    );
  }
}
