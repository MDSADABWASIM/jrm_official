import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/chat/app_chat.dart';
import 'package:jrm/pages/LoginPage.dart';
import 'package:jrm/util/auth.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: GetClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                user != null
                    ? Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(user.photoUrl),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ]))
                    : SizedBox(),
                SizedBox(height: 90.0),
                user != null
                    ? Text(
                        user.displayName,
                        style: Style.profileNameTextStyle,
                      )
                    : SizedBox(),
                SizedBox(height: 50),
                Center(
                  child: Container(
                      height: 30.0,
                      width: 125.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.green[400],
                        color: Colors.green[400],
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => AppChat(),
                            ));
                          },
                          child: Center(
                            child: Text(
                              'Chat With Us',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: 50),
                Center(
                  child: Container(
                      height: 30.0,
                      width: 95.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.red,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            await Auth(context).signOut();
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Center(
                            child: Text(
                              'Log out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ))
      ],
    ));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
