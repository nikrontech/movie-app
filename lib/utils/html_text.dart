import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

/// Renders the basic formatting used in cinema synopses as native text spans.
TextSpan synopsisSpan(String source) {
  final spans = <InlineSpan>[];
  var hasText = false;
  var pendingBreaks = 0;

  void visit(dom.Node node, TextStyle style) {
    if (node is dom.Text) {
      final text = node.data.replaceAll(RegExp(r'\s+'), ' ');
      if (text.trim().isEmpty) return;
      if (pendingBreaks > 0 && hasText) {
        spans.add(TextSpan(text: '\n' * pendingBreaks));
      }
      spans.add(TextSpan(
        text: !hasText || pendingBreaks > 0 ? text.trimLeft() : text,
        style: style,
      ));
      pendingBreaks = 0;
      hasText = true;
      return;
    }
    if (node is! dom.Element) return;
    final tag = node.localName;
    if (tag == 'script' || tag == 'style') return;
    if (tag == 'br') {
      pendingBreaks = pendingBreaks < 1 ? 1 : pendingBreaks;
      return;
    }
    final block = tag == 'p' || tag == 'div' || tag == 'li';
    if (block && hasText) pendingBreaks = 2;
    var childStyle = style;
    if (tag == 'strong' || tag == 'b') {
      childStyle = childStyle.copyWith(fontWeight: FontWeight.bold);
    }
    if (tag == 'em' || tag == 'i') {
      childStyle = childStyle.copyWith(fontStyle: FontStyle.italic);
    }
    if (tag == 'u') {
      childStyle = childStyle.copyWith(decoration: TextDecoration.underline);
    }
    for (final child in node.nodes) {
      visit(child, childStyle);
    }
    if (block) pendingBreaks = 2;
  }

  for (final node in parser.parseFragment(source).nodes) {
    visit(node, const TextStyle());
  }
  return TextSpan(children: spans);
}
