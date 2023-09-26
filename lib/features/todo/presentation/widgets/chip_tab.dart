import 'package:flutter/material.dart';

import '../../../../constants.dart';

class ChipTab extends StatelessWidget {
  final bool isActive;
  final String text;
  const ChipTab({super.key, required this.isActive, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: greyColor,
          gradient: isActive ? primaryGradient : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3))
                ]
              : null,
          borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: !isActive ? Colors.grey : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
