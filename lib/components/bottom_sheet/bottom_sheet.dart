import 'package:flutter/material.dart';

Future<void> bottomSheet2(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                  height: MediaQuery.of(context).size.height / 1.35,
                  padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Column(
                    children: [
                      Text(
                        'Information',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ))
            ],
          ),
        ),
      );
    },
  );
}
