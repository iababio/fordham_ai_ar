import 'package:flutter/material.dart';

class ListPrevChats extends StatelessWidget {
  const ListPrevChats({super.key});

  @override
  Widget build(BuildContext context) {
    const jsnListData = [
      {
        'title': '',
        'subtitle': '',
      },
    ];
    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
            itemCount: jsnListData.length,
            itemBuilder: (context, index) {
              return Container(
                height: 50,
                padding: const EdgeInsets.only(top: 0),
                child: ListTile(
                  title: Text(jsnListData[index]['title']!),
                ),
              );
            },
      ),
    );
  }
}
