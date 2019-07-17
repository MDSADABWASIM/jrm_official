import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/admin/AdminAddArticle.dart';
import 'package:jrm/admin/AdminAddLive.dart';
import 'package:jrm/admin/AdminArticles.dart';
import 'package:jrm/admin/AdminLives.dart';
import 'package:jrm/admin/AdminTimings.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  final _divider = const Divider(color: Colors.grey, height: 10.0);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Admin'),
      ),
      body: _adminHome(context),
    );
  }

  _adminHome(BuildContext context) {
    return ListView(padding: EdgeInsets.all(8), children: [
      _listTile(Icons.chat, 'Articles', AdminArticlesPage(), context),
      _divider,
        _listTile(Icons.chat, 'Lives', AdminLivePage(), context),
      _divider,
      _listTile(Icons.people, 'Write Article', PostArticle(), context),
      _divider,
        _listTile(Icons.chat, 'Post Live', PostLive(), context),
      _divider,
      _listTile(Icons.people, 'Post Azan Timings', PostTimings(), context),
      _divider,
      SizedBox(height: 20),
    ]);
  }

  Widget _listTile(
      IconData icon, String name, Widget className, BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: Icon(
        icon,
        color: Colors.green,
      ),
      onTap: () => _navigateTo(context, className),
    );
  }

  void _navigateTo(BuildContext context, Widget name) async {
    var result = await Navigator.push(
        context, CupertinoPageRoute(builder: (BuildContext context) => name));
    if (result == 'success') {
      showInSnackBar('Successfully Added', Colors.green[400]);
    }
  }

  void showInSnackBar(String value,  Color color) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: "Calibre-Semibold"),
      ),
      backgroundColor: color == null ? Colors.red[300] : color,
      duration: Duration(seconds: 2),
    ));
  }
}
