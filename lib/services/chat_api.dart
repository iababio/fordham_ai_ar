import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:FordhamAR/constants/api_consts.dart';
import 'package:FordhamAR/models/chat_message.dart';

class ChatApi {
  // static const _model = 'gpt-3.5-turbo';
  static const _model = 'gpt-4-turbo-preview';

  // final _responseController = StreamController<String>();
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

    final chatStream = OpenAI.instance.chat.createStream(
      model: _model,
      messages: messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage
                    ? OpenAIChatMessageRole.user
                    : OpenAIChatMessageRole.system,
                content: [
                  OpenAIChatCompletionChoiceMessageContentItemModel.text(
                      _formatMessage(e)),
                ],
              ))
          .toList(),
      seed: 423,
      n: 2,
    );
    
    String _cumulativeContent = "";

    // Listen to the stream.
    chatStream.listen(
      (streamChatCompletion) {
        final contentItems = streamChatCompletion.choices.first.delta.content;

        // Extract text from content items
        final newContent = contentItems
            ?.map((item) => item?.text);

        // Avoid duplicate content
        if (newContent != null &&
            newContent.isNotEmpty &&
            newContent.first != _cumulativeContent) {
          _responseController.sink.add(newContent.first!);
        }
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
