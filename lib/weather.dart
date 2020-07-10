import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Provider/controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class WorldWeather extends StatefulWidget {
  @override
  _WorldWeatherState createState() => _WorldWeatherState();
}

class _WorldWeatherState extends State<WorldWeather> {
  final TextEditingController _textController = new TextEditingController();
  String result="";
  Map<String,dynamic> data;
  bool loading=false;
  bool empty=true;
  String time="";
  String message="Search for a city";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('World Weather'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: time!="" ? time=='night' ? [Colors.indigo[900], Colors.blueGrey[400]] : [Colors.lightBlue[300],Colors.cyan[300],Colors.yellow[200]] : [Colors.white,Colors.white]
            )
          ),
          child:Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget>[
                inputSearch(),
                SizedBox(height:50),
                placeInfo()
              ],
            ),
          ),
        ),
      )
    );
  }

  void _search() async {
    setState(() {
      loading=true;
      time="";
    });
    Map<String,dynamic> resp = await Provider.of<Controller>(context,listen: false).cityInfo(result);
    data=resp;
    if(data["cod"]!=200){
      setState(() {
        message="City not found";
        empty=true;
        loading=false;
        result="";
      });  
    }else{
      setState(() {
        time=data["time"];
        empty=false;
        loading=false;
        result="";
      });
    }
  }

  Widget inputSearch(){
      return TextField(
        controller: _textController,
        style: TextStyle(fontSize:18,fontWeight:FontWeight.w600,color: time=="night" ? Colors.white: Colors.blueGrey),
        // textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
          hintText:'City',
          contentPadding: EdgeInsets.only(left:20),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: ()=> _search()
          ),
        ),
        onChanged: (String value) async {
          setState(() {
            result=value;
          });
        },
      );
  }

  Widget placeInfo(){
    return loading ? Center(child: CircularProgressIndicator(),) : !empty ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:<Widget>[
        Text("${data["name"]}, ${data["country"]}",style: TextStyle(fontSize:24.0,fontWeight: FontWeight.w600,fontFamily: 'Roboto',color: Colors.white),),
        SizedBox(height:20),
        Card(
          child:Padding(
            padding: EdgeInsets.all(16),
            child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    Row(children: <Widget>[
                      Container(
                        height: 100,
                        child:Text("${data["temp"]}",style:TextStyle(fontSize:70.0,fontWeight:FontWeight.w600)),
                      ),
                      Container(
                        height: 85,
                        padding: EdgeInsets.only(top:0.0),
                        child:Text("°C", style:TextStyle(fontSize:32.0,fontWeight:FontWeight.w600)),
                      ),
                    ],),
                    Column(
                      children:<Widget>[
                        Image.network("http://openweathermap.org/img/wn/${data['icon']}@2x.png"),
                        Text(data["description"], style:TextStyle(fontSize:14.0,fontWeight:FontWeight.w400))
                      ]
                    )                 
                  ]
                ),      
          ),
        ),
        SizedBox(height:10),
        Card(
          child:Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Container(
                  child:Row(children: <Widget>[
                    Icon(
                      Icons.arrow_downward,color: Colors.red,size: 18.0),
                      Text("${data["temp_min"]}°C",style:TextStyle(fontSize:18))
                  ],)
                ),
                Container(
                  child:Row(children: <Widget>[
                    Icon(
                      Icons.arrow_upward,color: Colors.blue,size: 18.0),
                      Text("${data["temp_max"]}°C",style:TextStyle(fontSize:18))
                  ],)
                ),
                Container(
                  child:Row(children: <Widget>[
                    Icon(
                      Icons.opacity,color: Colors.grey,size: 18.0),
                      Text("${data["humidity"]}%",style:TextStyle(fontSize:18))
                  ],)
                ),
              ]
            ),
          )
        ),
        SizedBox(height:10),
        Card(
          child:Padding(
            padding:EdgeInsets.all(16),
            child:Container(
                height: 200,
                child:FlutterMap(
                options: new MapOptions(
                    center: new LatLng(data["latitude"], data["longitude"]), maxZoom: 5.0),
                layers: [
                  new TileLayerOptions(
                    urlTemplate:
                      "https://api.mapbox.com/styles/v1/adernio/ckbhd75jy0e971ip73t79kn69/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWRlcm5pbyIsImEiOiJja2JoZTV0b2EwNGd0MnNsdHY0OHdwcThvIn0.RwvA2L6eaneVEZrPs-paRA"
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(data["latitude"], data["longitude"]),
                        builder: (ctx) =>
                        new IconButton(
                          icon: Icon(Icons.location_on),
                          color: Colors.blueGrey,
                          iconSize: 45.0,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        )        
      ]
    ): Center(child:Text(message,style: TextStyle(color:Colors.blueGrey),));
  }

}