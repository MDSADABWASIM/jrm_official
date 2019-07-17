import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jrm/models/privacyPolicy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:http/http.dart' as http;

class Setting extends StatefulWidget {
  @override
  SettingState createState() {
    return new SettingState();
  }
}

class SettingState extends State<Setting> {
  bool _notificationEnabled = false,
      azanNotificationEnabled = false,
      allNotificationEnabled = false;
  int fazarHour,
      fazarMinute,
      zoharHour,
      zoharMinute,
      asarHour,
      asarMinute,
      maghribHour,
      maghribMinute,
      isaHour,
      isaMinute;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String version;
  _divider() {
    return Divider(height: 10);
  }

  @override
  void initState() {
   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    _getSharedprefs();
    _getVersion();
    _getTimings();
   
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
          Text('Notify on new articles', style: TextStyle(fontSize: 18.0)),
          _switchForNotification()
        ],
      ),
      _divider(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Notify on Namaz time ', style: TextStyle(fontSize: 18.0)),
          _switchForCancelAzanNotification(),
        ],
      ),
      _divider(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('All notifications', style: TextStyle(fontSize: 18.0)),
          _switchForCancelAllNotification(),
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

  void _getSharedprefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationEnabled = prefs.getBool('notifs') ?? false;
      azanNotificationEnabled = prefs.getBool('AzanNotifs') ?? false;
      allNotificationEnabled = prefs.getBool('LocalNotifs') ?? false;
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
          firebaseMessaging.subscribeToTopic('LiveNotifs');
        } else {
          _saveSharedprefs('notifs', _notificationEnabled);
          firebaseMessaging.unsubscribeFromTopic('notifs');
          firebaseMessaging.unsubscribeFromTopic('LiveNotifs');
        }
      },
    );
  }

  Widget _switchForCancelAllNotification() {
    return Switch(
      activeColor: Colors.green[400],
      value: allNotificationEnabled,
      onChanged: (value) {
        allNotificationEnabled = value;
        if (allNotificationEnabled) {
          _saveSharedprefs('LocalNotifs', _notificationEnabled);
          _saveSharedprefs('notifs', _notificationEnabled);
          _saveSharedprefs('AzanNotifs', _notificationEnabled);
          firebaseMessaging.subscribeToTopic('notifs');
          firebaseMessaging.subscribeToTopic('LiveNotifs');
          _showDailyAtFazarTime();
          _showDailyAtZoharTime();
          _showDailyAtAsarTime();
          _showDailyAtMaghribTime();
          _showDailyAtIsaTime();
          _showWeeklyAtDayAndTime();
          azanNotificationEnabled = true;
          _notificationEnabled = true;
          setState(() {});
        } else {
          _saveSharedprefs('LocalNotifs', _notificationEnabled);
          _saveSharedprefs('notifs', _notificationEnabled);
          _saveSharedprefs('AzanNotifs', _notificationEnabled);
          firebaseMessaging.unsubscribeFromTopic('notifs');
          firebaseMessaging.unsubscribeFromTopic('LiveNotifs');
          _cancelAllNotifications();
          azanNotificationEnabled = false;
          _notificationEnabled = false;
          setState(() {});
        }
      },
    );
  }

  Widget _switchForCancelAzanNotification() {
    return Switch(
      activeColor: Colors.green[400],
      value: azanNotificationEnabled,
      onChanged: (value) {
        azanNotificationEnabled = value;
        if (azanNotificationEnabled) {
          _saveSharedprefs('AzanNotifs', _notificationEnabled);
          _showDailyAtFazarTime();
           _showDailyAtZoharTime();
          _showDailyAtAsarTime();
          _showDailyAtMaghribTime();
          _showDailyAtIsaTime();
        } else {
          _saveSharedprefs('AzanNotifs', _notificationEnabled);
          _cancelAzanNotification();
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
                          'mailto:jrm78692@gmail.com?subject=Feedback&body=Feedback for App'),
                ])))
      ],
    );
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _cancelAzanNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Notification'),
          content: Text(payload),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }

  Future<void> _showDailyAtFazarTime() async {
    var time = Time(fazarHour,fazarMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Fazar namaz is here',
        'It\'s time to wake up for fazar namaz', time, platformChannelSpecifics);
  }

    Future<void> _showDailyAtZoharTime() async {
    var time = Time(zoharHour,zoharMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Zohar namaz is here',
        'It\'s time for zohar namaz', time, platformChannelSpecifics);
  }

    Future<void> _showDailyAtAsarTime() async {
    var time = Time(asarHour,asarMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Asar namaz is here',
        'Don\'t forget to pray on asar', time, platformChannelSpecifics);
  }

    Future<void> _showDailyAtMaghribTime() async {
    var time = Time(maghribHour,maghribMinute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Maghrib time is here',
        'Hurry up for maghrib namaz', time, platformChannelSpecifics);
  }

    Future<void> _showDailyAtIsaTime() async {
    var time = Time(isaHour,isaMinute, 0);
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

  Future<void> _showWeeklyAtDayAndTime() async {
    var time = Time(12, 15, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        1,
        'Jumma Mubarak',
        'Do not forget for namaz',
        Day.Friday,
        time,
        platformChannelSpecifics);
  }

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _showBigPictureNotificationHideExpandedLargeIcon() async {
    var largeIconPath = await _downloadAndSaveImage(
        'http://via.placeholder.com/48x48', 'largeIcon');
    var bigPicturePath = await _downloadAndSaveImage(
        'http://via.placeholder.com/400x800', 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        bigPicturePath, BitmapSource.FilePath,
        hideExpandedLargeIcon: true,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        largeIcon: largeIconPath,
        largeIconBitmapSource: BitmapSource.FilePath,
        style: AndroidNotificationStyle.BigPicture,
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
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
