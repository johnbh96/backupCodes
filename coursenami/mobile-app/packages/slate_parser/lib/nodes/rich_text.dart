
import 'package:flutter/material.dart';
import 'package:slate_parser/nodes/text.dart';

// ignore: non_constant_identifier_names
RichTextSlate(slatejson, {bool isBlockQuote = false}) {
  var children = <TextSpan>[];
  for ( Map<String, dynamic> node in slatejson["nodes"]){
    children.add(
      TextSlate(node, isRich: true)
    );
  }
  var text =  RichText(
    text: TextSpan(
      children: children
    )
  );
  if(isBlockQuote){
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(4),
      child: text,
    );
  } else { return text; }
}
