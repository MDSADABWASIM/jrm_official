import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jrm/pages/LoginPage.dart';
import 'package:jrm/pages/home.dart';
import 'package:jrm/widgets/onboarding_circle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  Future checkFirstSeen() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    bool _seen = (preference.getBool('seen') ?? false);
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (_seen) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => Home()));
      } else {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => Login()));
      }
    }else{
         Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => OnBoardingCircle()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 1500), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: Color(0xff00364c),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1b1e44),
                      Color(0xFF2d3447),
                    ],
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Color(0xff00364c),
                            radius: 70.0,
                            child: new Image.asset("assets/mosque.png"),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Jamaat Raza-e-mustafa",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Calibre-Semibold",
                                fontSize: 24.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
