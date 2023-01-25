extension DateUtil on DateTime {
  String get toTime{
    var hours = int.parse(toString().split(' ').last.substring(0,2));
    var meridiem = 'AM';
    if(hours >= 12){
      meridiem = 'PM';
      hours = hours - 12;
    }
    return '${hours.toString()}${toString().split(' ').last.substring(2,5)} $meridiem';
  }
}