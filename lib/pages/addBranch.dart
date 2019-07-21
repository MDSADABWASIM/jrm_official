import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jrm/util/dropDown.dart';
import 'package:jrm/util/textStyle.dart';

class AddBranch extends StatefulWidget {
  @override
  AddBranchState createState() {
    return new AddBranchState();
  }
}

class AddBranchState extends State<AddBranch> {
  String _selectedState = 'Select State',
      _selectedBranchType = 'Select Branch type',
      nameHint = 'Enter guiding Alim of branch',
      districtHint = 'Enter your branch district name',
      fatherHint = 'Enter your father full name',
      tehsilHint = 'Enter your branch  tehsil name',
      pincodeHint = 'Enter your branch area pincode',
      phoneHint = 'Enter guiding Alim mobile number',
      idHint = 'Enter your identity number',
      emailHint = 'Enter your branch email id',
      addressHint = 'Enter branch full address',
      prefixText = '+91';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _tehsilNameController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _guidingAlimPhoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _guidingAlimNameController = TextEditingController();
  TextEditingController _presidentNameController = TextEditingController();
  TextEditingController _presidentPhoneController = TextEditingController();
  TextEditingController _presidentEmailController = TextEditingController();
  TextEditingController _vicepresidentNameController = TextEditingController();
  TextEditingController _vicepresidentPhoneController = TextEditingController();
  TextEditingController _vice2presidentNameController = TextEditingController();
  TextEditingController _vice2presidentPhoneController =
      TextEditingController();
  TextEditingController _vice3presidentNameController = TextEditingController();
  TextEditingController _vice3presidentPhoneController =
      TextEditingController();
  TextEditingController _secretaryNameController = TextEditingController();
  TextEditingController _secretaryPhoneController = TextEditingController();
  TextEditingController _joint1SecretaryNameController =
      TextEditingController();
  TextEditingController _joint1SecretaryPhoneController =
      TextEditingController();
  TextEditingController _joint2SecretaryNameController =
      TextEditingController();
  TextEditingController _joint2SecretaryPhoneController =
      TextEditingController();
  TextEditingController _joint3SecretaryNameController =
      TextEditingController();
  TextEditingController _joint3SecretaryPhoneController =
      TextEditingController();
  TextEditingController _treasurerNameController = TextEditingController();
  TextEditingController _treasurerPhoneController = TextEditingController();
  TextEditingController _jointTreasurerNameController = TextEditingController();
  TextEditingController _jointTreasurerPhoneController =
      TextEditingController();
  TextEditingController _member1NameController = TextEditingController();
  TextEditingController _member1PhoneController = TextEditingController();
  TextEditingController _member2NameController = TextEditingController();
  TextEditingController _member2PhoneController = TextEditingController();
  TextEditingController _member3NameController = TextEditingController();
  TextEditingController _member3PhoneController = TextEditingController();
  TextEditingController _member4NameController = TextEditingController();
  TextEditingController _member4PhoneController = TextEditingController();
  TextEditingController _member5NameController = TextEditingController();
  TextEditingController _member5PhoneController = TextEditingController();
  TextEditingController _member6NameController = TextEditingController();
  TextEditingController _member6PhoneController = TextEditingController();
  TextEditingController _member7NameController = TextEditingController();
  TextEditingController _member7PhoneController = TextEditingController();
  TextEditingController _member8NameController = TextEditingController();
  TextEditingController _member8PhoneController = TextEditingController();
  TextEditingController _member9NameController = TextEditingController();
  TextEditingController _member9PhoneController = TextEditingController();
  TextEditingController _member10NameController = TextEditingController();
  TextEditingController _member10PhoneController = TextEditingController();

  List<String> _branchTypeList = [
    'State level',
    'District level',
    'Tehsil level'
  ];
  List<String> _stateList = [
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Lakshadweep',
    'National Capital Territory of Delhi',
    'Puducherry'
  ];

