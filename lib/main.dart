import 'package:flutter/material.dart';
import 'package:habit/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main () async{

  //hive part
  await Hive.initFlutter();
  await Hive.openBox("Habit_DB");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
    );
  }
}