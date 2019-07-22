import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/admin/branchDetail.dart';
import 'package:jrm/util/textStyle.dart';



String _date(int date){
DateTime now=DateTime.fromMillisecondsSinceEpoch(date);
String newDate= ('${now.day}/${now.month}/${now.year}');
return newDate;
}


_cardElements(String title,String date) {
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
       Text('Requested on: $date',overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}

final _card = Container(
  height: 100.0,
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
     final date=_date(document['createdAt']);
    final cardElements = _cardElements(document['branchType'],date);
    return GestureDetector(
      onLongPress: ()=>_showDeleteDialog(context, document['id']),
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


  _showDeleteDialog(BuildContext context,String id) {
   AlertDialog  alert= AlertDialog(
      title: Text("Delete this Branch request?"),
      content: Text("Deleting this article will delete this from everywhere."),
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
          onPressed: () async{
            Navigator.of(context).pop();
           await _deleteCampaign(id,context);
             },
          shape: OutlineInputBorder(borderSide: BorderSide.none),
          color: Colors.red[300],
        )
      ],
    );

  return showDialog(
     context: context,
     builder: (context)=>alert
   );
   }

  _deleteCampaign(String id,BuildContext context) async {
     await Firestore.instance
        .collection('Branch')
        .document('$id')
        .delete()
      .whenComplete(() => Navigator.pop(context));
    }
}