  @override
  void dispose() {
    _districtController?.dispose();
    _tehsilNameController?.dispose();
    _pincodeController?.dispose();
    _guidingAlimPhoneController?.dispose();
    _emailController?.dispose();
    _addressController?.dispose();
    _guidingAlimNameController?.dispose();
    _presidentEmailController?.dispose();
    _presidentNameController?.dispose();
    _presidentPhoneController?.dispose();
    _vicepresidentNameController?.dispose();
    _vicepresidentPhoneController?.dispose();
    _vice2presidentNameController?.dispose();
    _vice2presidentPhoneController?.dispose();
    _vice3presidentNameController?.dispose();
    _vice3presidentPhoneController?.dispose();
    _secretaryNameController?.dispose();
    _secretaryPhoneController?.dispose();
    _joint1SecretaryNameController?.dispose();
    _joint1SecretaryPhoneController?.dispose();
    _joint2SecretaryNameController?.dispose();
    _joint2SecretaryPhoneController?.dispose();
    _joint3SecretaryNameController?.dispose();
    _joint3SecretaryPhoneController?.dispose();
    _treasurerNameController?.dispose();
    _treasurerPhoneController?.dispose();
    _jointTreasurerNameController?.dispose();
    _jointTreasurerPhoneController?.dispose();
    _member1NameController?.dispose();
    _member1PhoneController?.dispose();
    _member2NameController?.dispose();
    _member2PhoneController?.dispose();
    _member3NameController?.dispose();
    _member3PhoneController?.dispose();
    _member4NameController?.dispose();
    _member4PhoneController?.dispose();
    _member5NameController?.dispose();
    _member5PhoneController?.dispose();
    _member6NameController?.dispose();
    _member6PhoneController?.dispose();
    _member7NameController?.dispose();
    _member7PhoneController?.dispose();
    _member8NameController?.dispose();
    _member8PhoneController?.dispose();
    _member9NameController?.dispose();
    _member9PhoneController?.dispose();
    _member10NameController?.dispose();
    _member10PhoneController?.dispose();
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
        title: Text('Open Branch',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
      body: _addBranchPageBody(),
    );
  }

