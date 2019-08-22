import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jrm/util/dropDown.dart';

class PostLive extends StatefulWidget {
  @override
  PostLiveState createState() {
    return new PostLiveState();
  }
}

class PostLiveState extends State<PostLive> {
  String name,
      titleHint = 'Enter Article title',
      urlHint = 'Enter fb live url here',
      _selectedImage = 'Select an image';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _imageDropDownItems = [
    'Kaaba',
    'Quran',
    'Mosque',
    'Flag',
    'Calender',
    'Other',
  ];

  TextEditingController _postTitleController = TextEditingController();
  TextEditingController _postUrlController = TextEditingController();

  @override
  void dispose() {
    _postTitleController?.dispose();
    _postUrlController?.dispose();
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
        title: Text(' Post Live',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
      body: _postArticlePageBody(),
    );
  }

  Widget _postArticlePageBody() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          _titleForItems('Select an image'),
          SizedBox(height: 15),
          _dropDownForImage(),
          SizedBox(height: 30.0),
          _titleForItems('Live Title'),
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
                    hintText: '$titleHint'),
                controller: _postTitleController,
                maxLength: 50),
          ),
          SizedBox(height: 30.0),
          _titleForItems('Live Url'),
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
                  hintText: '$urlHint'),
              controller: _postUrlController,
            ),
          ),
          SizedBox(height: 50.0),
          RaisedButton(
              color: Colors.green[400],
              shape: OutlineInputBorder(borderSide: BorderSide.none),
              child: Text('Publish  Live',
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
    String image;

    switch (_selectedImage) {
      case 'Kaaba':
        image = 'assets/kaaba.png';
        break;

      case 'Mosque':
        image = 'assets/mosque.png';
        break;

      case 'Quran':
        image = 'assets/quran.png';
        break;

      case 'Flag':
        image = 'assets/flag.png';
        break;

      case 'Calender':
        image = 'assets/date.png';
        break;

      case 'Other':
        image = 'assets/other.png';
        break;

      default:
        image = 'assets/other.png';
    }

    Firestore.instance.runTransaction((transaction) async {
      int time = DateTime.now().millisecondsSinceEpoch;
      String postId =
          Firestore.instance.collection('Lives').document().documentID;

      await transaction
          .set(Firestore.instance.collection('Lives').document('$postId'), {
        'id': postId.toString(),
        'image': image,
        'createdAt': time,
        'title': _postTitleController.text.toString(),
        'url': _postUrlController.text.toString(),
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
    if (_selectedImage == 'Select an image') {
      showInSnackBar(value: 'Select an image');
      return;
    }
    if (_postTitleController.text == '') {
      showInSnackBar(value: 'Enter the title for the live');
      return;
    }
    if (_postUrlController.text == '') {
      showInSnackBar(value: 'Enter the URL of fb live');
      return;
    }
    await _uploadToFirestore();
  }

  _dropDownForImage() {
    return Material(
      child: Container(
        child: DropdownMenu<String>(
          initialValue: _selectedImage,
          onSelected: (item) {
            _selectedImage = item;
            setState(() {});
          },
          itemBuilder: (BuildContext context) {
            return List<PopupMenuEntry<String>>.generate(
                _imageDropDownItems.length * 2 - 1, (int index) {
              if (index.isEven) {
                final item = _imageDropDownItems[index ~/ 2];
                return DropdownMenuItemCustom<String>(value: item, text: item);
              } else {
                return DropdownDivider();
              }
            });
          },
          child: Text(_selectedImage),
        ),
      ),
    );
  }
}
