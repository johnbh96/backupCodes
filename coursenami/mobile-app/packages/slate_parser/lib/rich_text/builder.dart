import 'dart:convert';

import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

class JsonRichTextBuilder extends JsonWidgetBuilder {
  JsonRichTextBuilder({
    this.locale,
    this.overflow,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.style,
    this.textAlign,
    this.textDirection,
    this.textHeightBehavior,
    this.textScaleFactor,
    this.textWidthBasis,
    Map<String,TextStyle?>? textMap,
  })  : textMap = textMap == null
                  ? {'':const TextStyle()}
                  : textMap.isEmpty
                    ? {'':const TextStyle()}
                    : textMap,
        super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 0;
  static const type = 'text';

  final Locale? locale;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final double? textScaleFactor;
  final TextWidthBasis? textWidthBasis;
  final Map<String,TextStyle?> textMap;

  /// ```json
  /// {
  ///   "locale": <Locale>,
  ///   "overflow": <TextOverflow>,
  ///   "semanticsLabel": <String>,
  ///   "softWrap": <bool>,
  ///   "strutStyle": <StrutStyle>,
  ///   "style": <TextStyle>,
  ///   "textAlign": <TextAlign>,
  ///   "textDirection": <TextDirection>,
  ///   "textHeightBehavior": <TextHeightBehavior>,
  ///   "textScaleFactor": <double>,
  ///   "textWidthBasis": <TextWidthBasis>,
  /// }
  static JsonRichTextBuilder? fromDynamic(
    dynamic map, {
    JsonWidgetRegistry? registry,
  }) {
    JsonRichTextBuilder? result;
    if (map != null) {
      result = JsonRichTextBuilder(
        locale: ThemeDecoder.decodeLocale(
          map['local'],
          validate: false,
        ),
        overflow: ThemeDecoder.decodeTextOverflow(
          map['overflow'],
          validate: false,
        ),
        semanticsLabel: map['semanticsLabel'],
        softWrap: map['softWrap'] == null
            ? null
            : JsonClass.parseBool(map['softWrap']),
        strutStyle: ThemeDecoder.decodeStrutStyle(
          map['strutStyle'],
          validate: false,
        ),
        style: ThemeDecoder.decodeTextStyle(
          map['style'],
          validate: false,
        ),
        // text: map['text'].toString(),
        textMap: textListDecoder(map['textMap']),
        textAlign: ThemeDecoder.decodeTextAlign(
          map['textAlign'],
          validate: false,
        ),
        textDirection: ThemeDecoder.decodeTextDirection(
          map['textDirection'],
          validate: false,
        ),
        textHeightBehavior: ThemeDecoder.decodeTextHeightBehavior(
          map['textHeightBehavior'],
          validate: false,
        ),
        textScaleFactor: JsonClass.parseDouble(map['textScaleFactor']),
        textWidthBasis: ThemeDecoder.decodeTextWidthBasis(
          map['textWidthBasis'],
          validate: false,
        ),
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
    List<TextSpan> children = <TextSpan> [];
    return RichText(
      locale: locale ,
      textAlign: textAlign ?? TextAlign.left,
      textDirection: textDirection ?? TextDirection.ltr,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap ?? true,
      strutStyle: strutStyle,
      textHeightBehavior: textHeightBehavior,
      textScaleFactor: textScaleFactor ?? 1.0,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      text: TextSpan(
        style: style,
        children: children,
    ));
  }
}


Map<String,TextStyle?> textListDecoder(String textMap){
    Map<String, TextStyle?> map = {};
    Map<String,String> data = jsonDecode(textMap);
    for (var entry in data.entries){
      map.addAll({
        entry.key: ThemeDecoder.decodeTextStyle( entry.value, validate: false)
      });
    }
    return map;
  }