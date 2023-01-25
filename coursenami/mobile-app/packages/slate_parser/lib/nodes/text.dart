import 'package:flutter/material.dart';

// returns either TextSpan or Widget(Text)
// ignore: non_constant_identifier_names
TextSlate(Map<String, dynamic> data,{ bool isRich = false }) {
  //assuming data as an object with object(String), text(String) and marks(List) properties
  var textStyle = const TextStyle();
  for (var mark in data["marks"]){
    var markType = mark["type"];
    switch (markType) {
      case "bold":
        textStyle = textStyle.copyWith(
          fontWeight: FontWeight.bold
        );
        break;
      case "italic":
        textStyle = textStyle.copyWith(
          fontStyle: FontStyle.italic
        );
        break;
      case "code":
        textStyle = textStyle.copyWith(
          backgroundColor: Colors.grey
        );
        break;
    }
  }

  if(isRich){
    return TextSpan(
      text: data["text"],
      style: textStyle,
    );
  } else {
    return Text(
    data["text"],
    style: textStyle,
  );
  }
}