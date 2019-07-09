import 'package:flutter/material.dart';

class ArticleHeader extends StatefulWidget {
  final String image;
  final String id;

  ArticleHeader({this.image,this.id});
  @override
  _ArticleHeaderState createState() => _ArticleHeaderState();
}

class _ArticleHeaderState extends State<ArticleHeader> {


  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.blue[100],
      pinned: true,
      expandedHeight: 300,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color:  Colors.white ,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Article detail'),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag:widget.id,
          child:  Container(
            margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                   image: DecorationImage(image: AssetImage(widget.image)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                )
             
        ),
      ),
    );
  }
}