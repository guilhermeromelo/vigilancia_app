import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/appTextFormField/formatedTextField.dart';
import 'package:vigilancia_app/views/shared/cards/workplaceCard.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/header/internalHeader.dart';

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
      rightIcon2Function: () {},
      rightIcon1: Icons.nightlight_round,
      rightIcon1Function: () {},
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
