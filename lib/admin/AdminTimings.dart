import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PostTimings extends StatefulWidget {
  @override
  PostTimingsState createState() {
    return new PostTimingsState();
  }
}

class PostTimingsState extends State<PostTimings> {
  String name,
      timingHint = '5,10 (5:10 am) 20,15 (8:15 pm)',
      zoharTimeHint = 'example 13,4 (for 1:04 pm)',
      asarTimeHint = 'example 16,20 (for 4:20 pm)';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _fazarTimeController = TextEditingController();
  TextEditingController _zoharTimeController = TextEditingController();
  TextEditingController _asarTimeController = TextEditingController();
  TextEditingController _maghribTimeController = TextEditingController();
  TextEditingController _isaTimeController = TextEditingController();

  @override
  void dispose() {
    _fazarTimeController?.dispose();
    _zoharTimeController?.dispose();
    _asarTimeController?.dispose();
    _maghribTimeController?.dispose();
    _isaTimeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.orange[50],
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 5.0,
        title: Text(' Post Azan timings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
      body: _postTimingsPageBody(),
    );
  }

  Widget _postTimingsPageBody() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          _titleForItems('Fazar azan time'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: '$timingHint'),
                controller: _fazarTimeController),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Zohar azan time'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
             height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: '$zoharTimeHint'),
                controller: _zoharTimeController,),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Asar azan time'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
             height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(' '),
                  hintText: '$asarTimeHint'),
              controller: _asarTimeController,
            ),
          ),
            SizedBox(height: 30.0),
          _titleForItems('Maghrib azan time'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
             height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(' '),
                  hintText: '$timingHint'),
              controller: _maghribTimeController,
            ),
          ),
            SizedBox(height: 30.0),
          _titleForItems('Isa azan time'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
             height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(' '),
                  hintText: '$timingHint'),
              controller: _isaTimeController,
            ),
          ),
          SizedBox(height: 50.0),
          RaisedButton(
              color: Colors.green[400],
              shape: OutlineInputBorder(borderSide: BorderSide.none),
              child: Text('Publish  Timing',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500)),
              onPressed: () {
                _onButtonTapped();
              }),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _titleForItems(String title) {
    return Text(title + ": ");
  }

  _uploadToFirestore() async {
    
    Firestore.instance.runTransaction((transaction) async {
      await transaction
          .set(Firestore.instance.collection('Timings').document('azan'), {
        'fazar':_fazarTimeController.text.toString(),
        'zohar':_zoharTimeController.text.toString(),
        'asar':_asarTimeController.text.toString(),
        'maghrib':_maghribTimeController.text.toString(),
        'isa':_isaTimeController.text.toString(),
      });
    }).whenComplete(() {
      Navigator.pop(context, 'success');
    });
  }

  void showInSnackBar({String value, Color color}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "WorkSans"),
      ),
      backgroundColor: color == null ? Colors.red[300] : color,
      duration: Duration(seconds: 2),
    ));
  }

  _onButtonTapped() async {
     if (_fazarTimeController.text == '') {
      showInSnackBar(value: 'Enter the fazar azan time');
      return;
    }
    if (_zoharTimeController.text == '') {
      showInSnackBar(value: 'Enter the zohar azan time');
      return;
    }
     if (_asarTimeController.text == '') {
      showInSnackBar(value: 'Enter the asar azan time');
      return;
    }
      if (_maghribTimeController.text == '') {
      showInSnackBar(value: 'Enter the maghrib azan time');
      return;
    }
      if (_isaTimeController.text == '') {
      showInSnackBar(value: 'Enter the isa azan time');
      return;
    }
    await _uploadToFirestore();
  }

}
