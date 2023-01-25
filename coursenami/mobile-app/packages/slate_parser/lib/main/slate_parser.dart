library slate_parser;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slate_parser/nodes/rich_text.dart';

part 'slate_parser.builder.dart';

const basePath = 'assets/sample_slate';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

getSampleSlate() async {
  var simpleSlate = await rootBundle.loadString('$basePath/simple_slate.json');
  Map<String, String> slateData = jsonDecode(simpleSlate);
  var slateRepresentation = _representor(slateData);
}

getSlatePage() {}

Widget _representor(Map<String, dynamic> slatejson) {
  Widget widget = Container();
  widget = _selector(slatejson, widget);
  return widget;
}

_selector(Map<String, dynamic> slatejson, Widget? widget) {
  var outmostType = slatejson.keys.firstWhere((element) => element == "object");
  switch (outmostType) {
    case 'document':
      widget = _loopSelector(slatejson, widget);
      break;
    case 'block':
      _blockSelector(slatejson);
      break;
    case 'text':
      // var text_widget = TextSlate(slatejson);
      break;
    // assuming value only has another entry with the actual data like text, paragraph and block-quote
    case 'value':
      _selector(
          slatejson.entries
              .firstWhere((element) => element.value != "object")
              .value,
          widget);
      break;
    case 'latex':
      break;
    default:
      log('found Other object type: $outmostType');
      break;
  }
}

_blockSelector(Map<String, dynamic> slatejson) {
  var outmostType = slatejson.keys.firstWhere((element) => element == "type");
  switch (outmostType) {
    case 'paragraph':
      // _loopSelector(slatejson);
      RichTextSlate(slatejson);
      break;
    case 'block-quote':
      // _loopSelector(slatejson);
      RichTextSlate(slatejson, isBlockQuote: true);
      break;
  }
}

_loopSelector(Map<String, dynamic> slatejson, Widget? widget) {
  var nodes = slatejson.entries
      .firstWhere((element) => element.key == "nodes")
      .value as List<Map<String, dynamic>>;
  for (var node in nodes) {
    _selector(node, widget);
  }
}
