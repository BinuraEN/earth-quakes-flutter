import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quakesData;
List _features;//features object list in the API

void main() async{
  _quakesData = await getQuakes();
  _features = _quakesData['features'];
  print(_quakesData['features'][0]['properties']);

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
  ));
}


class Quakes extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context,int position){
              if(position.isOdd) return new Divider();
              final index = position ~/ 2;
              var date = new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000,isUtc: true);

              var format = new DateFormat.yMMMd('en_US').add_jm();
              var formattedDate = format.format(date);
              return new ListTile(
                title: new Text(
                  "At : $formattedDate",
                    style: new TextStyle(
                    fontSize: 18.5,
                    color: Colors.red,
                    fontWeight: FontWeight.w700
                  ),
                ),
                subtitle: new Text(
                  "${_features[index]['properties']['place']}",
                  style: new TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic
                  ),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 34.9,
                  child: new Text(
                    "${_features[index]['properties']['mag']}",
                    style: new TextStyle(
                      fontSize: 16.7,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.white
                    ),
                  ),
                ),
                onTap: (){_showAlertMessage(context,"${_features[index]['properties']['title']}");},
              );
            }
        ),
      ),
    );
  }

  void _showAlertMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Quakes'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: (){
              Navigator.pop(context);
              },
            child: new Text('OK'))
      ],
    );
    showDialog(context: context,child: alert);

  }

}

Future<Map> getQuakes() async{
  String apiURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response =await http.get(apiURL);
  return json.decode(response.body);

}

