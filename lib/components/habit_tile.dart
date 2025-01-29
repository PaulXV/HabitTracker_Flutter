import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget{
  final String habitName;
  final bool habitCompleted;
  final Function(bool?) onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Slidable(
        endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              //settings
              SlidableAction(
                onPressed: settingsTapped,
                backgroundColor: Colors.grey.shade800,
                icon: Icons.settings,
                borderRadius: BorderRadius.circular(12),
              ),
              
              //delete
              SlidableAction(
                onPressed: deleteTapped,
                backgroundColor: Colors.red.shade400,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(12),
              )
            ]
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              //checkbox
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
              ),

              //text
              Text(habitName),
            ],
          ),
        ),
      ),
    );
  }
}