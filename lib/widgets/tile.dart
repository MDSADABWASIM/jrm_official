import 'package:flutter/material.dart';

Widget buildTile(
    BuildContext context, Color color, Color splashColor, Widget child,
    {Function() onTap}) {
  return Container(
    margin: EdgeInsets.all(5.0),
    child: Material(
      color: color,
      elevation: 10.0,
      borderRadius: BorderRadius.circular(15.0),
      shadowColor: Color(0x801c313a),
      child: InkWell(
        onTap: onTap != null
            ? () => onTap()
            : () {
                print('Nothing set yet!');
              },
        child: child,
        splashColor: splashColor, //additional parameters to customize the
        // colors on a per-tile basis
      ),
    ),
  );
}