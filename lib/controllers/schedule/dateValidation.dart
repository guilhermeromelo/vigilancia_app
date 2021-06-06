
import 'package:vigilancia_app/controllers/schedule/scheduleDAO.dart';

Future<bool> isDateValid(DateTime dateToValidate, bool isDay) async {
  bool isValid = true;
  //Check if is there a schedule for this day - returns false is it Already Exists
  if(await checkDuplicateSchedule(dateToValidate, isDay))
    isValid = false;
  return isValid;
}

DateTime removeTime(DateTime dateTime){
  return dateTime.subtract(Duration(hours: dateTime.hour, minutes: dateTime.minute, microseconds: dateTime.microsecond, milliseconds: dateTime.millisecond, seconds: dateTime.second));
}