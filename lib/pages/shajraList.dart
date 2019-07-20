import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Shajra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shajra List'),centerTitle: true,),
      body: _putInBody(),
    );
  }

  _putInBody(){
    return GridView.count(
     padding: EdgeInsets.all(8),
      crossAxisCount: 1,
      children: <Widget>[
          _tile('https://www.jamatrazaemustafa.org/docs/Shajra-Shareef-Hindi.pdf','Shajra sharif in hindi','https://www.jamatrazaemustafa.org/docs/shijrahindi.jpg'),
          _tile('https://www.jamatrazaemustafa.org/docs/SHIJRA-SHARIF-English.pdf','Shajra sharif in english','https://www.jamatrazaemustafa.org/docs/shijraenglish.jpg'),
      ],
    );
  }

  _tile(String url,title,image){
    return  GestureDetector(
                                    onTap: () async {
                                      if (await canLaunch(url))
                                        launch(url);
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Container(
                                            height: 300,
                                            width: 250,
                                            decoration: BoxDecoration(
                                                color: Colors.blue[300],
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(3.0, 6.0),
                                                      blurRadius: 10.0)
                                                ]),
                                            child: AspectRatio(
                                              aspectRatio: 12.0 / 16.0,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  FadeInImage.assetNetwork(
                                                    placeholder: 'assets/quran.png',
                                                    image: image,
                                                      fit: BoxFit.contain),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
  }

}