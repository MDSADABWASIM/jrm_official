import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/models/data.dart';
import 'package:jrm/models/ref_time.dart';

class AdminChats extends StatefulWidget {
  final String senderUID;
  final String senderName;
  final String senderImage;
  final String senderEmail;
  final String messageID;
  final String messageKeyID;

  AdminChats(
      {this.senderUID,
      this.senderName,
      this.senderImage,
      this.senderEmail,
      this.messageID,
      this.messageKeyID});

  @override
  _AdminChatsState createState() => _AdminChatsState();
}

class _AdminChatsState extends State<AdminChats> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposingMessage = false;
  BuildContext context;
  String supportUID = "08143733836Jrm";
  String fullName = "Jrm Support";
  String email = "jrm78692@gmail.com";
  String phone = "8210296495";
  String profileImgUrl =
      "https://cdn1.iconfinder.com/data/icons/user-avatar-2/57/User-check-512.png";

  @override
  void initState() {
    updateMessageSeenRead();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    print(widget.senderUID);
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text("Chats"),
          elevation: 4.0,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                child: FirebaseAnimatedList(
                  defaultChild: Center(
                    child: CircularProgressIndicator(),
                  ),
                  query: FirebaseDatabase.instance
                      .reference()
                      .child(AppData.messagesDB)
                      .child(widget.messageID),
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  sort: (a, b) {
                    return b.key.compareTo(a.key);
                  },
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation animation, int index) {
                    return ChatMessage(
                      messageSnapshot: snapshot,
                      animation: animation,
                      userid: supportUID,
                    );
                  },
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              Builder(builder: (BuildContext context) {
                return Container(width: 0.0, height: 0.0);
              })
            ],
          ),
        ));
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              
              Flexible(
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                      InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
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
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(widget.messageID);

    DateTime currentTime = DateTime.now();
    int messageTime = currentTime.millisecondsSinceEpoch;
    String messageKeyID = reference.push().key;
    String lastConversationID = AppData.supportUID + widget.senderUID;

    final conversationRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.conversationsDB)
        .child(lastConversationID);

    conversationRef.set({
      AppData.messageKeyID: messageKeyID,
      AppData.partyID: lastConversationID,
      AppData.messageID: widget.messageID,
      AppData.messageText: messageText,
      AppData.messageSenderEmail: widget.senderEmail,
      AppData.messageImageUrl: imageUrl,
      AppData.messageSenderName: widget.senderName,
      AppData.messageSenderImage: widget.senderImage,
      AppData.messageSenderUID: widget.senderUID,
      AppData.messageReceiverUID: AppData.supportUID,
      AppData.messageSeen: false,
      AppData.messageRead: false,
      AppData.messageTime: messageTime,
    });

    reference.child(messageKeyID).set({
      AppData.messageKeyID: messageKeyID,
      AppData.messageID: widget.messageID,
      AppData.messageText: messageText,
      AppData.messageSenderEmail: email,
      AppData.messageImageUrl: imageUrl,
      AppData.messageSenderName: fullName,
      AppData.messageSenderImage: profileImgUrl,
      AppData.messageSenderUID: AppData.supportUID,
      AppData.messageReceiverUID: widget.senderUID,
      AppData.messageSeen: false,
      AppData.messageRead: false,
      AppData.messageTime: messageTime,
    });
  }

  void updateMessageSeenRead() {
    String lastConversationID = AppData.supportUID + widget.messageID;

    Map<String, dynamic> seenRead = Map();
    seenRead[AppData.messageSeen] = true;
    seenRead[AppData.messageRead] = true;

    FirebaseDatabase.instance
        .reference()
        .child(AppData.conversationsDB)
        .child(lastConversationID)
        .update(seenRead);

    FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(widget.messageID)
        .child(widget.messageKeyID)
        .update(seenRead);
  }
}

class ChatMessage extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String userid;
  final TimeAgo timeAgo = TimeAgo();

  ChatMessage({this.messageSnapshot, this.animation, this.userid});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: userid == messageSnapshot.value[AppData.messageSenderUID]
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      Expanded(
          child: Container(
        margin: EdgeInsets.only(left: 120.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(0.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(messageSnapshot.value[AppData.messageSenderName],
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: messageSnapshot.value[AppData.messageImageUrl] !=
                                  null ||
                              messageSnapshot.value[AppData.messageImageUrl] ==
                                  ""
                          ? Image.network(
                              messageSnapshot.value[AppData.messageImageUrl],
                              width: 200.0,
                            )
                          : Text(messageSnapshot.value[AppData.messageText])),
                  Text(
                      timeAgo.timeUpdater(DateTime.fromMillisecondsSinceEpoch(
                          messageSnapshot.value[AppData.messageTime])),
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w100)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: messageSnapshot.value[AppData.messageImageUrl] ==
                                "" ||
                            messageSnapshot.value[AppData.messageImageUrl] ==
                                null
                        ? CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(messageSnapshot
                                .value[AppData.messageSenderImage]),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("assets/other.png"),
                          )),
              ],
            )
          ],
        ),
      ))
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      Expanded(
          child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(right: 120.0),
        decoration: BoxDecoration(
            color: Colors.pink[900],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              topLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(10.0),
              bottomLeft: Radius.circular(0.0),
            )),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: messageSnapshot.value[AppData.messageImageUrl] ==
                                "" ||
                            messageSnapshot.value[AppData.messageImageUrl] ==
                                null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage("assets/other.png"),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(messageSnapshot
                                .value[AppData.messageSenderImage]),
                          )),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(messageSnapshot.value[AppData.messageSenderName],
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child:
                        messageSnapshot.value[AppData.messageImageUrl] != null
                            ? Image.network(
                                messageSnapshot.value[AppData.messageImageUrl],
                                width: 200.0,
                              )
                            : Text(
                                messageSnapshot.value[AppData.messageText],
                                style: TextStyle(color: Colors.white),
                              ),
                  ),
                  Text(
                      timeAgo.timeUpdater(DateTime.fromMillisecondsSinceEpoch(
                          messageSnapshot.value[AppData.messageTime])),
                      style: TextStyle(
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
