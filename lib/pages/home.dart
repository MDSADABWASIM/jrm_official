import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:jrm/pages/articleHomePage.dart';
import 'package:jrm/pages/compass.dart';
import 'package:jrm/pages/profile.dart';
import 'package:jrm/util/connectivity.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:jrm/widgets/alert.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool connected = false;

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
    _versionCheck();
    if (!_seen) {
      preference.setBool('seen', true);
      Future.delayed(Duration(seconds: 5)).whenComplete(() {
        _alertDialog(context);
      });
    }
  }

  @override
  void initState() {
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
    return Scaffold(
      key: _scaffoldKey,
      body: connectionStatus == ConnectivityStatus.Cellular
          ? _children[provider.currentIndex]
          : _noInternetImage(context),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: provider.currentIndex,
        onTap: (index) {
          provider.currentIndex = index;
        },
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        // fabLocation: BubbleBottomBarFabLocation.end, //new
        // hasNotch: true, //new
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
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
