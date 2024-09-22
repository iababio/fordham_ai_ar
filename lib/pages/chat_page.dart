// chat_page.dart
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/home_page.dart';
import 'package:flutter_realtime_detection/main.dart';
import 'package:flutter_realtime_detection/models/chat_message.dart';
import 'package:flutter_realtime_detection/pages/widgets/message_bubble.dart';
import 'package:flutter_realtime_detection/pages/widgets/message_composer.dart';
import 'package:flutter_realtime_detection/services/chat_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.chatApi,
    super.key,
  });

  static const title = 'ChatAi';
  static const androidIcon = Icon(Icons.chat_bubble_outline);
  static const iosIcon = Icon(Icons.chat_bubble_outline);

  final ChatApi chatApi;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false; // Step 1: Initialize the state variable

  final List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage('', false),
  ];
  var _awaitingResponse = false;
  StreamSubscription<String>? _responseSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener); // Listen to scroll events

    _responseSubscription = widget.chatApi.responseStream.listen((response) {
      print('Received response: $response'); // Debugging statement

      setState(() {
        _messages.add(ChatMessage(response, false));
        _awaitingResponse = false;
      });
    }, onError: (error) {
      print('Error in response stream: $error'); // Debugging statement
    }, onDone: () {
      print('Response stream closed'); // Debugging statement
    });
  }

  Future<void> _onSubmitted(String message) async {
    FocusScope.of(context).unfocus();
    if (message.isEmpty) {
      setState(() {
        _awaitingResponse = false;
      });
      return;
    }

    setState(() {
      _messages.add(ChatMessage(message, true));
      _awaitingResponse = true;
    });

    widget.chatApi.completeChat(_messages);

    _responseSubscription?.cancel(); // Cancel existing subscription if exists
    _responseSubscription = widget.chatApi.responseStream.listen((responsePart) {
      if (mounted) {
        setState(() {
          if (_messages.last.isUserMessage) {
            _messages.add(ChatMessage(responsePart, false));
          } else {
            _messages.last = ChatMessage(_messages.last.content + responsePart, false);
          }
        });
      }
      _scrollToBottom();
    }, onDone: () {
      if (mounted) {
        setState(() {
          _awaitingResponse = false;
        });
        _scrollToBottom();
      }
      _responseSubscription?.cancel();
    }, onError: (error) {
      setState(() {
        _awaitingResponse = false; // Handle error
      });
    });
    HapticFeedback.mediumImpact();
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    setState(() {
      _awaitingResponse = false;
    });
  }

  Future<void> _isGenerated() async {
    setState(() {
      _awaitingResponse = false;
    });
  }

  void _scrollListener() {
    // Step 2: Update the listener
    if (_scrollController.offset <
        _scrollController.position.maxScrollExtent - 50) {
      // Show the button if not at the bottom
      if (!_showScrollToBottom) {
        setState(() => _showScrollToBottom = true);
      }
    } else {
      // Hide the button if at the bottom
      if (_showScrollToBottom) {
        setState(() => _showScrollToBottom = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.alignLeft,
              size: 25,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            onPressed: () => {}),
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        title: Center(
          child: RichText(
            text: TextSpan(
              text: 'Fordham: ',
              style: textTheme.titleLarge!.copyWith(
                color: const Color(0xFF72192D),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: 'Ai',
                  style: textTheme.titleLarge!.copyWith(
                    color: Color.fromARGB(255, 190, 1, 77),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )
              .animate(
            onComplete: (controller) => controller.repeat(),
          )
              .shimmer(
            duration: const Duration(milliseconds: 2000),
            delay: const Duration(milliseconds: 1000),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.penToSquare,
                  size: 22,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                onPressed: () => {
                  setState(() => _messages.clear()),
                  HapticFeedback.mediumImpact()
                },
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.gripVertical,
                  size: 22,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                cameras: cameras,
                              ))),
                  HapticFeedback.mediumImpact()
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    behavior: HitTestBehavior.opaque,
                    child: ListView.builder(
                      controller: _scrollController,
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        if (_messages[index].content.isNotEmpty) {
                          return MessageBubble(
                            content: _messages[index].content,
                            messages: [_messages[index].content],
                            isUserMessage: _messages[index].isUserMessage,
                            mergeWithPrevious:
                            index > 0 && !_messages[index].isUserMessage,
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                MessageComposer(
                  onSubmitted: _onSubmitted,
                  content: _messages,
                  awaitingResponse: _awaitingResponse,
                ),
              ],
            ),
            if (_showScrollToBottom && _messages.length > 1)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 10.0, bottom: 85.0), // Adjust based on your layout
                  child: Container(
                    width: 25,
                    height: 25,
                    child: FloatingActionButton(
                      onPressed: _scrollToBottom,
                      child: Icon(Icons.arrow_downward,
                          color: isDark ? Colors.black : Colors.white, size: 20),
                      mini: true,
                      backgroundColor: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    setState(() {
      _awaitingResponse = false;
    });
    widget.chatApi.dispose();
    _responseSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
