import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jrm/util/textStyle.dart';

class MemberDetails extends StatelessWidget {
  final DocumentSnapshot document;
  MemberDetails({this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Details'),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(
      padding: EdgeInsets.all(8),
      children: <Widget>[
        SizedBox(height: 30),
        _title('Member name :'),
        SizedBox(height: 10),
        Text(document['name']),
        SizedBox(height: 30),
        _title('Father\'s name :'),
        SizedBox(height: 10),
        Text(document['father']),
        SizedBox(height: 30),
        _title('State :'),
        SizedBox(height: 10),
        Text(document['state']),
        SizedBox(height: 30),
        _title('District :'),
        SizedBox(height: 10),
        Text(document['district']),
        SizedBox(height: 30),
        _title('Tehsil :'),
        SizedBox(height: 10),
        Text(document['tehsil']),
        SizedBox(height: 30),
        _title('Address :'),
        SizedBox(height: 10),
        Text(document['address']),
        SizedBox(height: 30),
        _title('Pincode :'),
        SizedBox(height: 10),
        Text(document['pincode']),
        SizedBox(height: 30),
        _title('Phone number :'),
        SizedBox(height: 10),
        Text(document['phone']),
        SizedBox(height: 30),
        _title('Email Id :'),
        SizedBox(height: 10),
        Text(document['email']),
        SizedBox(height: 30),
        _title('Id type :'),
        SizedBox(height: 10),
        Text(document['idType']),
        SizedBox(height: 30),
        _title('Id number :'),
        SizedBox(height: 10),
        Text(document['idNumber']),
        SizedBox(height: 30),
        _title('Date of Birth :'),
        SizedBox(height: 10),
        Text(document['dob']),
        SizedBox(height: 50),
      ],
    );
  }

  _title(String text) {
    return Text(text, style: Style.cardHeaderTextStyle);
  }
}
