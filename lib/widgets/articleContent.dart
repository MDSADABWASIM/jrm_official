import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({
    Key key,
    @required this.document,
  }) : super(key: key);

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Linkify(
       onOpen: (link) async {
    if (await canLaunch(link.url)) {
        await launch(link.url);
      } else {
        throw 'Could not launch $link';
      }
  },
    text:document['desc'],
    style: Style.detailBodyTextStyle,
    humanize: true,
    linkStyle: Style.linkStyle,
    );
  }
}