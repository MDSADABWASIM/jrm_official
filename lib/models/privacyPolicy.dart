import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/admin/AdmiinLogin.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onLongPress: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (context)=>AdminLogin())
              );
            },
            child: Text('Privacy Policy')),
        centerTitle: true,
      ),
      body: Text(''' '''),
    );
  }
}
