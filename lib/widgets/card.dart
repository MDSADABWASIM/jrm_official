import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/pages/articleDetail.dart';
import 'package:jrm/util/textStyle.dart';

//builds and return card with title,image
Widget _buildCircularImage(String image) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    alignment: FractionalOffset.centerLeft,
    width: 70.0,
    height: 70.0,
    decoration: BoxDecoration(
      color: Colors.white,
      image: DecorationImage(
        fit: BoxFit.fitWidth,
        image: AssetImage(
          image,
        ),
      ),
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      border: Border.all(color: Colors.black38,width: 2),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black38,
          blurRadius: 5.0,
          offset: Offset(0.0, 10.0),
        ),
      ],
    ),
  );
}

_cardElements(String title,String desc) {
  return Container(
    margin: EdgeInsets.fromLTRB(100.0, 16.0, 16.0, 16.0),
    constraints: BoxConstraints.expand(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 4.0),
        Text(
          title,
          style: Style.cardHeaderTextStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 10.0,
        ),
          Text(
          desc,
          style: Style.cardBodyTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

final _card = Container(
  height: 100.0,
  margin: EdgeInsets.only(left: 46.0),
  decoration: BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10.0,
        offset: Offset(0.0, 10.0),
      ),
    ],
  ),
);

class Cards extends StatelessWidget {
  final DocumentSnapshot document;

  Cards({Key key, @required this.document})
      : assert(document != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardImage = _buildCircularImage(document['image']);
    final cardElements = _cardElements(document['title'],document['desc']);
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ArticleDetail(document: document))),
      child: Container(
        height: 120.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Stack(
          children: <Widget>[_card, cardImage, cardElements],
        ),
      ),
    );
  }
}
