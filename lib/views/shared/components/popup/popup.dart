import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vigilancia_app/views/shared/components/appTextFormField/appTextFormField.dart';
import 'package:vigilancia_app/views/shared/components/button/AppButton.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';
import 'package:vigilancia_app/views/shared/constants/masks.dart';

class PopUpSchedule extends StatefulWidget {
  Function onButtonPressed;
  Function onFormTextFieldChange;
  Function formTextFieldValidator;
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate;

  PopUpSchedule(
      {Key key,
      this.onButtonPressed,
      this.formTextFieldValidator,
      this.onFormTextFieldChange})
      : super(key: key);

  @override
  _PopUpScheduleState createState() => _PopUpScheduleState();
}

class _PopUpScheduleState extends State<PopUpSchedule> {
  @override
  void initState() {
    // TODO: implement initState
    widget.selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(
        "Selecione a Data da Escala de Trabalho:",
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: widget._formKey,
        child: AppTextFormField(
          readOnly: true,
          labelText: "Data",
          inputFormatterField: AppMasks.dataMask,
          initialValue:
              DateFormat("dd/MM/yy").format(widget.selectedDate).toString(),
          keyboardInputType: TextInputType.number,
          validatorFunction: widget.formTextFieldValidator,
          onChangedFunction: (text) {
            //widget.selectedDate = text;
            //widget.onFormTextFieldChange(text);
          },
          suffixIcon: Icons.calendar_today,
          suffixIconOnPressed: () {
            return _selectDate(context);
          },
        ),
      ),
      actions: [
        Container(
          child: AppButton(
            labelText: "Sortear",
            onPressedFunction: () {
              if (widget._formKey.currentState.validate()) {
                widget.onFormTextFieldChange(widget.selectedDate);
                widget.onButtonPressed();
              }
            },
          ),
          width: 400,
        )
      ],
      titleTextStyle: TextStyle(
          color: AppColors.mainBlue, fontSize: 20, fontWeight: FontWeight.w500),
      contentPadding: EdgeInsets.only(
          left: size.width * 0.06,
          right: size.width * 0.06,
          top: 20,
          bottom: 0),
      actionsPadding: EdgeInsets.only(bottom: 20),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDate)
      setState(() {
        widget.selectedDate = picked;
        widget.onFormTextFieldChange(widget.selectedDate);
        FocusScope.of(context).requestFocus(new FocusNode());
      });
  }
}

//-----------------------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------------------

class PopUpYesOrNo extends StatefulWidget {
  Function onYesPressed;
  Function onNoPressed;
  String title;
  String text;

  PopUpYesOrNo(
      {Key key, this.onYesPressed, this.onNoPressed, this.title, this.text})
      : super(key: key);

  @override
  _PopUpYesOrNoState createState() => _PopUpYesOrNoState();
}

class _PopUpYesOrNoState extends State<PopUpYesOrNo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        widget.text,
        textAlign: TextAlign.center,
      ),
      actions: [
        Container(
          width: (size.width * 0.77),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: AppButton(
                  backgroundColor: Colors.red,
                  labelText: "Não",
                  onPressedFunction: widget.onNoPressed ?? () {},
                ),
                width: (size.width * 0.70) / 2,
              ),
              Container(
                child: AppButton(
                  backgroundColor: Colors.green,
                  labelText: "Sim",
                  onPressedFunction: widget.onYesPressed ?? () {},
                ),
                width: (size.width * 0.70) / 2,
              )
            ],
          ),
        )
      ],
      titleTextStyle: TextStyle(
          color: AppColors.mainBlue, fontSize: 24, fontWeight: FontWeight.w500),
      contentTextStyle: TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      contentPadding: EdgeInsets.only(
          left: size.width * 0.06,
          right: size.width * 0.06,
          top: 20,
          bottom: 0),
      actionsOverflowDirection: VerticalDirection.up,
      actionsPadding: EdgeInsets.only(bottom: 20),
    );
  }
}
