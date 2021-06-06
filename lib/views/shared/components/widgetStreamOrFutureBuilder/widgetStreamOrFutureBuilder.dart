import 'package:flutter/material.dart';

Widget containerWithCircularProgress() {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  );
}

Widget containerWithErrorMessage(String erro) {
  return Container(
      alignment: Alignment.center,
      child: Text(
        "Erro Encontrado :( \n" + erro,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ));
}

Widget containerWithNotFoundMessage(String text){
return Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ));
}