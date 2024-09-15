import 'package:flutter/material.dart';

Future<void> ARView(BuildContext context, Widget page) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (BuildContext context) {
      return page;
    },
  );
}
