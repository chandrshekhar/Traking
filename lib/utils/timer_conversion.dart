import 'package:intl/intl.dart';

String? convertTime(DateTime dateTime) {
  String istStr = DateFormat('HH:mm').format(dateTime);

  return istStr;
}

// String? convertDate(DateTime dateTime) {
//   String istStr = DateFormat('dd/MM/yyyy').format(dateTime);

//   print("India Standard Time (IST): $istStr");
//   return istStr;
// }
