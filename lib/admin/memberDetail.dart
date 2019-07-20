import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemberDetails extends StatelessWidget {
  final  DocumentSnapshot document;
  MemberDetails({this.document});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Member Details'),centerTitle: true,),
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