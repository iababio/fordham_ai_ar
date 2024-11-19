import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:FordhamAR/constants/api_consts.dart';
import 'package:FordhamAR/models/chat_message.dart';

class ChatApi {
  static const _model = 'gpt-4-turbo-preview';

  StreamController<String> _responseController =
      StreamController<String>.broadcast();

  Stream<String> get responseStream => _responseController.stream;

  ChatApi() {
    OpenAI.apiKey = API_KEY;
    OpenAI.organization = openAiOrg;
  }

  String _formatMessage(ChatMessage message) {
    var prompt = """
    Below is a conversation between you and a prompt user:
    message: ${message.content};
    Limit all search responses to Fordham University.
    """;
    return prompt;
  }

  void completeChat(List<ChatMessage> messages) async {
    final formattedMessages = messages.map((e) {
      return OpenAIChatCompletionChoiceMessageModel(
        role: e.isUserMessage
            ? OpenAIChatMessageRole.user
            : OpenAIChatMessageRole.system,
        content: e.isUserMessage ? _formatMessage(e) : e.content,
      );
    }).toList();

    final chatCompletion = await OpenAI.instance.chat.createStream(
      model: _model,
      messages: formattedMessages,
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
