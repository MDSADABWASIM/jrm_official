import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jrm/admin/AdminHome.dart';

/*
Simple admin login just using password , then we verify
the password from firestore admin/password's password
and then we give the permission to enter otherwise just show 
a snackbar.

we can change password anytime from firebase admin/password collection
 */
class AdminLogin extends StatefulWidget {
  @override
  AdminLoginState createState() {
    return new AdminLoginState();
  }
}

class AdminLoginState extends State<AdminLogin> {
  TextEditingController _passwordController = TextEditingController();
  String password;
  GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Firestore.instance
        .collection('admin')
        .document('password')
        .get()
        .then((value) {
      password = value['password'];
    });
    super.initState();
  }

  @override
  void dispose() {
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: _adminLoginBody(),
    );
  }

  _adminLoginBody() {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50.0),
          Container(
            color: Colors.white,
            height: 40.0,
            child: TextField(
              obscureText: true,
                textInputAction: TextInputAction.done,
                controller: _passwordController,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Password'),
               ),
          ),
          SizedBox(height: 100.0),
          RaisedButton(
            shape: OutlineInputBorder(borderSide: BorderSide.none),
              elevation: 10.0,
              color: Colors.green[300],
              child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
              onPressed: () => _onButtonTap()),
          SizedBox(height: 10.0)
        ],
      ),
    );
  }

  _onButtonTap() {
    if (password == _passwordController.text.toString() && _passwordController.text.toString()!='') {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => AdminHomepage()));
    } else {
      _showInSnackBar('Please Re-Enter the password!');
     
    }
  }

   void _showInSnackBar(String value) {
   _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      content: new Text(value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 16.0)),
    ));
  }
}
