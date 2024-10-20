import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Fordham AR'),
        content: const Text(
          '=> Use the Map to check the landmark places\n\n'
              '=> Walk toward any on the Markers on the Map\n\n'
              '=> The App provides you with AR information\n\n'
              '=> You can also use the AR/Panorama mode to explore the campus',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
