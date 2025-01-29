String todaysDateFormatted() {
  var dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString();
  if(month.length == 1){
    month = '0$month';
  }
  String day = dateTimeObject.day.toString();
  if(day.length == 1){
    day = '0$day';
  }

  return year + month + day; //yyyymmdd format
}

DateTime createDateTimeObject(String data) {
  int y = int.parse(data.substring(0, 4));
  int m = int.parse(data.substring(4, 6));
  int d = int.parse(data.substring(6, 8));

  return DateTime(y ,m, d);
}

String convertDateTimeToString(DateTime date){
  String y = date.year.toString();
  String m = date.month.toString();
  if(m.length == 1){
    m = '0$m';
  }
  String d = date.day.toString();
  if(d.length == 1){
    d = '0$d';
  }

  return y + m + d;
}
