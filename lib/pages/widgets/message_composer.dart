// widgets/message_composer.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MessageComposer extends StatefulWidget {
  const MessageComposer({
    required this.onSubmitted,
    this.content,
    required this.awaitingResponse,
    super.key,
  });

  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];
  final void Function(String) onSubmitted;
  final List? content;
  final bool awaitingResponse;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class SizeConfig {
  double heightSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _messageController = TextEditingController();
  bool isFileSelected = false;

  void _showAction(BuildContext context, int index) {
    if (kDebugMode) {
      print('Pressed ${MessageComposer._actionTitles[index]}');
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        // Rebuilds on every change
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  final requestTemplate = [
    {
      "message": "I need help with ultimaker",
    },
    {
      "message": "I need help with 3D printing",
    },
    {
      "message": "I need help with PodCast/Recoding",
    },
    {
      "message":
          "I need help with PodCast/Recoding any time for the purpose of the project",
    }
  ];

  Future<void> _fileSelected(bool fileSelect) async {
    // print('File selected: ${file}');
    setState(() {
      isFileSelected = fileSelect;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        _messageController.text.isEmpty && widget.content!.length <= 1
            ? isFileSelected
                ? Container(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.file_present_rounded,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Your file is ready...',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'san-serif',
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFileSelected = false;
                            });
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var i = 0; i < requestTemplate.length; i++)
                          Container(
                            width: 150,
                            height: 80,
                            margin: EdgeInsets.all(2),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Color.fromARGB(237, 28, 28, 28)
                                    : Color.fromARGB(227, 233, 233, 233),
                                borderRadius: BorderRadius.circular(20), // 30
                              ),
                              child: TextButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  widget.onSubmitted(
                                      requestTemplate[i]['message']!);
                                },
                                child: Text(requestTemplate[i]['message']!,
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
            : Container(),
        Container(
          height: MediaQuery.of(context).size.height * 0.09,
          decoration: BoxDecoration(
            color: Colors.transparent,
            backgroundBlendMode: BlendMode.darken,
          ),
          child: Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.white,
            body: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 0, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: !widget.awaitingResponse
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.32,
                                constraints: BoxConstraints(
                                  minHeight: 20.0, // Minimum height (for 1 line)
                                  maxHeight: 200.0, // Maximum height: adjust this value as needed
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black : Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                    bottom: _messageController.text.split('\n').length * 20.0 > 180 ? 20.0 : 0,
                                  ),
                                  reverse: true,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: isFileSelected ? 'Ask question based on file...' : 'Type question here...',
                                      hintStyle: TextStyle(
                                        color: isDark ? Colors.white70 : Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'san-serif',
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
                                    ),
                                    controller: _messageController,
                                    keyboardType: TextInputType.multiline,
                                    scrollPadding: const EdgeInsets.all(10),
                                    maxLines: null, // Allows the input to grow
                                    minLines: 1,
                                    autofocus: false,
                                    textAlign: TextAlign.left,
                                    cursorColor: isDark ? Colors.white : Colors.black,
                                    // Other properties...
                                  ),
                                ),
                              ),


                              Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black : Colors.white,
                                  border: Border.all(
                                      width: 0.1,
                                      color: isDark
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade500),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                ),
                                child: FloatingActionButton(
                                  backgroundColor:
                                      isDark ? Colors.black : Colors.white,
                                  elevation: 0,
                                  onPressed: !widget.awaitingResponse
                                      ? () => {
                                            if (_messageController
                                                .text.isNotEmpty)
                                              {
                                                widget.onSubmitted(
                                                    _messageController.text),
                                                _messageController.clear()
                                              }
                                            else
                                              {_showAgreeAndContinue(context)}
                                          }
                                      : null,
                                  child: IconButton(
                                      padding: const EdgeInsets.all(5),
                                      onPressed: () {
                                        if (_messageController
                                            .text.isNotEmpty) {
                                          widget.onSubmitted(
                                              _messageController.text);
                                          _messageController.clear();
                                        } else {
                                          _showAgreeAndContinue(context);
                                        }
                                        setState(() {
                                          isFileSelected = false;
                                        });
                                        HapticFeedback.mediumImpact();
                                      },
                                      icon: _messageController.text.isNotEmpty
                                          ? FaIcon(
                                              FontAwesomeIcons.circleArrowUp,
                                              size: 30,
                                              color: isDark
                                                  ? Colors.white60
                                                  : Colors.black87,
                                            )
                                          : Icon(
                                              Icons.attach_file,
                                              size: 30,
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black,
                                            )),
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: Text('Fetching response...'),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAgreeAndContinue(context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 2,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Color(0xFF000000),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: IconButton(
                    onPressed: () {
                      _fileSelected(false);
                      Navigator.pop(context);
                      HapticFeedback.mediumImpact();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[800],
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // FileUploadComponent(onFileSelected: _fileSelected),
              ],
            ),
          );
        });
  }
}
