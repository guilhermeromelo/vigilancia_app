import 'package:flutter/material.dart';

String dayOfWeekIntToString(int dayInt){
  String _day = "";
  switch(dayInt){
    case 1:{
      _day = "Segunda-feira";
      break;
    }
    case 2:{
      _day = "Terça-feira";
      break;
    }
    case 3:{
      _day = "Quarta-feira";
      break;
    }
    case 4:{
      _day = "Quinta-feira";
      break;
    }
    case 5:{
      _day = "Sexta-feira";
      break;
    }
    case 6:{
      _day = "Sábado";
      break;
    }
    case 7:{
      _day = "Domingo";
      break;
    }
  }
  return _day;
}