import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BranchDetails extends StatelessWidget {
final  DocumentSnapshot document;
  BranchDetails({this.document});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('Branch Details'),centerTitle: true,),
    body: _body(),
    );
  }

  _body(){
    return ListView(
      children: <Widget>[

      ],
    );
  }
}