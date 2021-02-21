import 'package:flutter/material.dart';

String dayOfWeekIntToString(int dayInt){
  String day = "";
  print(dayInt);
  switch(dayInt){
    case 1:{
      day = "Segunda-feira";
      break;
    }
    case 2:{
      day = "Terça-feira";
      break;
    }
    case 3:{
      day = "Quarta-feira";
      break;
    }
    case 4:{
      day = "Quinta-feira";
      break;
    }
    case 5:{
      day = "Sexta-feira";
      break;
    }
    case 6:{
      day = "Sábado";
      break;
    }
    case 7:{
      day = "Domingo";
      break;
    }
  }
  return day;
}