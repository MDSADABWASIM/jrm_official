import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jrm/util/textStyle.dart';

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
      padding: EdgeInsets.all(8),
      children: <Widget>[
        SizedBox(height: 30),
        _header('Branch information'),
        SizedBox(height: 20),
        _title('Branch Type :'),
          SizedBox(height: 10),
          Text(document['branchType']),
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
          _title('Pincode :'),
          SizedBox(height: 10),
          Text(document['pincode']),
          SizedBox(height: 30),
          _title('Address :'),
          SizedBox(height: 10),
          Text(document['address']),
          SizedBox(height: 30),
          _title('Branch Email :'),
          SizedBox(height: 10),
          Text(document['email']),
           SizedBox(height: 50.0),
          _header('Branch Designation'),
          SizedBox(height: 20),
           _title('Guiding Alim :'),
          SizedBox(height: 10),
          Text(document['AlimName']),
          SizedBox(height: 30),
           _title('Guiding Alim Phone number :'),
          SizedBox(height: 10),
          Text(document['AlimPhone']),
          SizedBox(height: 30),
           _title('President Name :'),
          SizedBox(height: 10),
          Text(document['PresidentName']),
          SizedBox(height: 30),
           _title('President Phone number :'),
          SizedBox(height: 10),
          Text(document['PresidentPhone']),
          SizedBox(height: 30),
           _title('President Email id :'),
          SizedBox(height: 10),
          Text(document['PresidentEmail']),
          SizedBox(height: 30),
         _title('Vice President Name :'),
          SizedBox(height: 10),
          Text(document['VicePresidentName']),
          SizedBox(height: 30),
           _title('Vice President Phone number :'),
          SizedBox(height: 10),
          Text(document['VicePresidentPhone']),
          SizedBox(height: 30),
           _title('Vice 2 President Name :'),
          SizedBox(height: 10),
          Text(document['Vice2PresidentName']),
          SizedBox(height: 30),
           _title('Vice 2 President Phone number :'),
          SizedBox(height: 10),
          Text(document['Vice2PresidentPhone']),
          SizedBox(height: 30),
           _title('Vice 3 President Name :'),
          SizedBox(height: 10),
          Text(document['Vice3PresidentName']),
          SizedBox(height: 30),
           _title('Vice 3 President Phone number :'),
          SizedBox(height: 10),
          Text(document['Vice3PresidentPhone']),
          SizedBox(height: 30),
           _title('Secretary Name :'),
          SizedBox(height: 10),
          Text(document['SecretaryName']),
          SizedBox(height: 30),
           _title('Secretary Phone number :'),
          SizedBox(height: 10),
          Text(document['SecretaryPhone']),
          SizedBox(height: 30),
             _title('Joint 1 Secretary Name :'),
          SizedBox(height: 10),
          Text(document['Joint1SecretaryName']),
          SizedBox(height: 30),
           _title('Joint 1 Secretary Phone number :'),
          SizedBox(height: 10),
          Text(document['Joint1SecretaryPhone']),
          SizedBox(height: 30),
             _title('Joint 2 Secretary Name :'),
          SizedBox(height: 10),
          Text(document['Joint2SecretaryName']),
          SizedBox(height: 30),
           _title('Joint 2 Secretary Phone number :'),
          SizedBox(height: 10),
          Text(document['Joint2SecretaryPhone']),
          SizedBox(height: 30),
            _title('Joint 3 Secretary Name :'),
          SizedBox(height: 10),
          Text(document['Joint3SecretaryName']),
          SizedBox(height: 30),
           _title('Joint 3 Secretary Phone number :'),
          SizedBox(height: 10),
          Text(document['Joint3SecretaryPhone']),
          SizedBox(height: 30),
            _title('Treasurer Name :'),
          SizedBox(height: 10),
          Text(document['TreasurerName']),
          SizedBox(height: 30),
           _title('Treasurer Phone number :'),
          SizedBox(height: 10),
          Text(document['TreasurerPhone']),
          SizedBox(height: 30),
            _title('Joint Treasurer Name :'),
          SizedBox(height: 10),
          Text(document['JointTreasurerName']),
          SizedBox(height: 30),
           _title('Joint Treasurer Phone number :'),
          SizedBox(height: 10),
          Text(document['JointTreasurerPhone']),
          SizedBox(height: 50),
           _header('Member Information'),
          SizedBox(height: 20),
           _title('Member 1 Name :'),
          SizedBox(height: 10),
          Text(document['Member1Name']),
          SizedBox(height: 30),
           _title('Member 1 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member1Phone']),
          SizedBox(height: 30),
          _title('Member 2 Name :'),
          SizedBox(height: 10),
          Text(document['Member2Name']),
          SizedBox(height: 30),
           _title('Member 2 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member2Phone']),
          SizedBox(height: 30),
           _title('Member 3 Name :'),
          SizedBox(height: 10),
          Text(document['Member3Name']),
          SizedBox(height: 30),
           _title('Member 3 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member3Phone']),
          SizedBox(height: 30),
           _title('Member 4 Name :'),
          SizedBox(height: 10),
          Text(document['Member4Name']),
          SizedBox(height: 30),
           _title('Member 4 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member4Phone']),
          SizedBox(height: 30),
           _title('Member 5 Name :'),
          SizedBox(height: 10),
          Text(document['Member5Name']),
          SizedBox(height: 30),
           _title('Member 5 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member5Phone']),
          SizedBox(height: 30),
           _title('Member 6 Name :'),
          SizedBox(height: 10),
          Text(document['Member6Name']),
          SizedBox(height: 30),
           _title('Member 6 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member6Phone']),
          SizedBox(height: 30),
           _title('Member 7 Name :'),
          SizedBox(height: 10),
          Text(document['Member7Name']),
          SizedBox(height: 30),
           _title('Member 7 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member7Phone']),
          SizedBox(height: 30),
           _title('Member 8 Name :'),
          SizedBox(height: 10),
          Text(document['Member8Name']),
          SizedBox(height: 30),
           _title('Member 8 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member8Phone']),
          SizedBox(height: 30),
           _title('Member 9 Name :'),
          SizedBox(height: 10),
          Text(document['Member9Name']),
          SizedBox(height: 30),
           _title('Member 9 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member9Phone']),
          SizedBox(height: 30),
           _title('Member 10 Name :'),
          SizedBox(height: 10),
          Text(document['Member10Name']),
          SizedBox(height: 30),
           _title('Member 10 Phone number :'),
          SizedBox(height: 10),
          Text(document['Member10Phone']),
          SizedBox(height: 50),
      ],
    );
  }

    _title(String text){
    return Text(text,style:Style.cardHeaderTextStyle);
  }

  _header(String text){
    return Text(text,style:Style.detailHeaderTextStyle);
  }
}