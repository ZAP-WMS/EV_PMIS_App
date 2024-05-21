
import 'package:intl/intl.dart';

DateTime? selecteddate = DateTime.now();
String dmy = DateFormat('dd-MM-yyyy').format(selecteddate!);
String monthYear =  DateFormat.yMMMMd().format(selecteddate!);
