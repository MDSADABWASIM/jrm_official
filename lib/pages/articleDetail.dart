import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:jrm/widgets/articleContent.dart';
import 'package:jrm/widgets/articleHeader.dart';
import 'package:share/share.dart';

class ArticleDetail extends StatefulWidget {
  final DocumentSnapshot document;
  ArticleDetail({this.document});

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  _sharer() {
    Share.share(
        "Read \"${widget.document['title']}\"  written  by  ${widget.document['author']}\n" +
            "Download the official JRM app now\n"
                "https://play.google.com/store/apps/details?id=jrm.com");
  }

  String _date(int date) {
    DateTime now = DateTime.fromMillisecondsSinceEpoch(date);
    String newDate = ('${now.day}/${now.month}/${now.year}');
    return newDate;
  }

  Widget buildTitleText() {
    String date = _date(widget.document['createdAt']);
    return Column(children: [
      Text(widget.document['title'],
          textAlign: TextAlign.center, style: Style.detailHeaderTextStyle),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
       dateWidget(date),
       authorWidget(widget.document['author']),
     shareWidget()
      ]),
    ]);
  }

  dateWidget(String date) {
   return  Row(
      children: <Widget>[
        Icon(EvaIcons.calendarOutline),
        SizedBox(width: 5),
        Text(date, textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
      ],
    );
  }

   authorWidget(String author) {
   return  Row(
      children: <Widget>[
        Icon(EvaIcons.edit2Outline),
        SizedBox(width: 5),
         Text(author, textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
      ],
    );
  }

  shareWidget() {
   return  GestureDetector(
     onTap: ()=>_sharer(),
        child: Row(
        children: <Widget>[
         Icon(EvaIcons.shareOutline,),
          SizedBox(width: 5),
           Text('share', textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
        ],
      ),
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              ArticleHeader(
                image: widget.document['image'],
                id: widget.document['id'],
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                   
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        buildTitleText(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: 200,
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ArticleContent(document: widget.document),
                        SizedBox(height: 80),
                      ],
                    ),
                  )
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
