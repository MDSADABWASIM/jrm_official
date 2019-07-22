import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jrm/models/fbconn.dart';
import 'package:jrm/models/data.dart';
import 'package:jrm/models/ref_time.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

class AppChat extends StatefulWidget {
  @override
  _ChatsState createState() => new _ChatsState();
}

class _ChatsState extends State<AppChat> with AfterLayoutMixin<AppChat>{
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  FbConn fbConn;

  final reference = FirebaseDatabase.instance
      .reference()
      .child(AppData.messagesDB)
      .child(AppData.id);

  BuildContext context;
  FirebaseUser user;
  String userid;
  String fullName;
  String email;
  String phone;
  String profileImgUrl;
  Timer timer;

   @override
  void afterFirstLayout(BuildContext context) {
     _getCurrentUser();
    // reference.keepSynced(true);
    _getUserMessages();
    timer = new Timer.periodic(new Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _textEditingController?.dispose();
    super.dispose();
  }

  Future _getCurrentUser() async {
      user=Provider.of<FirebaseUser>(context);
      if (user != null) {
        setState(() {
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoUrl;
          AppData.currentUserID = user.email.toLowerCase();
          AppData.id =user.uid;
          userid = user.uid;
        });
      }
  
  }

  Future _getUserMessages() async {
    final messageRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(AppData.id);

   messageRef.once().then((snapshot) {
      if (snapshot.value == null) {
        return;
      }
      Map valFav = snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      for (int s = 0; s < fbConn.getDataSize(); s++) {
        String messageKeyID = fbConn.getMessageKeyIDasList()[s];
        updateMessageSeenRead(messageKeyID);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
        appBar: new AppBar(
          brightness: Brightness.dark,
          title: new Text("Chat us"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new FirebaseAnimatedList(
                  defaultChild: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                  query: reference,
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  sort: (a, b) {
                    return b.key.compareTo(a.key);
                  },
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation animation, int index) {
                    return new ChatMessage(
                      messageSnapshot: snapshot,
                      animation: animation,
                      userid: userid,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
        ));
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
           
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child:getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    DateTime currentTime = new DateTime.now();
    int messageTime = currentTime.millisecondsSinceEpoch;
    String messageKeyID = reference.push().key;
    String lastConversationID = AppData.supportUID + userid;

    final conversationRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.conversationsDB)
        .child(lastConversationID);

    conversationRef.set({
      AppData.messageKeyID: messageKeyID,
      AppData.partyID: lastConversationID,
      AppData.messageID: userid,
      AppData.messageText: messageText,
      AppData.messageSenderEmail: email,
      AppData.messageImageUrl: imageUrl,
      AppData.messageSenderName: fullName,
      AppData.messageSenderImage: profileImgUrl == null ? "" : profileImgUrl,
      AppData.messageSenderUID: userid,
      AppData.messageReceiverUID: AppData.supportUID,
      AppData.messageSeen: false,
      AppData.messageRead: false,
      AppData.messageTime: messageTime,
    });

    reference.child(messageKeyID).set({
      AppData.messageKeyID: messageKeyID,
      AppData.messageID: userid,
      AppData.messageText: messageText,
      AppData.messageSenderEmail: email,
      AppData.messageImageUrl: imageUrl,
      AppData.messageSenderName: fullName,
      AppData.messageSenderImage: profileImgUrl == null ? "" : profileImgUrl,
      AppData.messageSenderUID: userid,
      AppData.messageReceiverUID: AppData.supportUID,
      AppData.messageSeen: false,
      AppData.messageRead: false,
      AppData.messageTime: messageTime,
    });
  }

  void updateMessageSeenRead(String messageKeyID) {

    Map<String, dynamic> seenRead = new Map();
    seenRead[AppData.messageSeen] = true;
    seenRead[AppData.messageRead] = true;

    /*FirebaseDatabase.instance
        .reference()
        .child(AppData.conversationsDB)
        .child(lastConversationID)
        .update(seenRead);*/
    FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(userid)
        .child(messageKeyID)
        .update(seenRead);
  }

 
}

class ChatMessage extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String userid;
  final TimeAgo timeAgo = new TimeAgo();

  ChatMessage({this.messageSnapshot, this.animation, this.userid});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: userid == messageSnapshot.value[AppData.messageSenderUID]
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
          child: new Container(
        margin: new EdgeInsets.only(left: 120.0),
        padding: const EdgeInsets.all(8.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topRight: new Radius.circular(25.0),
            topLeft: new Radius.circular(10.0),
            bottomLeft: new Radius.circular(10.0),
            bottomRight: new Radius.circular(0.0),
          ),
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(messageSnapshot.value[AppData.messageSenderName],
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: messageSnapshot.value[AppData.messageImageUrl] !=
                            null
                        ? new Image.network(
                            messageSnapshot.value[AppData.messageImageUrl],
                            width: 200.0,
                          )
                        : new Text(messageSnapshot.value[AppData.messageText]),
                  ),
                  new Text(
                      timeAgo.timeUpdater(
                          new DateTime.fromMillisecondsSinceEpoch(
                              messageSnapshot.value[AppData.messageTime])),
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w100)),
                ],
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: messageSnapshot.value[AppData.messageSenderImage] == ""
                      ? new CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              new AssetImage("assets/other.png"),
                        )
                      : new CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: new NetworkImage(messageSnapshot
                              .value[AppData.messageSenderImage]),
                        ),
                ),
              ],
            )
          ],
        ),
      ))
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Expanded(
          child: new Container(
        padding: const EdgeInsets.all(8.0),
        margin: new EdgeInsets.only(right: 120.0),
        decoration: new BoxDecoration(
            color: Colors.pink[900],
            borderRadius: new BorderRadius.only(
              topRight: new Radius.circular(10.0),
              topLeft: new Radius.circular(25.0),
              bottomRight: new Radius.circular(10.0),
              bottomLeft: new Radius.circular(0.0),
            )),
        child: new Row(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: messageSnapshot.value[AppData.messageSenderImage] == ""
                      ? new CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              new AssetImage("assets/other.png"),
                        )
                      : new CircleAvatar(
                          backgroundColor: Colors.pink[900],
                          backgroundImage: new NetworkImage(messageSnapshot
                              .value[AppData.messageSenderImage]),
                        ),
                ),
              ],
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(messageSnapshot.value[AppData.messageSenderName],
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child:
                        messageSnapshot.value[AppData.messageImageUrl] != null
                            ? new Image.network(
                                messageSnapshot.value[AppData.messageImageUrl],
                                width: 200.0,
                              )
                            : new Text(
                                messageSnapshot.value[AppData.messageText],
                                style: new TextStyle(color: Colors.white),
                              ),
                  ),
                  new Text(
                      timeAgo.timeUpdater(
                          new DateTime.fromMillisecondsSinceEpoch(
                              messageSnapshot.value[AppData.messageTime])),
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100)),
                ],
              ),
            ),
          ],
        ),
      ))
    ];
  }
}