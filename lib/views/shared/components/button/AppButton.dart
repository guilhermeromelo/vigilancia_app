import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

class AppButton extends StatelessWidget {
  String labelText;
  Function onPressedFunction;
  Color backgroundColor;

  AppButton({Key key, this.labelText, this.onPressedFunction, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 30),
      child: RaisedButton(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        child: Text(
          labelText ?? "",
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        color: backgroundColor ?? AppColors.mainBlue,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
        onPressed: onPressedFunction,
      ),
    );
  }
}
