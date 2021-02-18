import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/cards/workplaceCard.dart';
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
      ],
    );
  }
}
