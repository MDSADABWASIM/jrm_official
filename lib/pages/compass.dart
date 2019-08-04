import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:hijri/umm_alqura_calendar.dart';

class Anim {
  String name;
  double _value = 0, pos = 0, min, max, speed;
  bool endless = false;
  ActorAnimation actor;
  Anim(this.name, this.min, this.max, this.speed, this.endless);
  get value => _value * (max - min) + min;
  set value(double v) => _value = (v - min) / (max - min);
}

class AniControl extends FlareControls {
  List<Anim> items;
  AniControl(this.items);

  @override
  bool advance(FlutterActorArtboard board, double elapsed) {
    super.advance(board, elapsed);
    for (var a in items) {
      if (a.actor == null) continue;
      var d = (a.pos - a._value).abs();
      var m = a.pos > a._value ? -1 : 1;
      if (a.endless && d > 0.5) {
        m = -m;
        d = 1.0 - d;
      }
      var e = elapsed / a.actor.duration * (1 + d * a.speed);
      a.pos = e < d ? (a.pos + e * m) : a._value;
      if (a.endless) a.pos %= 1.0;
      a.actor.apply(a.actor.duration * a.pos, board, 1.0);
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard board) {
    super.initialize(board);
    items.forEach((a) => a.actor = board.getAnimation(a.name));
  }

  operator [](String name) {
    for (var a in items) if (a.name == name) return a;
  }
}

class Compass extends StatefulWidget {
  @override
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  int mode = 0, map = 0;
  AniControl compass;
  double lat, lon;
  ummAlquraCalendar _today;
  String city = '', weather = '', icon = '01d';
  double temp = 0, humidity = 0;

  void getWeather() async {
    var key = '0918f3651be953d2b32d67139d7abc9b';
    var url =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$key';
    var resp = await http.Client().get(url);
    var data = json.decode(resp.body);
    city = data['name'];
    var m = data['weather'][0];
    weather = m['main'];
    icon = m['icon'];
    m = data['main'];
    temp = m['temp'] - 273.15;
    humidity = m['humidity'] + 0.0;
    setState(() {});
  }

  void setLocation(double lati, double long, [bool weather = true]) {
    lat = lati;
    lon = long;
    if (weather) getWeather();
    setState(() {});
  }

  void locate() => Location()
      .getLocation()
      .then((p) => setLocation(p.latitude, p.longitude));

  @override
  void initState() {
    super.initState();
final now = DateTime.now();
// final yesterday = DateTime(now.year, now.month, now.day - 1);
final today = DateTime(now.year, now.month, now.day);
    _today = ummAlquraCalendar.fromDate(today);
    compass = AniControl([
      Anim('dir', 0, 360, 45, true),
      Anim('hor', -9.6, 9.6, 20, false),
      Anim('ver', -9.6, 9.6, 20, false),
    ]);

    FlutterCompass.events.listen((angle) {
      compass['dir'].value = angle;
    });

    accelerometerEvents.listen((event) {
      compass['hor'].value = -event.x;
      compass['ver'].value = -event.y;
    });

    setLocation(0, 0);
    locate();
  }

  Widget _compass() {
    return Column(children: [
      Flexible(
        child: GestureDetector(
          onTap: () => setState(() => mode++),
          child: FlareActor("assets/compass.flr",
              animation: 'mode${mode % 2}', controller: compass),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(EvaIcons.arrowheadUpOutline,color: Colors.white),
            SizedBox(width: 15),
            Text('swipe up to see weather info & hijri date',style: TextStyle(color: Colors.white,fontFamily:  'Calibre-Semibold',fontSize: 16),)
          ],
        ),
      ),
      SizedBox(height: 20)
    ]);
  }

  Widget _earth() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(_today.toFormat("MMMM dd "),
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 10),
                 Text('( Hijri )',
            style: TextStyle(
                fontSize: 15, color: Colors.white)),
              ]),
      SizedBox(height: 30),
      Text(city,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      // Text('lat:${lat.toStringAsFixed(2)}  lon:${lon.toStringAsFixed(2)}'),
      SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            width: 128,
            height: 128,
            child: FlareActor('assets/weather.flr', animation: icon)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${temp.toInt()}° c',
              style: TextStyle(fontSize: 60, color: Colors.white)),
          Text(weather, style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(height: 10),
          Text('Humidity ${humidity.toInt()}%',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ]),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: PageController(viewportFraction: 1.0),
        scrollDirection: Axis.vertical,
        children: [_compass(), _earth()],
      ),
    );
  }
}
