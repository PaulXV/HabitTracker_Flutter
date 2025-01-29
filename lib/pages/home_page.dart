import 'package:flutter/material.dart';
import 'package:habit/components/habit_tile.dart';
import 'package:habit/components/month_summary.dart';
import 'package:habit/components/my_fab.dart';
import 'package:habit/components/my_alert_box.dart';
import 'package:habit/data/habit_db.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_DB");

  @override
  void initState(){
    if(_myBox.get("CURRENT_HABIT_LIST") == null){
      db.createDefaultData();
    }
    else{
      db.loadData();
    }

    db.updateDB();

    super.initState();
  }

  // checkbox tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value!;
    });
    db.updateDB();
  }

  // create a new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit(){
    showDialog(
        context: context,
        builder: (context){
          return MyAlertBox(
            controller: _newHabitNameController,
            hintText: "Enter hew habit",
            onSave: saveNewHabit,
            onCancel: cancelDialogBox,
          );
        }
    );
  }

  //save new habit
  void saveNewHabit(){
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });

    _newHabitNameController.clear(); // clear textfield
    Navigator.of(context).pop(); // close dialog box

    db.updateDB();
  }

  //cancel new habit
  void cancelDialogBox(){
    _newHabitNameController.clear(); // clear textfield
    Navigator.of(context).pop(); // close dialog box
  }

  //habit setting
  void openHabitSetting(int index){
    showDialog(context: context, builder: (context){
      return MyAlertBox(
        controller: _newHabitNameController,
        hintText: db.todaysHabitList[index][0],
        onSave: () => saveExistingHabit(index),
        onCancel: cancelDialogBox,
      );
    },);
  }

  //save existing habit
  void saveExistingHabit(int index){
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    cancelDialogBox();

    db.updateDB();
  }

  //delete habbit
  void deleteHabbit(int index){
    setState(() {
      db.todaysHabitList.removeAt(index);
    });

    db.updateDB();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: ListView(
        children: [
          //monthly summary
          MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE")
          ),
          
          //habit list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index){
              return HabitTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSetting(index),
                deleteTapped: (context) => deleteHabbit(index),
              );
            },
          )
        ],
      )
    );
  }
}