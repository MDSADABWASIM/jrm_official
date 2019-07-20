import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/admin/branchDetail.dart';
import 'package:jrm/pages/articleDetail.dart';
import 'package:jrm/util/textStyle.dart';

_cardElements(String title,String desc) {
  return Container(
    margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
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

class BranchCard extends StatelessWidget {
  final DocumentSnapshot document;

  BranchCard({Key key, @required this.document})
      : assert(document != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardElements = _cardElements(document['title'],document['desc']);
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => BranchDetails(document: document))),
      child: Container(
        height: 120.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Stack(
          children: <Widget>[_card, cardElements],
        ),
      ),
    );
  }
}
