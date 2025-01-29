import 'package:habit/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Habit_DB");

class HabitDatabase{

  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // create inital default data
  void createDefaultData(){
    todaysHabitList = [
      // [habitname, habit completed]
      ["Morning Run", false],
      ["Read Book", false],
    ];
    
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  //load data
  void loadData(){
    if(_myBox.get(todaysDateFormatted()) == null){
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      for(int i=0; i < todaysHabitList.length; i++){
        todaysHabitList[i][1] = false;
      }
    }else{
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  //update db
  void updateDB(){
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages(){
    int countCompleted = 0;
    for(int i=0; i < todaysHabitList.length; i++){
      if(todaysHabitList[i][1]){
        countCompleted ++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? "0.0"
        : (countCompleted / todaysHabitList.length ).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap(){
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for(int i=0; i < daysInBetween+1; i++){
      String ymd = convertDateTimeToString(
          startDate.add(Duration(days: i))
      );

      double strength = double.parse(
          _myBox.get("PERCENTAGE_SUMMARY_$ymd") ?? "0.0"
      );

      int y = startDate.add(Duration(days: i)).year;
      int m = startDate.add(Duration(days: i)).month;
      int d = startDate.add(Duration(days: i)).day;

      final percentageForEachDay = <DateTime, int>{
        DateTime(y, m, d): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentageForEachDay.entries);
      //print(heatMapDataSet);
    }

  }

}