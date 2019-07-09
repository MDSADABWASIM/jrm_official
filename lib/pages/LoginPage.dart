import 'package:flutter/material.dart';
import 'package:jrm/util/background.dart';
import 'package:jrm/util/loginUi.dart';

class Login extends StatelessWidget {
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
            LoginUI(),
          ],
        ));
}
}