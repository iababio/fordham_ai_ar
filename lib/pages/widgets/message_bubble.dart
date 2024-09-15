// widgets/message_bubble.dart
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/blocks/leaf/link.dart';
import 'package:markdown_widget/widget/markdown.dart';

import 'code_wrapper.dart';

class MessageBubble extends StatelessWidget {
  final String? content;
  final bool isUserMessage;
  final bool mergeWithPrevious;

  MessageBubble({
    required this.content,
    required this.isUserMessage,
    this.mergeWithPrevious = false,
    Key? key,
    required List<String> messages,
  });

  @override
  Widget build(BuildContext context) {
    // final User? user = FirebaseAuth.instance.currentUser;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final config =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

    Widget codeWrapper(child, text, language) =>
        CodeWrapperWidget(child, text, language);


    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!mergeWithPrevious)
              Row(
                children: [
                  CircleAvatar(
                    minRadius: 12,
                    maxRadius: 12,
                    backgroundColor: Colors.transparent,
                    backgroundImage: isUserMessage
                        ? const AssetImage(
                                    'assets/images/profileHolder.jpg')
                                as ImageProvider<Object>
                        : AssetImage('assets/images/fordham.png')
                            as ImageProvider<Object>,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isUserMessage ? 'You' : 'RamAi',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[400] : Colors.grey[800],
                      fontFamily: 'san-serif',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            MarkdownWidget(
              data: content ?? '',
              config: config.copy(
                configs: [
                  isDark
                      ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
                      : const PreConfig(theme: a11yLightTheme)
                          .copy(wrapper: codeWrapper),
                  LinkConfig(
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                    onTap: (url) {
                      // Handle link tap action here
                    },
                  ),
                ],
              ),
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
