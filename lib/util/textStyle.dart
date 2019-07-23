import 'package:flutter/material.dart';

class Style {
  static final baseDecoratedTextStyle =
      const TextStyle(fontFamily: 'Calibre-Semibold');
  static final regularTextStyle =
      const TextStyle(fontFamily: 'SF-Pro-Text-Regular');
  static final cardHeaderTextStyle = baseDecoratedTextStyle.copyWith(
      color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400);
  static final cardBodyTextStyle = regularTextStyle.copyWith(
      color: Color(0xFF2F363F), fontSize: 16.0, fontWeight: FontWeight.w300);
  static final detailBodyTextStyle = regularTextStyle.copyWith(
      color: Colors.brown[600], fontSize: 18.0, fontWeight: FontWeight.w200);
  static final detailHeaderTextStyle = baseDecoratedTextStyle.copyWith(
      color: Color(0xFF2B2B52), fontSize: 22.0, fontWeight: FontWeight.w600);
  static final profileNameTextStyle = baseDecoratedTextStyle.copyWith(
      color: Color(0xFF019031), fontSize: 22.0, fontWeight: FontWeight.w600);
  static final linkStyle = detailBodyTextStyle.copyWith(color: Colors.blue);
  static final highlightStyle = baseDecoratedTextStyle.copyWith(
      fontWeight: FontWeight.w500, fontSize: 20.0, color: Color(0xff37474f));
}
