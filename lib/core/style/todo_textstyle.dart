import 'package:flutter/material.dart';
import 'package:todo/constants.dart';

extension TodoTextColorExt on String {
  TodoTextColor get h1 => TodoTextStyle.h1(this);
  TodoTextColor get h2 => TodoTextStyle.h2(this);
  TodoTextColor get h3 => TodoTextStyle.h3(this);
  TodoTextColor get p => TodoTextStyle.p(this);
  TodoTextColor get pBold => TodoTextStyle.pBold(this);
}

extension TodoTextExt on TodoTextColor {
  Widget get highlightColor => Text(
        text,
        style: highlight,
      );
  Widget get blackColor => Text(
        text,
        style: black,
      );
}

class TodoTextStyle {
  static TodoTextColor h1(String text) => TodoTextColor(
      const TextStyle(
          fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
      text);

  static TodoTextColor h2(String text) => TodoTextColor(
      const TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
      text);
  static TodoTextColor h3(String text) => TodoTextColor(
      const TextStyle(
          fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
      text);
  static TodoTextColor p(String text) =>
      TodoTextColor(const TextStyle(fontFamily: 'montserrat'), text);
  static TodoTextColor pBold(String text) => TodoTextColor(
      const TextStyle(
          fontFamily: 'montserrat', fontWeight: FontWeight.bold, fontSize: 20),
      text);
}

class TodoTextColor {
  final TextStyle style;
  final String text;
  TodoTextColor(this.style, this.text);

  TextStyle get highlight => style.copyWith(color: highlightColor);

  TextStyle get black => style.copyWith(color: darkColor);
}
