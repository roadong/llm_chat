import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;


class MarkdownRenderer extends StatelessWidget {
  final String text;
  final bool isUser;

  const MarkdownRenderer({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isUser
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSecondaryContainer;

    // 기본 텍스트 스타일
    final baseTextStyle = TextStyle(color: textColor, fontSize: 16);

    return MarkdownBody(
      data: text.isEmpty ? "..." : text, // 텍스트가 비어있을 때 로딩 표시
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: baseTextStyle,
        h1: baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        h2: baseTextStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
        h3: baseTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        listBullet: baseTextStyle,
        code: baseTextStyle.copyWith(
          fontFamily: 'monospace',
          backgroundColor: theme.colorScheme.surface.withOpacity(0.2),
        ),
        codeblockDecoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.colorScheme.surface.withOpacity(0.2)),
        ),
      ),
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubWeb.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
      ),
    );
  }
}