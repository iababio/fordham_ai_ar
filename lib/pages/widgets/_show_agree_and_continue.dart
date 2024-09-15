// widgets/message_composer.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void _showAgreeAndContinue(context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black54,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            color: isDark ? Colors.black54 : Colors.white,
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
                    Navigator.pop(context);
                    HapticFeedback.mediumImpact();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.grey[700],
                    size: 30,
                  ),
                ),
              ),
              // Container(
              //   alignment: Alignment.topLeft,
              //   padding: const EdgeInsets.only(
              //       top: 0, bottom: 15, left: 25, right: 50),
              //   decoration: const BoxDecoration(
              //     color: Colors.transparent,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(30),
              //         topRight: Radius.circular(30)),
              //   ),
              //   child: const Text(
              //     "Upload any of below file types, and  start a conversation to any of the contents",
              //     style: TextStyle(
              //       fontFamily: 'san-serif',
              //       color: Colors.black87,
              //       fontWeight: FontWeight.w900,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              // const FileUploadComponent(),
            ],
          ),
        );
      });
}
