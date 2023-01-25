import 'package:slate_parser/document/builder.dart';
import 'package:slate_parser/rich_text/builder.dart';
import 'package:slate_parser/simple_text/builder.dart';

const builderMap = {
  'document': JsonDocumentBuilder,
  'block': JsonRichTextBuilder,
  'text': JsonSimpleTextBuilder
};