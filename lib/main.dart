import 'package:flutter/material.dart';
import 'package:flutter_audio_record/home.dart';
import 'dart:developer' as developer;
import 'speechservice.dart' as speechService;

void main() {
  developer.log('log me', name: 'my.app.category');
  runApp(MyApp());
}

class GlobalData {
  static const datosusuario = 'su';
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        title: 'Recording Golf Sitck',
      ),
    );
  }
}