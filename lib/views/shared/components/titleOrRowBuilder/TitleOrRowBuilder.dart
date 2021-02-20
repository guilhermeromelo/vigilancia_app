import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

Padding TitleBuilder({Key key, EdgeInsets padding, String title}) {
  return Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title ?? "",
          style: TextStyle(fontSize: 20, color: AppColors.mainBlue),
        )
      ],
    ),
  );
}

Padding RowBuilder({Key key, EdgeInsets padding, String subject, String text}) {
  return Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject ?? "",
          style: TextStyle(fontSize: 18, color: AppColors.mainBlue),
        ),
        Expanded(
            child: Text(text ?? "",
                style: TextStyle(fontSize: 18, color: Colors.black),
                ))
      ],
    ),
  );
}

Padding RowBuilderx2({Key key, EdgeInsets padding, String subject1, String text1,
  String subject2, String text2, int flex1, int flex2}) {
  return Padding(
    padding: padding,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: flex1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject1,
                  style: TextStyle(fontSize: 18, color: AppColors.mainBlue),
                ),
                Text(text1,
                    style: TextStyle(fontSize: 18, color: Colors.black))
              ],
            )),
        Expanded(
          flex: flex2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject2,
                style: TextStyle(fontSize: 18, color: AppColors.mainBlue),
              ),
              Expanded(
                  child: Text(text2,
                      style: TextStyle(fontSize: 18, color: Colors.black)))
            ],
          ),
        )
      ],
    ),
  );
}
