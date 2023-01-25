import 'package:flutter/material.dart';

import 'text_view.dart';

ScaffoldMessengerState showsnackBar({
  required String message, 
  required BuildContext context,
  Color? color = Colors.grey,
}){
  return ScaffoldMessenger.of(context)
  ..removeCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: TextView(
        text: message,
        color: Colors.white,
      )
    )
  );
}
