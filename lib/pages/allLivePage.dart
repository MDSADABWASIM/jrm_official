import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jrm/widgets/liveCard.dart';

class AllLivePage extends StatefulWidget {
  @override
  _AllLivePageState createState() => _AllLivePageState();
}

class _AllLivePageState extends State<AllLivePage> {
  DocumentSnapshot _lastDocument, _firstDocument;
  final StreamController<bool> _prevStream = StreamController<bool>();
  final StreamController<bool> _fetchingStream = StreamController<bool>();
  final StreamController<bool> _moreButtonStreaam = StreamController<bool>();
  final StreamController<bool> _prevButtonStream = StreamController<bool>();
  bool _previous = false,
      _fetching = false,
      _moreButtonActive = false,
      _prevButtonActive = false;
  int length = 10;

  @override
  void initState() {
    super.initState();
    _prevStream.add(false);
    _fetchingStream.add(false);
    _moreButtonStreaam.add(true);
    _prevButtonStream.add(false);
  }

  @override
  void dispose() {
    _prevStream.close();
    _fetchingStream.close();
    _moreButtonStreaam.close();
    _prevButtonStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     if (_prevButtonActive) {
      _prevButtonStream.add(false);
    }
      _moreButtonStreaam.add(true);
    _prevStream.add(false);
    _fetchingStream.add(false);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder(
            stream: _prevButtonStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) _prevButtonActive = snapshot.data;
              return _prevButtonActive
                  ? FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.navigate_before, color: Colors.white),
                      backgroundColor: Color(0xFF1b1e44),
                      onPressed: () =>
                          _prevButtonActive ? _goToPrevPage() : SizedBox(),
                    )
                  : SizedBox();
            },
          ),
          SizedBox(height: 20),
          StreamBuilder(
            stream: _moreButtonStreaam.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) _moreButtonActive = snapshot.data;
              return _moreButtonActive
                  ? FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.navigate_next, color: Colors.white),
                      backgroundColor: Color(0xFF1b1e44),
                      onPressed: () =>
                          _moreButtonActive ? _goToNextPage() : SizedBox(),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
      appBar: AppBar(title: Text('Live')),
      body: _putInBody(),
    );
  }

  _card(DocumentSnapshot document) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        LiveCard(document: document),
      ],
    );
  }

  _fetchFromLast() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Lives')
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
          snapshot.data.documents.length < length
              ? _moreButtonStreaam.add(false)
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
          .collection('Lives')
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
              ? _prevButtonStream.add(false)
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
          .collection('Lives')
          .orderBy('createdAt', descending: true)
          .limit(length)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.data.documents.length == 0)
          return Center(child: CircularProgressIndicator());
        else
          snapshot.data.documents.length < length
              ? _moreButtonStreaam.add(false)
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
    return StreamBuilder(
      stream: _fetchingStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) _fetching = snapshot.data;
        return StreamBuilder(
          stream: _prevStream.stream,
          builder: (context, snapshot2) {
            if (snapshot2.hasData) _previous = snapshot2.data;
            if (_fetching) {
              return _fetchFromLast();
            } else if (_previous) {
              return _goToPrev();
            } else
              return _firestoreDataList();
          },
        );
      },
    );
  }

  _goToNextPage() {
    _fetchingStream.add(true);
    _prevButtonStream.add(true);
    _prevStream.add(false);
  }

  _goToPrevPage() {
    _moreButtonStreaam.add(true);
    _fetchingStream.add(false);
    _prevStream.add(true);
  }
}
