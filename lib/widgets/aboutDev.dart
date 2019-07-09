import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jrm/util/app_colors.dart';
import 'package:jrm/util/textStyle.dart';
import 'package:jrm/widgets/tile.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutDev extends StatefulWidget {
  @override
  _AboutDevState createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  List<String> itemContent = [
    'Assalam-o-Alaikum,\nMy name is Mohammad sadab wasim, I am an android app developer, I have published  many apps in playstore till now. If you have any business/organization/ideas  and you want to build an app for it, then feel free to contact me, I will build the app in the lowest price possible, and if your organisation is a Non profit organisation then I will even do it for free. ' +
        '\n\nThanks!',
  ]; //the text in the tile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 50.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(EvaIcons.arrowIosBack),
                    tooltip: 'Go back',
                    color: white,
                    iconSize: 26.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'About app devloper',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
                        fontStyle: FontStyle.normal,
                        color: white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StaggeredGridView.count(
                crossAxisCount: 2,
                children: <Widget>[
                  Hero(
                    tag: 'tile2',
                    child: buildTile(
                      context,
                      null,
                      accentColor,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/other.png')))),
                          SizedBox(
                            height: 25.0,
                          ),
                          Text(
                            'Mohammad Sadab Wasim',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22.0,
                                color: black),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  EvaIcons.messageSquareOutline,
                                  color: Color(0xff00c853),
                                  size: 24.0,
                                ),
                                onPressed: () => launchURL(
                                    'https://api.whatsapp.com/send?phone=+918210296495'),
                              ),
                              IconButton(
                                icon: Icon(
                                  EvaIcons.emailOutline,
                                  color: Color(0xffd50000),
                                  size: 26.0,
                                ),
                                onPressed: () => launchURL(
                                    'mailto:indiancoder001@gmail.com?subject= For business queries'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                  buildTile(
                    context,
                    null,
                    accentColor,
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'About me',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: dark),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              itemContent[0],
                              style: Style.highlightStyle,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 270.0),
                  StaggeredTile.extent(2, 480.0),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        child: Icon(
          EvaIcons.messageSquareOutline,
          color: Colors.green,
          size: 36.0,
        ),
        tooltip: 'message on whatsapp',
        foregroundColor: black,
        backgroundColor: white,
        elevation: 5.0,
        onPressed: () =>
            launchURL('https://api.whatsapp.com/send?phone=+918210296495'),
      ),
    );
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    print('Launching $url...');
    await launch(url);
  } else {
    print('Error launching $url!');
  }
} //opens a custom url in the system browser
