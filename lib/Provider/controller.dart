import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


class Controller with ChangeNotifier {

  Future<Map<String,dynamic>> cityInfo(String citta) async {
    String city = citta.replaceAll(' ','+');
    Map<String,dynamic> data;
    var response= await http.get(
      'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=93dec6639288ca8983c1d9a803323cc6'
    );
    final Map<String,dynamic> responseData=json.decode(response.body);
    print(responseData);
    if(responseData["cod"]==200){
      String time;
      String name=responseData["name"];
      double latitude=responseData["coord"]["lat"];
      double longitude=responseData["coord"]["lon"];
      String description=responseData["weather"][0]["description"];
      var icon=responseData["weather"][0]["icon"]; 
      dynamic pressure=responseData["main"]["pressure"];
      dynamic humidity=responseData["main"]["humidity"];
      String country=responseData["sys"]["country"];

      double temp_raw=responseData["main"]["temp"]-273.15;
      double temp_max_raw=responseData["main"]["temp_max"]-273.15;
      double temp_min_raw=responseData["main"]["temp_min"]-273.15;

      var isDay = icon.indexOf("d");
      print(isDay);
      if(isDay==2){
        time='day';
      }else{
        time='night';
      }

      int temp=temp_raw.round();
      int temp_max=temp_max_raw.round();
      int temp_min=temp_min_raw.round();

      data={
      'name':name,
      'latitude':latitude,
      'longitude':longitude,
      'description':description,
      'icon':icon,
      'pressure':pressure,
      'humidity':humidity,
      'country':country,
      'temp':temp,
      'temp_max':temp_max,
      'temp_min':temp_min,
      'time':time,
      'cod':responseData["cod"]
      };
    }else{
      data={'cod':responseData["cod"],'message':responseData["message"]};
    }
    print(data);
    return data; 
  }
}