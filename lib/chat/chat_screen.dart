import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/chat/support_chat.dart';
import 'package:jrm/models/fbconn.dart';
import 'package:jrm/models/data.dart';
import 'package:jrm/models/ref_time.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  FbConn fbConn;
  FbConn fbConnMessages;
  TimeAgo timeAgoo = TimeAgo();
  StreamSubscription<Event> _messageSubscription;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext context;
  String userid;
  String fullName;
  String email;
  String phone;
  String profileImgUrl;
  bool isLoggedIn;
  Timer timer;

  List<String> userIDS = List();

  @override
  void initState() {
    _getUserMessages();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    _messageSubscription?.cancel();
    super.dispose();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor:Colors.green,
        content: Text(value, style: TextStyle(color: Colors.white))));
  }

  Future _getUserMessages() async {
    final messageRef =
        FirebaseDatabase.instance.reference().child(AppData.conversationsDB);

    _messageSubscription = messageRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        fbConn = null;
        return;
      }
      Map valFav = event.snapshot.value;
      fbConn = FbConn(valFav);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    var streamBuilder = StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.conversationsDB)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          if (map != null) {
            FbConn fbconn = FbConn(map);
            int length = map.keys.length;

            final firstList = ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: length,
              itemBuilder: (context, index) {
                final row = GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPress: listAlertDialog,
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (BuildContext context) => AdminChats(
                              senderUID: fbconn.getMessageSenderIDasList()[
                                  fbconn.getDataSize() - index - 1],
                              senderImage: fbconn.getSenderImageAsList()[
                                  fbconn.getDataSize() - index - 1],
                              senderEmail: fbconn.getSenderEmailAsList()[
                                  fbconn.getDataSize() - index - 1],
                              senderName: fbconn.getMessageSenderNameAsList()[
                                  fbconn.getDataSize() - index - 1],
                              messageID: fbconn.getMessageIDasList()[
                                  fbconn.getDataSize() - index - 1],
                              messageKeyID: fbconn.getMessageKeyIDasList()[
                                  fbconn.getDataSize() - index - 1],
                            )));
                  },
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                      child: Row(
                        children: <Widget>[
                          fbconn.getSenderImageAsList()[
                                      fbconn.getDataSize() - index - 1] ==
                                  ""
                              ? Container(
                                  height: 60.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/other.png"))),
                                )
                              : Container(
                                  height: 60.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            fbconn.getSenderImageAsList()[
                                                length - index - 1])),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(fbconn.getMessageSenderNameAsList()[
                                              length - index - 1] ??
                                          ''),
                                      const Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0)),
                                      Text(
                                        timeAgoo.timeUpdater(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                fbconn.getMessageTimeAsList()[
                                                    length - index - 1])),
                                        style: TextStyle(
                                          color: Colors.pink[400],
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  fbconn.getMessageRead()[length - index - 1] ==
                                          false
                                      ? Text(
                                          fbconn.getMessageTextAsList()[
                                              length - index - 1],
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.pink[900],
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400))
                                      : Text(
                                          fbconn.getMessageTextAsList()[
                                              length - index - 1],
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Color(0xFF8E8E93),
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w300,
                                          )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                return Container(
                  margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      row,
                      Container(
                        height: 1.0,
                        color: Colors.black12.withAlpha(10),
                      ),
                    ],
                  ),
                );
              },
            );

            return firstList;
          } else
            return SizedBox();
        } else if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxHeight: 500.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 00.0, bottom: 0.0),
                    height: 150.0,
                    width: 150.0,
                    child: Image.asset('assets/nointernet.png')),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "No internet access.",
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
              ],
            )),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Chats'),centerTitle: true,),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: streamBuilder,
    );
  }

  var listDialog = SimpleDialog(
    //title: const Text('Select assignment'),
    children: <Widget>[
      SimpleDialogOption(
        onPressed: () {},
        child: const Text('Copy'),
      ),
      Divider(),
      SimpleDialogOption(
        onPressed: () {},
        child: const Text('Edit'),
      ),
      Divider(),
      SimpleDialogOption(
        onPressed: () {},
        child: const Text('Hide'),
      ),
      Divider(),
      SimpleDialogOption(
        onPressed: () {},
        child: const Text('Delete'),
      ),
    ],
  );

  listAlertDialog() {
    return showDialog(context: context, builder: (context) => listDialog);
  }
}
