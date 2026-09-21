// Widget para mostrar JSON formateado con resaltado simple

import 'dart:convert';
import 'package:flutter/material.dart';

class JsonView extends StatelessWidget {
  final dynamic json;
  final int indent;
  final TextStyle? style;

  const JsonView({
    super.key,
    required this.json,
    this.indent = 2,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      color: theme.colorScheme.onSurface,
      height: 1.4,
    );

    final formattedJson = const JsonEncoder.withIndent(' ').convert(json);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: SingleChildScrollView(
        child: SelectableText(
          formattedJson,
          style: defaultStyle.merge(style),
        ),
      ),
    );
  }
}

/// Versión simple sin scroll para JSONs pequeños
class JsonViewInline extends StatelessWidget {
  final dynamic json;
  final TextStyle? style;

  const JsonViewInline({
    super.key,
    required this.json,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: 12,
      color: theme.colorScheme.onSurface,
      height: 1.4,
    );

    final formattedJson = const JsonEncoder.withIndent('  ').convert(json);

    return SelectableText(
      formattedJson,
      style: defaultStyle.merge(style),
    );
  }
}