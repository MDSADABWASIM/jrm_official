import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/models/privacyPolicy.dart';
import 'package:jrm/pages/home.dart';
import 'package:jrm/util/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUI extends StatelessWidget {
  FirebaseMessaging firebaseMessaging;

  void _saveSharedprefs(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('$key', value);
  }

  @override
  Widget build(BuildContext context) {
    firebaseMessaging = FirebaseMessaging();
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
                "Privacy policy", signUpGradients, false, context),
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
          onTap: () async{
            if (title == 'Privacy policy') {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => PrivacyPolicy(),
              ));
            } else {
              firebaseMessaging.subscribeToTopic('notifs');
              _saveSharedprefs('notifs', true);
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
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
