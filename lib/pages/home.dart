import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jrm/pages/articleHomePage.dart';
import 'package:jrm/pages/compass.dart';
import 'package:jrm/pages/profile.dart';
import 'package:jrm/util/connectivity.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:jrm/widgets/alert.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _children = [
    ArticleHomePage(),
    Compass(),
    Profile(),
  ];
  RemoteConfig remoteConfig;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool connected = false;
  int fazarHour=5,
      fazarMinute=10,
      zoharHour=13,
      zoharMinute=5,
      asarHour=16,
      asarMinute=15,
      maghribHour=18,
      maghribMinute=5,
      isaHour=20,
      isaMinute=0;

  Future<RemoteConfig> setupRemoteConfig(String version) async {
    final RemoteConfig remoteConfiglocal = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfiglocal.setConfigSettings(RemoteConfigSettings());
    remoteConfiglocal.setDefaults(<String, dynamic>{
      'force_update': false,
      'update_version': int.parse(version),
    });
    return remoteConfiglocal;
  }

  _versionCheck() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    String version = info.buildNumber;
    remoteConfig = await setupRemoteConfig(version);
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 60));
      await remoteConfig.activateFetched();
      _checkForUpdate(int.parse(version));
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      // print('Unable to fetch remote config. Cached or default values will be '
      //     'used');
    }
  }

  _firstVisit() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    bool _seen = (preference.getBool('seen') ?? false);
    bool azanNotificationEnabled = preference.getBool('AzanNotifs') ?? false;
    _versionCheck();
    if (!_seen) {
      preference.setBool('seen', true);
      _showDailyAtFazarTime();
      _showDailyAtZoharTime();
      _showDailyAtAsarTime();
      _showDailyAtMaghribTime();
      _showDailyAtIsaTime();
      Future.delayed(Duration(seconds: 5)).whenComplete(() {
        _alertDialog(context);
      });
    } else if (azanNotificationEnabled) {
      _showDailyAtFazarTime();
      _showDailyAtZoharTime();
      _showDailyAtAsarTime();
      _showDailyAtMaghribTime();
      _showDailyAtIsaTime();
    }
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _getTimings();
    FirebaseMessaging messaging = FirebaseMessaging();
    super.initState();
    messaging.configure(
      onLaunch: (Map<String, dynamic> event) {
        return null;
      },
      onMessage: (Map<String, dynamic> event) {
        return null;
      },
      onResume: (Map<String, dynamic> event) {
        return null;
      },
    );
    _firstVisit();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavigationBarProvider>(context);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
     var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "become a Jrm member",
        currentButton: FloatingActionButton(
          heroTag: "addPerson",
          backgroundColor: Colors.purple,
          mini: true,
          child: Icon(EvaIcons.personAddOutline),
          onPressed: () {},
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "open a Jrm branch",
        currentButton: FloatingActionButton(
            heroTag: "people",
            backgroundColor: Colors.green,
            mini: true,
            onPressed: (){},
            child: Icon(EvaIcons.peopleOutline),
            )));
   
    return Scaffold(
      key: _scaffoldKey,
      body: connectionStatus == ConnectivityStatus.Cellular
          ? _children[provider.currentIndex]
          : _noInternetImage(context),
      floatingActionButton: UnicornDialer(
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
            parentButtonBackground: Colors.redAccent,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(EvaIcons.plusCircleOutline),
            childButtons: childButtons),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        //  fabLocation: BubbleBottomBarFabLocation.end, //new
        //  hasNotch: true, //new
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                EvaIcons.homeOutline,
                color: Colors.black,
              ),
              activeIcon: Icon(
                EvaIcons.homeOutline,
                color: Colors.green,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                EvaIcons.compassOutline,
                color: Colors.black,
              ),
              activeIcon: Icon(
                EvaIcons.compassOutline,
                color: Colors.indigo,
              ),
              title: Text("Compass")),
          BubbleBottomBarItem(
              backgroundColor: Colors.purple,
              icon: Icon(
                EvaIcons.personOutline,
                color: Colors.black,
              ),
              activeIcon: Icon(
                EvaIcons.personOutline,
                color: Colors.purple,
              ),
              title: Text("Profile"))
        ],
      ),
    );
  }

  _getTimings() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('Timings').getDocuments();
    if(snapshot.documents.length!=null && snapshot.documents.length!=0)
    _getExactTimings(snapshot);
  }

  _getExactTimings(QuerySnapshot snapshot) {
    fazarHour =
        int.parse(snapshot.documents[0].data['fazar'].toString().split(",")[0]);
    fazarMinute =
        int.parse(snapshot.documents[0].data['fazar'].toString().split(",")[1]);

    zoharHour =
        int.parse(snapshot.documents[0].data['zohar'].toString().split(",")[0]);
    zoharMinute =
        int.parse(snapshot.documents[0].data['zohar'].toString().split(",")[1]);

    asarHour =
        int.parse(snapshot.documents[0].data['asar'].toString().split(",")[0]);
    asarMinute =
        int.parse(snapshot.documents[0].data['asar'].toString().split(",")[1]);

    maghribHour = int.parse(
        snapshot.documents[0].data['maghrib'].toString().split(",")[0]);
    maghribMinute = int.parse(
        snapshot.documents[0].data['maghrib'].toString().split(",")[1]);

    isaHour =
        int.parse(snapshot.documents[0].data['isa'].toString().split(",")[0]);
    isaMinute =
        int.parse(snapshot.documents[0].data['isa'].toString().split(",")[1]);
  }

  _checkForUpdate(int version) async {
    await Future.delayed(Duration(milliseconds: 50));
    if (remoteConfig.getBool('force_update') == true) {
      return (version < remoteConfig.getInt('update_version'))
          ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: Text('Please Update the  App'),
                      titleTextStyle: Style.cardHeaderTextStyle,
                      content: new Text(
                        'Update the app for better and smooth experience.',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: <Widget>[
                        new RaisedButton(
                          color: Colors.green[300],
                          shape:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          onPressed: () async {
                            if (await canLaunch(
                                'https://play.google.com/store/apps/details?id=jrm.com')) {
                              await launch(
                                  'https://play.google.com/store/apps/details?id=jrm.com');
                            } else {
                              showInSnackBar(value: 'Url is invalid!');
                            }
                          },
                          child: new Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ))
          : SizedBox();
    }
  }

  Widget _noInternetImage(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
          height: height / 2,
          width: width - 10.0,
          child: Image.asset(
            'assets/noInternet.png',
            fit: BoxFit.fitWidth,
          )),
    );
  }

  void showInSnackBar({String value, Color color}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "Calibre-Semibold"),
      ),
      backgroundColor: color == null ? Colors.red[300] : color,
      duration: Duration(seconds: 2),
    ));
  }

  _alertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BeautifulAlertDialog();
        });
  }

  Future<void> _showDailyAtFazarTime() async {
    var time = Time(fazarHour, fazarMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Fazar namaz is here',
        'It\'s time to wake up for fazar namaz',
        time,
        platformChannelSpecifics);
  }

  Future<void> _showDailyAtZoharTime() async {
    var time = Time(zoharHour, zoharMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Zohar namaz is here',
        'It\'s time for zohar namaz',
        time,
        platformChannelSpecifics);
  }

  Future<void> _showDailyAtAsarTime() async {
    var time = Time(asarHour, asarMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Asar namaz is here',
        'Don\'t forget to pray on asar',
        time,
        platformChannelSpecifics);
  }

  Future<void> _showDailyAtMaghribTime() async {
    var time = Time(maghribHour, maghribMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Maghrib time is here',
        'Hurry up for maghrib namaz',
        time,
        platformChannelSpecifics);
  }

  Future<void> _showDailyAtIsaTime() async {
    var time = Time(isaHour, isaMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'It\'s Isa time',
        'It\'s time  for isa namaz', time, platformChannelSpecifics);
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
