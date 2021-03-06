import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:url_launcher/url_launcher.dart';

  String _date(int date){
DateTime now=DateTime.fromMillisecondsSinceEpoch(date);
String newDate= ('${now.day}/${now.month}/${now.year}');
return newDate;
}


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
      // border: Border.all(color: Colors.black38,width: 2),
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

_cardElements(String title,date) {
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
        Text('Date: $date',overflow: TextOverflow.ellipsis),
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

class AdminLiveCards extends StatelessWidget {
  final DocumentSnapshot document;

  AdminLiveCards({Key key, @required this.document})
      : assert(document != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final date=_date(document['createdAt']);
    final cardImage = _buildCircularImage(document['image']);
    final cardElements = _cardElements(document['title'],date);
    final url = document['url'];
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(context, document['id']),
      onTap: () async {
        if (await canLaunch(url)) launch(url);
      },
      child: Container(
        height: 120.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Stack(
          children: <Widget>[_card, cardImage, cardElements],
        ),
      ),
    );
  }

  _showDeleteDialog(BuildContext context, String id) {
    AlertDialog alert = AlertDialog(
      title: Text("Delete this Live?"),
      content: Text("Deleting this live will delete this from everywhere."),
      actions: [
        RaisedButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          shape: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        RaisedButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await _deleteCampaign(id, context);
          },
          shape: OutlineInputBorder(borderSide: BorderSide.none),
          color: Colors.red[300],
        )
      ],
    );

    return showDialog(context: context, builder: (context) => alert);
  }

  _deleteCampaign(String id, BuildContext context) async {
    await Firestore.instance
        .collection('Lives')
        .document('$id')
        .delete()
        .whenComplete(() => Navigator.pop(context));
  }
}
