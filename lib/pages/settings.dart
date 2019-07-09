import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jrm/models/privacyPolicy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return new SettingState();
  }
}

class SettingState extends State<Setting> {
  bool _notificationEnabled = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String version;
  _divider() {
    return Divider(height: 10);
  }

  @override
  void initState() {
    _getSharedprefs('notifs');
    _getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text('Settings')), body: _settings(context));
  }

  _settings(BuildContext context) {
    return ListView(padding: EdgeInsets.all(10.0), children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Notify me on new articles', style: TextStyle(fontSize: 18.0)),
          _switchForNotification()
        ],
      ),
      _divider(),
      _listItem('Privacy policy', PrivacyPolicy(), context),
      _divider(),
      SizedBox(height: 50),
      GestureDetector(
        onTap: () => _buildAboutListTile(context),
        child: Center(
          child: Text(
            'About JRM App',
            style: TextStyle(fontSize: 18.0, color: Colors.green[400]),
          ),
        ),
      )
    ]);
  }

  _listItem(String text, Widget page, BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => page));
        });
  }

  _getVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    version = info.version;
  }

  void _saveSharedprefs(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('$key', value);
  }

  void _getSharedprefs(String notifs) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationEnabled = prefs.getBool('$notifs') ?? true;
    });
  }

  Widget _switchForNotification() {
    return Switch(
      activeColor: Colors.green[400],
      value: _notificationEnabled,
      onChanged: (value) {
        _notificationEnabled = value;
        if (_notificationEnabled) {
          _saveSharedprefs('notifs', _notificationEnabled);
          firebaseMessaging.subscribeToTopic('notifs');
        } else {
          _saveSharedprefs('notifs', _notificationEnabled);
          firebaseMessaging.unsubscribeFromTopic('notifs');
        }
      },
    );
  }

//about us page builder
  _buildAboutListTile(BuildContext context) {
    final TextStyle bodyStyle =
        new TextStyle(fontSize: 15.0, color: Colors.black);
    return showAboutDialog(
      context: context,
      applicationIcon: Center(
        child: new Image(
          height: 130.0,
          image: new AssetImage("assets/other.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      applicationName: 'JRM',
      applicationVersion: version,
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: new RichText(
                textAlign: TextAlign.start,
                text: new TextSpan(children: <TextSpan>[
                  new TextSpan(
                      style: bodyStyle,
                      text: '''Official Jamat Raza-e-Mustafa (p.b.u.h) app''' +
                          "\n\n"),
                  new TextSpan(
                    style: bodyStyle,
                    text: 'for Any Queries or Feedback:' + "\n\n",
                  ),
                  _LinkTextSpan(
                      style: TextStyle(color: Colors.blue),
                      text: 'Send an E-mail' + "\n\n",
                      url:
                          'mailto:jrm78692?subject=Feedback&body=Feedback for App'),
                ])))
      ],
    );
  }
}

//A text with a link, used in about us page
class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                urlLauncher.launch(url);
              });
}
