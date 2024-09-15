import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_realtime_detection/constants/api_consts.dart';
import 'package:flutter_realtime_detection/models/chat_message.dart';

class ChatApi {
  // static const _model = 'gpt-3.5-turbo';
  static const _model = 'gpt-4-turbo-preview';

  // final _responseController = StreamController<String>();
  StreamController<String> _responseController = StreamController<String>.broadcast();

  Stream<String> get responseStream => _responseController.stream;

  ChatApi() {
    OpenAI.apiKey = API_KEY;
    OpenAI.organization = openAiOrg;
  }

  // Stream<String> get responseStream => _responseController.stream;

  void completeChat(List<ChatMessage> messages) async {
    final chatCompletion = await OpenAI.instance.chat.createStream(
      model: _model,
      messages: messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
        role: e.isUserMessage
            ? OpenAIChatMessageRole.user
            : OpenAIChatMessageRole.system,
        content: e.message,
      ))
          .toList(),
      temperature: 0.5,
      topP: 1,
    );

    chatCompletion.listen(
          (streamChatCompletion) {
        final content = streamChatCompletion.choices.first.delta.content;
        _responseController.sink.add(content! as String);
      },
      onDone: () {
        print("Done");
      },
    );
  }

  void dispose() {
    _responseController.close();
  }
}
