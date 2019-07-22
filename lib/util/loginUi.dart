import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jrm/pages/home.dart';
import 'package:jrm/util/auth.dart';
import 'package:jrm/widgets/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _saveSharedprefs(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('$key', value);
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
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
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
            roundedRectButton(
                "Accept and Continue", signInGradients, false, context),
            roundedRectButton(
                "Terms  & conditions", signUpGradients, false, context),
          ],
        )
      ],
    );
  }

  Widget roundedRectButton(String title, List<Color> gradient,
      bool isEndIconVisible, BuildContext context) {
    return Builder(builder: (BuildContext mContext) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () async {
            if (title == 'Terms  & conditions') {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => Terms(),
              ));
            } else {
              firebaseMessaging.subscribeToTopic('notifs');
              firebaseMessaging.subscribeToTopic('LiveNotifs');
              _showWeeklyAtDayAndTime();
              _saveSharedprefs('notifs', true);
              _saveSharedprefs('AzanNotifs', true);
              _saveSharedprefs('LocalNotifs', true);
              await Auth(context).signIn();
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (context) => Home(),
              ));
            }
          },
          child: Stack(
            alignment: Alignment(1.0, 0.0),
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(mContext).size.width / 1.7,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                padding: EdgeInsets.only(top: 16, bottom: 16),
              ),
            ],
          ),
        ),
      );
    });
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
        6,
        'Jumma Mubarak',
        'Do not forget for namaz',
        Day.Friday,
        time,
        platformChannelSpecifics);
  }

  // Future<String> _downloadAndSaveImage(String url, String fileName) async {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$fileName';
  //   var response = await http.get(url);
  //   var file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  // Future<void> _showBigPictureNotificationHideExpandedLargeIcon() async {
  //   var largeIconPath = await _downloadAndSaveImage(
  //       'http://via.placeholder.com/48x48', 'largeIcon');
  //   var bigPicturePath = await _downloadAndSaveImage(
  //       'http://via.placeholder.com/400x800', 'bigPicture');
  //   var bigPictureStyleInformation = BigPictureStyleInformation(
  //       bigPicturePath, BitmapSource.FilePath,
  //       hideExpandedLargeIcon: true,
  //       contentTitle: 'overridden <b>big</b> content title',
  //       htmlFormatContentTitle: true,
  //       summaryText: 'summary <i>text</i>',
  //       htmlFormatSummaryText: true);
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'big text channel id',
  //       'big text channel name',
  //       'big text channel description',
  //       largeIcon: largeIconPath,
  //       largeIconBitmapSource: BitmapSource.FilePath,
  //       style: AndroidNotificationStyle.BigPicture,
  //       styleInformation: bigPictureStyleInformation);
  //   var platformChannelSpecifics =
  //       NotificationDetails(androidPlatformChannelSpecifics, null);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'big text title', 'silent body', platformChannelSpecifics);
  // }

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


const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
