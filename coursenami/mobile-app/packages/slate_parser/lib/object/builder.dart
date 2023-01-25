import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:slate_parser/document/builder.dart';

class JsonObjectBuilder extends JsonWidgetBuilder {
  JsonObjectBuilder({
    this.document,

  })  :
        super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'text';

  final JsonDocumentBuilder? document;

  static JsonObjectBuilder? fromDynamic(
    dynamic map, {
    JsonWidgetRegistry? registry,
  }) {
    JsonObjectBuilder? result;
    if (map != null) {
      result = JsonObjectBuilder(
        document: _documentDecoder(map['document'])
      );
    }
    return result;
  }

  @override
  Widget buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  }) {
    var child = getChild(data);
    return Container(
      key: key,
      child: child.build(
        childBuilder: childBuilder,
        context: context),
    );
  }
}

_documentDecoder(dynamic map){
  return JsonDocumentBuilder.fromDynamic(
    map
  );
}
