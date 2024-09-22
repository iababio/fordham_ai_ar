import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:FordhamAR/pages/webView.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 130),
                  MarkdownBody(
                    selectable: true,
                    onTapLink: (text, href, title) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebView(
                            url: Uri.parse(href!),
                          ),
                        ),
                      );
                    },
                    styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: isDark ? Colors.grey : Colors.black,
                        fontSize: 16,
                      ),
                      h1: TextStyle(
                        color: isDark ? Colors.grey : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      h2: TextStyle(
                        color: isDark ? Colors.grey : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      tableHead: TextStyle(
                        color: isDark ? Colors.grey : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      tableBody: TextStyle(
                        color: isDark ? Colors.grey : Colors.black,
                        fontSize: 14,
                      ),
                      code: TextStyle(
                        color: isDark ? Colors.grey : Colors.black,
                        fontSize: 14,
                      ),
                      
                    ),
                    data: data,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white : Colors.black,
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
