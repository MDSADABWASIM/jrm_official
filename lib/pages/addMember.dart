import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jrm/util/dropDown.dart';
import 'package:jrm/util/textStyle.dart';

class AddMember extends StatefulWidget {
  @override
  AddMemberState createState() {
    return new AddMemberState();
  }
}

class AddMemberState extends State<AddMember> {
  String 
         _selectedState = 'Select State',
         _selectedIdType = 'Select Id type',
      nameHint = 'Enter your full name',
      districtHint = 'Enter your district name',
      fatherHint = 'Enter your father full name',
      tehsilHint = 'Enter your tehsil name',
      pincodeHint = 'Enter your area pincode',
      phoneHint = 'Enter your mobile number',
      idHint = 'Enter your identity number',
      emailHint = 'Enter your email id',
      addressHint = 'Enter your full address',
       prefixText = '+91';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _fatherNameController = TextEditingController();
  TextEditingController _tehsilNameController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  List<String> _idTypeList=['Adhar card','Passport','Voter id','Pan card','DL'];
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
DateTime selectedDate = DateTime.now();
bool _agreed=false;

  @override
  void dispose() {
    _districtController?.dispose();
    _fatherNameController?.dispose();
    _tehsilNameController?.dispose();
    _pincodeController?.dispose();
    _phoneController?.dispose();
    _idController?.dispose();
    _emailController?.dispose();
    _addressController?.dispose();
    _nameController?.dispose();
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
        title: Text(' Jrm member form',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
      body: _addMemberPageBody(),
    );
  }

  Widget _addMemberPageBody() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
           Text('* sections are mandatory', style: TextStyle(color: Colors.red)),
          SizedBox(height: 20.0),
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
            _titleForItems('Enter full address'),
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
          _titleForItems('Name'),
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
                    hintText: '$nameHint'),
                controller: _nameController,
                maxLength: 20),
          ),
          SizedBox(height: 30.0),

          _titleForItems('Father\'s name'),
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
                  hintText: fatherHint),
              controller: _fatherNameController,
            ),
          ),
          SizedBox(height: 30.0),
             _titleForItems('Pin code'),
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
             _titleForOptionalItems('Email id'),
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
          SizedBox(height: 30.0),
              _titleForItems('Phone number'),
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
                    hintText: phoneHint),
                controller: _phoneController),
          ),
          SizedBox(height: 30.0),
             _titleForItems('Select Id type'),
          SizedBox(height: 15),
          _dropDownForIdType(),
          SizedBox(height: 25.0),
            _titleForItems(' Id number'),
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
                    hintText: idHint),
                controller: _idController),
          ),
          SizedBox(height: 30.0),
             _titleForOptionalItems('Enter your date of birth'),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: ()=>_selectDate(context),
            child: Container(
              color: Colors.white,
              height: 60.0,
              child: Text((selectedDate.day.toString()+'/'+selectedDate.month.toString()+'/'+selectedDate.year.toString()))
            ),
          ),
          SizedBox(height: 30.0),
          _checkBox(),
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

_titleForItems(String title){
  return Row(
    children:<Widget>[
     Text(title+": ",style:Style.cardHeaderTextStyle),
     Text('*',style:TextStyle(color:Colors.red)),
  ]);
}

  _titleForOptionalItems(String title) {
    return Text(title + ": ",style:Style.cardHeaderTextStyle);
  }

  _uploadToFirestore() async {
    Firestore.instance.runTransaction((transaction) async {
      int time = DateTime.now().millisecondsSinceEpoch;
      String postId =
          Firestore.instance.collection('Member').document().documentID;

      await transaction
          .set(Firestore.instance.collection('Member').document('$postId'), {
        'id': postId.toString(),
        'createdAt': time,
        'district': _districtController.text.toString(),
        'father': _fatherNameController.text.toString(),
        'name': _nameController.text.toString(),
        'tehsil': _tehsilNameController.text.toString(),
        'address': _addressController.text.toString(),
        'pincode': _pincodeController.text.toString(),
        'phone': prefixText+_phoneController.text.toString(),
        'state': _selectedState,
        'idType': _selectedIdType,
        'idNumber': _idController.text.toString(),
        'email': _emailController.text.toString(),
        'dob': selectedDate.toString(),
        'tag':''
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
      showInSnackBar(value:'Select your state');
      return;
    }
  if (_districtController.text == ''||_districtController.text==districtHint) {
      showInSnackBar(value:districtHint);
      return;
    }
     if (_tehsilNameController.text == ''||_tehsilNameController.text==tehsilHint) {
      showInSnackBar(value:tehsilHint);
      return;
    }
      if (_addressController.text == ''||_addressController.text==addressHint) {
      showInSnackBar(value:addressHint);
      return;
    }
    if (_nameController.text == ''||_nameController.text==nameHint) {
      showInSnackBar(value:nameHint);
      return;
    }

   if (_fatherNameController.text == ''||_fatherNameController.text==fatherHint) {
      showInSnackBar(value:fatherHint);
      return;
    }
    if (_pincodeController.text == ''||_pincodeController.text==pincodeHint) {
      showInSnackBar(value: pincodeHint);
      return;
    }
     if (_emailController.text == ''||_emailController.text==emailHint) {
      showInSnackBar(value: emailHint);
      return;
    }
     if (_phoneController.text == ''||_phoneController.text==phoneHint) {
      showInSnackBar(value: phoneHint);
      return;
    }
      if (_selectedIdType == 'Select Id type') {
      showInSnackBar(value:'Select id type');
      return;
    }
     if (_idController.text == ''||_idController.text==idHint) {
      showInSnackBar(value: idHint);
      return;
    } 
      if (_agreed == false) {
      showInSnackBar(value: 'Please check agreement box');
      return;
    }
    await _uploadToFirestore();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920),
        lastDate: DateTime(2120));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
 
 _checkBox(){
return CheckboxListTile(
    title: Text("I agree to abide by all the rules and regulations set by Jamat Raza-E-Mustafa and pledge to remain firm upon the faith and traditions of the Ahle Sunnat (Maslak-E-Alahazrat), as a member of this organization, I shall continually strive to work for the betterment of the islamic nation and community."),
    value: _agreed,
    onChanged: (newValue) =>setState(()=>_agreed=newValue),
    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
  );}
 
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

  _dropDownForIdType() {
    return Material(
      child: Container(
        child: DropdownMenu<String>(
          initialValue: _selectedIdType,
          onSelected: (item) {
            _selectedIdType = item;
            setState(() {});
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<String>>.generate(
                _idTypeList.length * 2 - 1, (int index) {
              if (index.isEven) {
                final item = _idTypeList[index ~/ 2];
                return DropdownMenuItemCustom<String>(value: item, text: item);
              } else {
                return DropdownDivider();
              }
            });
          },
          child: Text(_selectedIdType),
        ),
      ),
    );
  }
}
