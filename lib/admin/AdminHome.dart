import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jrm/admin/AdminAddArticle.dart';
import 'package:jrm/admin/AdminArticles.dart';


class AdminHomepage extends StatelessWidget {
  final _divider = const Divider(color: Colors.grey, height: 10.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Admin'),
      ),
      body: _adminHome(context),
    );
  }

  _adminHome(BuildContext context) {  
    return ListView(
      padding: EdgeInsets.all(8),
       children: [
         _listTile(Icons.chat, 'Articles', AdminArticlesPage(), context),
    _divider,
    _listTile(Icons.people, 'Write Article', PostArticle(), context),
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

  void _navigateTo(BuildContext context, Widget name) {
    Navigator.push(
        context, CupertinoPageRoute(builder: (BuildContext context) => name));
  }
}
