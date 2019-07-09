import 'package:cloud_firestore/cloud_firestore.dart';

class Article{
  String title,desc,author,id;
  int createdAt;

Article({this.author,this.createdAt,this.desc,this.id,this.title});

Article fromJson(DocumentSnapshot doc){
    return Article(
      author: doc['author'],
      desc: doc['desc'],
      title: doc['title'],
      createdAt: doc['createdAt'],
      id: doc['id']
    );
  }
}