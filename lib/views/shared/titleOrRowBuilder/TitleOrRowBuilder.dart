import 'package:flutter/material.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

Padding TitleBuilder(EdgeInsets padding, String title) {
  return Padding(
    padding: padding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, color: AppColors.mainBlue),
        )
      ],
    ),
  );
}

Padding RowBuilder(EdgeInsets padding, String subject, String text) {
  return Padding(
    padding: padding,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject,
          style: TextStyle(fontSize: 18, color: AppColors.mainBlue),
        ),
        Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.justify))
      ],
    ),
  );
}