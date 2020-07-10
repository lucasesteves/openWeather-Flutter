import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Provider/controller.dart';
import './weather.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Controller(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'World Weather',
        theme: ThemeData(
          primaryColor: Colors.blueGrey
        ),
        home: WorldWeather()
      ),
    );  
  }
}

