import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const activeDurationInSec = 10;
const primaryColor = Color(0xffeaedff);
const secondaryColor = Color(0xffdde0e5);
const highlightColor = Color(0xff9d959d);
const greyColor = Color(0xfff8f8f8);
const darkColor = Color(0xff000000);
const primaryGradient = LinearGradient(
  colors: [
    Color(0xff9cc0ff),
    Color(0xff97a6fe),
  ],
  stops: [
    0.2,
    0.7,
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
String formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final difference = date.difference(now).inDays;
  final isYesterday = (difference <= 1 && difference >= -1) &&
          (date.day == DateTime.now().subtract(const Duration(days: 1)).day)
      ? true
      : false;
  final isTomorrow = (difference <= 1 && difference >= -1) &&
          (date.day == DateTime.now().add(const Duration(days: 1)).day)
      ? true
      : false;
  if (isYesterday) return "Yesterday";
  if (isTomorrow) return "Tomorrow";
  final dateFormat = DateFormat('MMMM d, y');
  return dateFormat.format(date);
}
