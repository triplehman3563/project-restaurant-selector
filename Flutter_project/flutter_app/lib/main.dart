import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:flutterapp/nearBySearchResult.dart';

import 'getNearByRestaurant.dart';

void main() {
  runApp(MyApp());
}

final String apikeys = '&key=AIzaSyBW7dACCxxVyWeUguFXldAv9shrEBIVoaE';
dataBase current_db;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'What to eat Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Completer<GoogleMapController> _controller = Completer();
  var sliderValue1 = 1.0, sliderValue2 = 1.0;

  Position position;
  Widget _child;

  @override
  void initState() {
    getCurrentLoc();

    super.initState();
  }

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    //debugPrint('deviceHeight: $deviceHeight');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(deviceWidth * 0.02),
              constraints: BoxConstraints(
                maxHeight: deviceWidth * 0.7,
                maxWidth: deviceWidth * 0.7,
              ),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 11.0,
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text("ROLL"),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => {getNearByRestaurant(position)},
              ),
            ),
            Container(
//                  color: Colors.yellow,
//                  constraints: BoxConstraints(
//
//                    maxHeight: deviceWidth*0.4,
//                    maxWidth: deviceWidth*0.4,
//                ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Distance"),
                      Slider(
                        value: sliderValue1,
                        min: 1.0,
                        max: 100.0,
                        divisions: 100,
                        label: '$sliderValue1',
                        onChanged: (double newValue) {
                          setState(() {
                            sliderValue1 = newValue;
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Price"),
                      Slider(
                        value: sliderValue2,
                        min: 1.0,
                        max: 100.0,
                        divisions: 100,
                        label: '$sliderValue2',
                        onChanged: (double newValue) {
                          setState(() {
                            sliderValue2 = newValue;
                          });
                        },
                      )
                    ],
                  ),
                  Row(children: <Widget>[
                    if (current_db != null)
                      Image.network(
                        current_db.image[0],
                      )
                    else
                      Image.network(
                        'https://picsum.photos/250?image=9',
                      )
                  ]),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
        ]),
      ),
    );
  }

  void getNearByRestaurant(Position pos) {
    var urlS = 'https://maps.googleapis.com/maps/api/place/'
            'nearbysearch/json?location=' +
        pos.latitude.toString() +
        ',' +
        pos.longitude.toString() +
        '&radius=1500&type=restaurant';
    debugPrint(urlS + apikeys);
    new HttpClient()
        .getUrl(Uri.parse(urlS + apikeys))
        .then((HttpClientRequest request) => request.close())
        //.then((HttpClientResponse response) => this.resultProcessing(response.transform(new Utf8Decoder()).toList()));
        .then((HttpClientResponse response) =>
            {readResponse(response).then((String s) => resultProcessing(s))});
  }

  Future<String> readResponse(HttpClientResponse response) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  void resultProcessing(String s) {
    //debugPrint(s);
    dataBase dB = new dataBase(
        keyWordSearching(s, 'name'),
        keyWordSearching(s, 'icon'),
        keyWordSearching(s, 'vicinity'),
        keyWordSearching(s, 'photo_reference'),
        new List());

    current_db = dB;
    photoPrefToImageList();
    setState(() {});
  }

  var count = 0;
  var result = '';
  var result_index = 0;

  List<dynamic> keyWordSearching(String mother, String keyword) {
    var keyLength = keyword.length;
    var motherLength = mother.length;
    debugPrint('mother length: $motherLength');
    debugPrint('key length: $keyLength');
    //debugPrint('beginTime=' + DateTime.now().toString());
    var beginTime = DateTime.now();
    var result_arr = new List();
    for (var i = 0; i < motherLength - keyLength + 1; i++) {
      //debugPrint('$i');

      var temp = mother.substring(i, i + keyLength);
      //debugPrint(temp);
      if (temp.compareTo(keyword) == 0) {
        count++;
        //debugPrint('$count match');
        //debugPrint(temp);
        //往後判讀雙引號
        var DquoteCount = 0;
        var steps = 0;

        var indexPair = new List(2);
        while (true) {
          //debugPrint(''+mother[i+keyLength+steps]);
          steps++;

          if (mother[i + keyLength + steps + 2].compareTo('"') == 0) {
//            debugPrint('DquoteCount: $DquoteCount ,word: ' +
//                mother[i + keyLength + steps]);
            //debugPrint('index'+(i+keyLength+steps+2).toString()+mother[i+keyLength+steps+2]);
            indexPair[DquoteCount] = i + keyLength + steps + 2;
//            debugPrint(
//                'dQcount: $DquoteCount  ' + indexPair[DquoteCount].toString());
            DquoteCount++;
          }

          if (indexPair[1] != null) {
            //debugPrint('indexPair[0] ' + indexPair[0].toString());
            //debugPrint('indexPair[1] ' + indexPair[1].toString());
            result = mother.substring(indexPair[0] + 1, indexPair[1]);
            //debugPrint('result: ' + result);
            result_arr.add(result);
            //result_index++;
            //debugPrint('break');
            break;
          }
        }
        //debugPrint(result_arr.toString());
      }
    }
    debugPrint(result_arr.length.toString() + ' results in total');
    for (var i = 0; i < result_arr.length; i++) {
      debugPrint(
          'results ' + (i + 1).toString() + ' is ' + result_arr[i].toString());
    }
    var afterTime = DateTime.now();
    debugPrint('Total time cost = ' +
        (afterTime.millisecond - beginTime.millisecond).toString() +
        'ms');
    return result_arr;
  }

  void getValueByTag() {}

  void getCurrentLoc() async {
    Position res = await Geolocator().getCurrentPosition();

    setState(() {
      position = res;
    });
  }

  void photoPrefToImageList() {
    current_db.image = new List(current_db.photo_reference.length);
    for (var i = 0; i < current_db.image.length; i++) {
      current_db.image[i] = getPhoto(current_db.photo_reference[i], 400, 400);
    }
  }

  String getPhoto(String photoPref, int maxHeight, int maxWidth) {
    final String url = 'https://maps.googleapis.com/maps/api/place/photo?';
    var urlS = (url +
        'maxwidth=' +
        maxWidth.toString() +
        '&maxheight' +
        maxHeight.toString() +
        '&photoreference=' +
        photoPref +
        apikeys);

    //Image image = Image.network(urlS);
    return urlS;
  }
}

class dataBase {
  List name = new List();
  List open_now = new List();
  List opening_hours = new List();
  List icon = new List();
  List vicinity = new List();
  List user_ratings_total = new List();
  List photo_reference = new List();
  List image = new List();

  dataBase(
      this.name, this.icon, this.vicinity, this.photo_reference, this.image);
}