  Widget _addBranchPageBody() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Text('* sections are mandatory', style: TextStyle(color: Colors.red)),
          SizedBox(height: 20.0),
          _header('Branch Information'),
          SizedBox(height: 40.0),
          _titleForItems('Select your state'),
          SizedBox(height: 15),
          _dropDownForState(),
          SizedBox(height: 25.0),
          _titleForItems('District name'),
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
                    hintText: '$districtHint'),
                controller: _districtController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Tehsil name'),
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
                    hintText: tehsilHint),
                controller: _tehsilNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Enter branch address'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 100.0,
            child: TextField(
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: addressHint),
                controller: _addressController,
                maxLength: 50),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Select Branch type'),
          SizedBox(height: 15),
          _dropDownForBranchType(),
          SizedBox(height: 25.0),
          _titleForItems('Enter branch Pin code'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: pincodeHint),
                controller: _pincodeController),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Enter your branch Email id'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: emailHint),
                controller: _emailController),
          ),
          SizedBox(height: 50.0),
          _header('Branch Designation'),
                    SizedBox(height: 40.0),

          _titleForItems('Guiding Alim of the branch'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter guiding Alim of branch'),
                controller: _guidingAlimNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Guiding Alim Contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter guiding Alim Phone number'),
              controller: _guidingAlimPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('President name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter President name'),
                controller: _presidentNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('President contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter President Phone number'),
              controller: _presidentPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('President Email id'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter President email-id'),
                controller: _presidentEmailController),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Vice President name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Vice President name'),
                controller: _vicepresidentNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Vice President contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Vice President Phone number'),
              controller: _vicepresidentPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Vice 2 President name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Vice 2 President name'),
                controller: _vice2presidentNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Vice 2 President contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Vice 2 President Phone number'),
              controller: _vice2presidentPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Vice 3 President name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Vice 3 President name'),
                controller: _vice3presidentNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Vice 3 President contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Vice 3 President Phone number'),
              controller: _vice3presidentPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Secretary name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Secretary name'),
                controller: _secretaryNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Secretary contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Secretary Phone number'),
              controller: _secretaryPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems(' Joint 1 Secretary name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Joint 1 Secretary name'),
                controller: _joint1SecretaryNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Joint 1 Secretary contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Joint 1 Secretary Phone number'),
              controller: _joint1SecretaryPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems(' Joint 2 Secretary name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Joint 2 Secretary name'),
                controller: _joint2SecretaryNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Joint 2 Secretary contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Joint 2 Secretary Phone number'),
              controller: _joint2SecretaryPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems(' Joint 3 Secretary name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Joint 3 Secretary name'),
                controller: _joint3SecretaryNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Joint 3 Secretary contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Joint 3 Secretary Phone number'),
              controller: _joint3SecretaryPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Treasurer name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Treasurer name'),
                controller: _treasurerNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Treasurer contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Treasurer Phone number'),
              controller: _treasurerPhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Joint Treasurer name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Joint Treasurer name'),
                controller: _jointTreasurerNameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('joint Treasurer contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter joint Treasurer Phone number'),
              controller: _jointTreasurerPhoneController,
            ),
          ),
          SizedBox(height: 50.0),
          _header('Member Information'),
           SizedBox(height: 40.0),
          _titleForItems('Member 1 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 1 name'),
                controller: _member1NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 1 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 1 Phone number'),
              controller: _member1PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 2 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 2 name'),
                controller: _member2NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 2 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 2 Phone number'),
              controller: _member2PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 3 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 3 name'),
                controller: _member3NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 3 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 3 Phone number'),
              controller: _member3PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 4 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 4 name'),
                controller: _member4NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 4 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 4 Phone number'),
              controller: _member4PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 5 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 5 name'),
                controller: _member5NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Member 5 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 5 Phone number'),
              controller: _member5PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 6 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 6 name'),
                controller: _member6NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 6 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 6 Phone number'),
              controller: _member6PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 7 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 7 name'),
                controller: _member7NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 7 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 7 Phone number'),
              controller: _member7PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 8 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 8 name'),
                controller: _member8NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 8 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 8 Phone number'),
              controller: _member8PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 9 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 9 name'),
                controller: _member9NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 9 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 9 Phone number'),
              controller: _member9PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 10 name '),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    prefix: Text(' '),
                    hintText: 'Enter Member 10 name'),
                controller: _member10NameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),
          _titleForOptionalItems('Member 10 contact number'),
          SizedBox(height: 10.0),
          Container(
            color: Colors.white,
            height: 60.0,
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLines: null,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: Text(prefixText),
                  hintText: 'Enter Member 10 Phone number'),
              controller: _member10PhoneController,
            ),
          ),
          SizedBox(height: 30.0),
          SizedBox(height: 50.0),
          RaisedButton(
              color: Colors.green[400],
              shape: OutlineInputBorder(borderSide: BorderSide.none),
              child: Text('Send Request',
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
    return Row(children: <Widget>[
      Text(title + ": ", style: Style.cardHeaderTextStyle),
      Text('*', style: TextStyle(color: Colors.red)),
    ]);
  }

  _titleForOptionalItems(String title) {
    return Text(title + ": ", style: Style.cardHeaderTextStyle);
  }

  _header(String text) {
    return Text(text + ": ", style: Style.detailHeaderTextStyle);
  }

  _uploadToFirestore() async {
    Firestore.instance.runTransaction((transaction) async {
      int time = DateTime.now().millisecondsSinceEpoch;
      String postId =
          Firestore.instance.collection('Branch').document().documentID;

      await transaction
          .set(Firestore.instance.collection('Branch').document('$postId'), {
        'id': postId.toString(),
        'createdAt': time,
        'district': _districtController.text.toString(),
        'tehsil': _tehsilNameController.text.toString(),
        'address': _addressController.text.toString(),
        'pincode': _pincodeController.text.toString(),
        'state': _selectedState,
        'branchType': _selectedBranchType,
        'email': _emailController.text.toString(),
        'AlimPhone': prefixText + _guidingAlimPhoneController.text.toString(),
        'AlimName': _guidingAlimNameController.text.toString(),
        'PresidentName': _presidentNameController.text.toString(),
        'PresidentPhone':prefixText+ _presidentPhoneController.text.toString(),
        'PresidentEmail': _presidentEmailController.text.toString(),
        'VicePresidentName': _vicepresidentNameController.text.toString(),
        'VicePresidentPhone': prefixText+_vicepresidentPhoneController.text.toString(),
        'Vice2PresidentName': _vice2presidentNameController.text.toString(),
        'Vice2PresidentPhone': prefixText+_vice2presidentPhoneController.text.toString(),
        'Vice3PresidentName': _vice3presidentNameController.text.toString(),
        'Vice3PresidentPhone':prefixText+ _vice3presidentPhoneController.text.toString(),
        'SecretaryName': _secretaryNameController.text.toString(),
        'SecretaryPhone': prefixText+_secretaryPhoneController.text.toString(),
        'Joint1SecretaryName': _joint1SecretaryNameController.text.toString(),
        'Joint1SecretaryPhone': prefixText+_joint1SecretaryPhoneController.text.toString(),
        'Joint2SecretaryName': _joint2SecretaryNameController.text.toString(),
        'Joint2SecretaryPhone': prefixText+_joint2SecretaryPhoneController.text.toString(),
        'Joint3SecretaryName': _joint3SecretaryNameController.text.toString(),
        'Joint3SecretaryPhone': prefixText+_joint3SecretaryPhoneController.text.toString(),
        'TreasurerName': _treasurerNameController.text.toString(),
        'TreasurerPhone': prefixText+_treasurerPhoneController.text.toString(),
        'JointTreasurerName': _jointTreasurerNameController.text.toString(),
        'JointTreasurerPhone':prefixText+ _jointTreasurerPhoneController.text.toString(),
        'Member1Name': _member1NameController.text.toString(),
        'Member1Phone':prefixText+ _member1PhoneController.text.toString(),
        'Member2Name': _member2NameController.text.toString(),
        'Member2Phone':prefixText+_member2PhoneController.text.toString(),
        'Member3Name': _member3NameController.text.toString(),
        'Member3Phone': prefixText+_member3PhoneController.text.toString(),
        'Member4Name': _member4NameController.text.toString(),
        'Member4Phone':prefixText+ _member4PhoneController.text.toString(),
        'Member5Name': _member5NameController.text.toString(),
        'Member5Phone': prefixText+_member5PhoneController.text.toString(),
        'Member6Name': _member6NameController.text.toString(),
        'Member6Phone':prefixText+ _member6PhoneController.text.toString(),
        'Member7Name': _member7NameController.text.toString(),
        'Member7Phone': prefixText+_member7PhoneController.text.toString(),
        'Member8Name': _member8NameController.text.toString(),
        'Member8Phone':prefixText+_member8PhoneController.text.toString(),
        'Member9Name': _member9NameController.text.toString(),
        'Member9Phone':prefixText+ _member9PhoneController.text.toString(),
        'Member10Name': _member10NameController.text.toString(),
        'Member10Phone':prefixText+ _member10PhoneController.text.toString(),
        'tag': ''
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
    if (_selectedState == 'Select State') {
      showInSnackBar(value: 'Select your state');
      return;
    }
    if (_districtController.text == '' ||
        _districtController.text == districtHint) {
      showInSnackBar(value: districtHint);
      return;
    }
    if (_tehsilNameController.text == '' ||
        _tehsilNameController.text == tehsilHint) {
      showInSnackBar(value: tehsilHint);
      return;
    }
    if (_addressController.text == '' ||
        _addressController.text == addressHint) {
      showInSnackBar(value: addressHint);
      return;
    }
    if (_selectedBranchType == 'Select Branch type') {
      showInSnackBar(value: 'Select Branch type');
      return;
    }
    if (_pincodeController.text == '' ||
        _pincodeController.text == pincodeHint) {
      showInSnackBar(value: pincodeHint);
      return;
    }
    if (_emailController.text == '' || _emailController.text == emailHint) {
      showInSnackBar(value: emailHint);
      return;
    }
    if (_guidingAlimNameController.text == '') {
      showInSnackBar(value: 'Enter The Guiding Alim');
      return;
    }
    if (_guidingAlimPhoneController.text == '' ||
        _guidingAlimPhoneController.text == phoneHint) {
      showInSnackBar(value: phoneHint);
      return;
    }
    if (_presidentNameController.text == '') {
      showInSnackBar(value: 'Enter The President Name');
      return;
    }
    if (_presidentPhoneController.text == '') {
      showInSnackBar(value: 'Enter President phone number');
      return;
    }
    if (_presidentEmailController.text == '') {
      showInSnackBar(value: 'Enter President email id');
      return;
    }
    if (_vicepresidentNameController.text == '') {
      showInSnackBar(value: 'Enter Vice President Name');
      return;
    }
    if (_vicepresidentPhoneController.text == '') {
      showInSnackBar(value: 'Enter Vice President phone number');
      return;
    }
    if (_secretaryNameController.text == '') {
      showInSnackBar(value: 'Enter The Secretary Name');
      return;
    }
    if (_secretaryPhoneController.text == '') {
      showInSnackBar(value: 'Enter Secretary phone number');
      return;
    }
    if (_joint1SecretaryNameController.text == '') {
      showInSnackBar(value: 'Enter TheJoint  Secretary Name');
      return;
    }
    if (_joint1SecretaryPhoneController.text == '') {
      showInSnackBar(value: 'Enter Joint Secretary phone number');
      return;
    }
    if (_treasurerNameController.text == '') {
      showInSnackBar(value: 'Enter The Treasurer Name');
      return;
    }
    if (_treasurerPhoneController.text == '') {
      showInSnackBar(value: 'Enter Treasurer phone number');
      return;
    }
    if (_member1NameController.text == '') {
      showInSnackBar(value: 'Enter Member 1 Name');
      return;
    }
    if (_member1PhoneController.text == '') {
      showInSnackBar(value: 'Enter Member 1 phone number');
      return;
    }
    if (_member2NameController.text == '') {
      showInSnackBar(value: 'Enter Member 2 Name');
      return;
    }
    if (_member2PhoneController.text == '') {
      showInSnackBar(value: 'Enter Member 2 phone number');
      return;
    }
    if (_member3NameController.text == '') {
      showInSnackBar(value: 'Enter Member 3 Name');
      return;
    }
    if (_member3PhoneController.text == '') {
      showInSnackBar(value: 'Enter Member 3 phone number');
      return;
    }
    if (_member4NameController.text == '') {
      showInSnackBar(value: 'Enter Member 4 Name');
      return;
    }
    if (_member4PhoneController.text == '') {
      showInSnackBar(value: 'Enter Member 4 phone number');
      return;
    }
    if (_member5NameController.text == '') {
      showInSnackBar(value: 'Enter Member 5 Name');
      return;
    }
    if (_member5PhoneController.text == '') {
      showInSnackBar(value: 'Enter Member 5 phone number');
      return;
    }

    await _uploadToFirestore();
  }

  _dropDownForState() {
    return Material(
      child: Container(
        child: DropdownMenu<String>(
          initialValue: _selectedState,
          onSelected: (item) {
            _selectedState = item;
            setState(() {});
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<String>>.generate(
                _stateList.length * 2 - 1, (int index) {
              if (index.isEven) {
                final item = _stateList[index ~/ 2];
                return DropdownMenuItemCustom<String>(value: item, text: item);
              } else {
                return DropdownDivider();
              }
            });
          },
          child: Text(_selectedState),
        ),
      ),
    );
  }

  _dropDownForBranchType() {
    return Material(
      child: Container(
        child: DropdownMenu<String>(
          initialValue: _selectedBranchType,
          onSelected: (item) {
            _selectedBranchType = item;
            setState(() {});
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<String>>.generate(
                _branchTypeList.length * 2 - 1, (int index) {
              if (index.isEven) {
                final item = _branchTypeList[index ~/ 2];
                return DropdownMenuItemCustom<String>(value: item, text: item);
              } else {
                return DropdownDivider();
              }
            });
          },
          child: Text(_selectedBranchType),
        ),
      ),
    );
  }
}
