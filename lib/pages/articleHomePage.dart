import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jrm/chat/app_chat.dart';
import 'package:jrm/models/data.dart';
import 'package:jrm/models/fbconn.dart';
import 'package:jrm/pages/allArticlesPage.dart';
import 'package:jrm/pages/allLivePage.dart';
import 'package:jrm/pages/articleDetail.dart';
import 'package:jrm/pages/settings.dart';
import 'package:jrm/pages/shajraList.dart';
import 'package:jrm/widgets/aboutDev.dart';
import 'package:jrm/widgets/aboutJrm.dart';
import 'package:residemenu/residemenu.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class ArticleHomePage extends StatefulWidget {
  @override
  _ArticleHomePageState createState() => _ArticleHomePageState();
}

class _ArticleHomePageState extends State<ArticleHomePage>
    with TickerProviderStateMixin {
  MenuController _menuController;
  var query, liveQuery;
  int msgCount = 0;
  List<DocumentSnapshot> documents = [];
  PageController controller;

  double currentPage = 0;
  int length;

  _sharer() {
    Share.share("Jamaat Raza-E-Mustafa official app\n" +
        "The app that will help you in every aspect of your islamic life \n"
            "Download it now\n"
            "https://play.google.com/store/apps/details?id=jrm.com");
  }

  @override
  void initState() {
    query = Firestore.instance
        .collection('Articles')
        .limit(10)
        .orderBy('createdAt', descending: true);
    liveQuery = Firestore.instance
        .collection('Lives')
        .limit(1)
        .orderBy('createdAt', descending: true);
    _menuController = new MenuController(vsync: this);
    controller = PageController(initialPage: documents.length - 1);
    controller.addListener(() {
      double next = controller.page;
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  _getUnReadMSG();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new ResideMenu.scaffold(
      decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/kaaba.png"), fit: BoxFit.cover)),
      controller: _menuController,
      leftScaffold: _menuScaffold(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Color(0xFF1b1e44),
              Color(0xFF2d3447),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: StreamBuilder(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.documents.length != null) {
                  documents = snapshot.data.documents;
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 15.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.sort,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  _menuController.openMenu(true);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => AllArticlesPage(),
                                  ));
                                },
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Articles",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40.0,
                                    fontFamily: "Calibre-Semibold",
                                    letterSpacing: 1.0,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFff6e6e),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 22.0, vertical: 6.0),
                                    child: Text("New",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => AllArticlesPage(),
                                  ));
                                },
                                child: Text("see more",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 16)),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            CardScrollWidget(currentPage, documents),
                            Positioned.fill(
                              child: PageView.builder(
                                itemCount: documents.length,
                                controller: controller,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: RaisedButton(
                              splashColor: Colors.yellow,
                              onPressed: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => ArticleDetail(
                                    document:
                                        documents[currentPage.round().toInt()],
                                  ),
                                ));
                              },
                              child: Text("Read this article",
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.blueAccent,
                              shape: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        StreamBuilder(
                          stream: liveQuery.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data.documents.length != null) {
                              DocumentSnapshot snap =
                                  snapshot.data.documents[0];
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(' Live ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40.0,
                                              fontFamily: "Calibre-Semibold",
                                              letterSpacing: 1.0,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFff6e6e),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 22.0,
                                                  vertical: 6.0),
                                              child: Text("Latest",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(CupertinoPageRoute(
                                              builder: (context) =>
                                                  AllLivePage(),
                                            ));
                                          },
                                          child: Text("see more",
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 16)),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  GestureDetector(
                                    onTap: () async{
                                      if (await canLaunch(snap['url']))
                                        launch(snap['url']);
                                    },
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Container(
                                            height: 300,
                                            width: 250,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(3.0, 6.0),
                                                      blurRadius: 10.0)
                                                ]),
                                            child: AspectRatio(
                                              aspectRatio: cardAspectRatio,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  Image.asset(snap['image'],
                                                      fit: BoxFit.none),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                          child: Text(
                                                              snap['title'],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25.0,
                                                              )),
                                                        ),
                                                        SizedBox(height: 20.0),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else
                              return Center(child: CircularProgressIndicator());
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            )),
      ),
    );
  }

MenuScaffold _menuScaffold(){
  return new MenuScaffold(
        header: new ConstrainedBox(
          constraints: new BoxConstraints(maxHeight: 80.0, maxWidth: 100.0),
          child: new CircleAvatar(
            backgroundImage: new AssetImage('assets/other.png'),
            radius: 30.0,
          ),
        ),
        children: <Widget>[
          new Material(
            color: Colors.black,
            child: new InkWell(
              child: ResideMenuItem(
                title: 'Settings',
                icon: const Icon(Icons.settings, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => Setting(),
                ));
              },
            ),
          ),
           new Material(
              color: Colors.black,
            child: new InkWell(
              child: ResideMenuItem(
                title: 'Shajra List',
                icon: const Icon(Icons.library_books, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => Shajra(),
                ));
              },
            ),
          ),
          new Material(
             color: Colors.black,
            child: new InkWell(
              child: ResideMenuItem(
                title: 'About App Dev',
                icon: const Icon(Icons.person_outline, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AboutDev(),
                ));
              },
            ),
          ),
         new Material(
              color: Colors.black,
            child: new InkWell(
              child: ResideMenuItem(
                title: 'About JRM',
                icon: const Icon(Icons.location_city, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AboutJrm(),
                ));}
            ),
          ),
         new Material(
              color: Colors.black,
            child: new InkWell(
              child: ResideMenuItem(
                title: 'Share the App',
                icon: const Icon(Icons.share, color: Colors.white),
              ),
              onTap: () => _sharer(),
            ),
          ),
             ListTile(
            title: Row(children: [
              Text("Messages"),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.yellow[400],
                    child: Text(
                      msgCount.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 12.0),
                    )),
              )
            ]),
            onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AppChat(),
                ));}
             ),
        ],
      );
}

 _getUnReadMSG() async {
    final msgRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(AppData.id);

    msgRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        msgCount = 0;
        return;
      }
      Map valFav = event.snapshot.value;
      FbConn fbConn = FbConn(valFav);
      for (int s = 0; s < fbConn.getDataSize(); s++) {
        if (fbConn.getMessageRead()[s] == false &&
            fbConn.getMessageSenderIDasList()[s] != AppData.currentUserID) {
          msgCount = msgCount + 1;
        }
      }

      if (msgCount > 0) {
      }
    });
  }
    }

class CardScrollWidget extends StatelessWidget {
  final currentPage;
  final List<DocumentSnapshot> docs;
  final padding = 20.0;
  final verticalInset = 20.0;

  CardScrollWidget(this.currentPage, this.docs);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < docs.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(docs[i]['image'], fit: BoxFit.none),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(docs[i]['title'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  )),
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
