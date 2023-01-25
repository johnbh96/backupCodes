import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final String text;
  final Color? color;
  const TextView({
    Key? key,
    required this.text,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
      ),
    );
  }
}
