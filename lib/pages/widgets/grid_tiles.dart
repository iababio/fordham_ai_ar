import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/pages/chat_page.dart';
import 'package:flutter_realtime_detection/pages/services_page.dart';
import 'package:flutter_realtime_detection/pages/webView.dart';
import 'package:flutter_realtime_detection/services/chat_api.dart';
import 'package:flutter_realtime_detection/utils/data_infos.dart';

class GridTilesPage extends StatelessWidget {
  const GridTilesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: GridView.count(
            crossAxisCount: 3, // Number of columns
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 16.0,
            children: [
              GridTileItem(
                title: "AI Chat",
                percentage: 40,
                color: Color.fromARGB(255, 74, 225, 249),
                desc: "Chat with Fordham AI",
                icon: Icons.smart_button,
                data: "Chat with Fordham AI",
              ),
              GridTileItem(
                title: "Podcast",
                percentage: 40,
                color: Colors.orange,
                desc: "State of the Art Podcast facility @LITE",
                icon: Icons.headphones,
                data: podcast_content,

              ),
              GridTileItem(
                title: "Library",
                percentage: 40,
                color: Colors.amber,
                desc: "Fordham Library",
                icon: Icons.book, // custom bone icon
                data: Library,
              ),
              GridTileItem(
                title: "OBS",
                percentage: 40,
                color: Colors.lightBlue,
                desc: "Open Broadcaster Software @LITE",
                icon: Icons.video_camera_front_rounded,
                data: OBS,
              ),
              GridTileItem(
                title: " Maker \n Space",
                percentage: 40,
                color: Color.fromARGB(255, 3, 244, 192),
                desc: "3D, Laser Cut, Sewing",
                icon: Icons.stay_primary_landscape,
                data: LITE_MakerSpace,
              ),
              GridTileItem(
                title: "Transport",
                percentage: 40,
                color: Colors.purple,
                desc: "Shuttle Bus",
                icon: Icons.directions_bus,
                data: RAM_VAN,
              ),
              GridTileItem(
                title: "Dining",
                percentage: 40,
                color: Colors.lightBlue,
                desc: "Fordham Dining",
                icon: Icons.local_dining,
                data: "Fordham Dining",
              ),
              GridTileItem(
                title: "Ticket",
                percentage: 40,
                color: Color.fromARGB(255, 229, 152, 44),
                desc: "Get your ticket to Fordham campus events",
                icon: Icons.receipt,
                data: "Get your ticket to Fordham campus events",
              ),
              GridTileItem(
                title: "Hospital",
                percentage: 40,
                color: Color.fromARGB(255, 229, 44, 44),
                desc: "Fordham Hospital",
                icon: Icons.local_hospital,
                data: "Fordham Hospital",
              ),
              GridTileItem(
                title: "Sports",
                percentage: 40,
                color: Color.fromARGB(255, 175, 26, 150),
                desc: "Fordham Sports",
                icon: Icons.sports_baseball_outlined,
                data: "Fordham Sports",
              ),
              GridTileItem(
                title: "Emerge..",
                percentage: 40,
                color: Color.fromARGB(255, 229, 198, 44),
                desc: "Emergency Services",
                icon: Icons.warning_amber,
                data: "Emergency Services",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridTileItem extends StatelessWidget {
  final String title;
  final int percentage;
  final Color color;
  final String desc;
  final IconData icon;
  final String data;

  const GridTileItem({
    Key? key,
    required this.title,
    required this.percentage,
    required this.color,
    required this.desc,
    required this.icon,
    required this.data, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == "AI Chat") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(chatApi: ChatApi()),
            ),
          );
        } else if (title == "Library") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebView(
                    url: Uri.parse('https://www.library.fordham.edu/digital/')),
              ));
        } else if (title == "Dining") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebView(
                    url: Uri.parse(
                        'https://www.fordham.edu/about/campuses/rose-hill-campus/mcshane-campus-center/spotlight-on-dining/')),
              ));
        } else if (title == "Ticket") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebView(
                    url: Uri.parse('https://fordhamsports.com/sports/tickets')),
              ));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ServicePage(title: title, data: data)),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20.0),
                const SizedBox(width: 6.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Text(
            //   "$percentage%",
            //   style: TextStyle(
            //     fontSize: 16.0,
            //     fontWeight: FontWeight.bold,
            //     color: color,
            //   ),
            // ),
            Text(
              desc,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: color,
              ),
            ),
            const SizedBox(height: 8.0),
            Stack(
              children: [
                // Container(
                //   height: 10.0,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: color.withOpacity(0.2),
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                // ),
                Container(
                  height: 10.0,
                  width: percentage.toDouble(),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            // Text(
            //   "Left: $desc",
            //   style: const TextStyle(
            //     fontSize: 12.0,
            //     color: Colors.grey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
