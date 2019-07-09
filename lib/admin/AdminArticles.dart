import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jrm/widgets/adminCard.dart';

class AdminArticlesPage extends StatefulWidget {
  @override
  _AdminArticlesPageState createState() => _AdminArticlesPageState();
}

class _AdminArticlesPageState extends State<AdminArticlesPage> {
  DocumentSnapshot _lastDocument, _firstDocument;
  bool _previous = false,
      _fetching = false,
      _moreButtonActive = true,
      _prevButtonActive = false;
  int length = 10;

  @override
  Widget build(BuildContext context) {
     _previous = false;
      _fetching = false;
      _moreButtonActive = false;
      _prevButtonActive = false;
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _prevButtonActive
              ? FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.navigate_before,color: Colors.white),
                  backgroundColor:  Color(0xFF1b1e44),
                  onPressed: () =>
                      _prevButtonActive ? _goToPrevPage() : SizedBox(),
                )
              : SizedBox(),
          SizedBox(height: 20),
          _moreButtonActive
              ? FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.navigate_next,color: Colors.white),
                  backgroundColor:  Color(0xFF1b1e44),
                  onPressed: () =>
                      _moreButtonActive ? _goToNextPage() : SizedBox(),
                )
              : SizedBox(),
        ],
      ),
      appBar: AppBar(title: Text('Articles')),
      body: _putInBody(),
    );
  }

  _card(DocumentSnapshot document) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
         AdminCards(
            document: document,
          ),
      ],
    );
  }

  _fetchFromLast() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
          .orderBy('createdAt', descending: true)
          .startAfter([_lastDocument['createdAt']])
          .limit(length)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.documents.length == 0)
          return Center(child: CircularProgressIndicator());
        else
          snapshot.data.documents.length < 10
              ? _moreButtonActive = false
              : SizedBox();
        _lastDocument = snapshot.data.documents.last;
        _firstDocument = snapshot.data.documents.first;
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _card(snapshot.data.documents[index]);
            });
      },
    );
  }

  _goToPrev() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
          .orderBy('createdAt', descending: true)
          .endBefore([_firstDocument['createdAt']])
          .limit(length)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.documents.length == 0)
          return Center(child: CircularProgressIndicator());
        else
          snapshot.data.documents.length < length
              ? _prevButtonActive = false
              : SizedBox();
        _lastDocument = snapshot.data.documents.last;
        _firstDocument = snapshot.data.documents.first;

        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _card(snapshot.data.documents[index]);
            });
      },
    );
  }

  _firestoreDataList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Articles')
          .orderBy('createdAt', descending: true)
          .limit(length)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.documents.length == 0)
          return Center(child: CircularProgressIndicator());
        else
          snapshot.data.documents.length < 10
              ? _moreButtonActive = false
              : SizedBox();
        _lastDocument = snapshot.data.documents.last;
        _firstDocument = snapshot.data.documents.first;
        return new ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) =>
              _card(snapshot.data.documents[index]),
        );
      },
    );
  }

  _putInBody() {
    if (_fetching) {
      return _fetchFromLast();
    } else if (_previous) {
      return _goToPrev();
    } else
      return _firestoreDataList();
  }

  _goToNextPage() {
    setState(() {
      _fetching = true;
      _prevButtonActive = true;
      _previous = false;
    });
  }

  _goToPrevPage() {
    setState(() {
      _moreButtonActive = true;
      _fetching = false;
      _previous = true;
    });
  }
}
