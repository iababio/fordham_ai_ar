import 'package:flutter/material.dart';
import 'package:flutter_realtime_detection/pages/chat_page.dart';
import 'package:flutter_realtime_detection/pages/services_page.dart';
import 'package:flutter_realtime_detection/services/chat_api.dart';



const data = """
# Learning Commons, LITE: Learning, Innovation, Technology Environment

##### For Students, Faculty, Staff, Guests, Alumni


## Overview
The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

![system schema](https://plus.unsplash.com/premium_photo-1680037568890-a060c78d1f43?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much-needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer. The ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.



## Features

In particular, LITE offers:

- Staff from the IT Service Desk available for day-to-day technology assistance
- A Makerspace with 3D printers, 3D scanners, a laser cutter, CNC router, and more
- Two sound-controlled recording and podcasting rooms with microphones and HD cameras
- The One Button Studio, an easy-to-use video recording environment with a light board
- Training workshops throughout the school year
- Many collaborative work areas with wireless presentation displays and glass whiteboards
- High-end PC and Mac workstations for multimedia production with Adobe Creative Cloud
- An Extended Reality area with Meta, HTC, Microsoft, and Sony headsets
- An Assistive Technology (A11y) workstation



## Hours

- **Rose Hill:**  
  Open Monday - Friday, 10 AM - 6 PM.  
  Access to the Service Desk, the lounge, and collaborative areas is open to all walk-ins.

- **Lincoln Center Annex:**  
  Open Monday - Thursday, 9 AM - 5 PM.  
  Access to the digital whiteboard is open to all walk-ins.

*The community should sign up to reserve time in the recording rooms, XR room, the 3D printers, and Makerspace at Rose Hill and Lincoln Center. Please sign up via Calendly [here](#).*

## Locations

- **Rose Hill:**  
  Amenities include: collaboration areas (lounge, TVs, and digital whiteboards), PCs, Macs, recording rooms, XR, and a Makerspace including 3D printers, 3D scanning, laser cutter, and other equipment.  
  _Walsh Family Library, Lower Level, Room 014_

- **Lincoln Center Annex:**  
  VR and Jamboard and a makerspace with 3D scanning/printing.  
  _Lowenstein building, Room 416 [located within the Faculty Technology Center]_

## Contact Us
Email [LITE@fordham.edu](mailto:LITE@fordham.edu) for visits, tours, and consultations.

""";

class GridTilesPage extends StatelessWidget {
  const GridTilesPage({Key? key}) : super(key: key);

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
            children: const [
              GridTileItem(
                title: "AI Chat",
                percentage: 40,
                color: Color.fromARGB(255, 74, 225, 249),
                desc: "Chat with Fordham AI",
                icon: Icons.smart_button,
              ),
              GridTileItem(
                title: "Podcast",
                percentage: 40,
                color: Colors.orange,
                desc: "State of the Art Podcast facility @LITE",
                icon: Icons.headphones,
              ),
              GridTileItem(
                title: "Books",
                percentage: 40,
                color: Colors.amber,
                desc: "Fordham Library",
                icon: Icons.book, // custom bone icon
              ),
              GridTileItem(
                title: "OBS",
                percentage: 40,
                color: Colors.lightBlue,
                desc: "Open Broadcaster Software @LITE",
                icon: Icons.video_camera_front_rounded,
              ),
              GridTileItem(
                title: "3D Print",
                percentage: 40,
                color: Color.fromARGB(255, 3, 244, 192),
                desc: "3D Printing @LITE",
                icon: Icons.stay_primary_landscape,
              ),
              GridTileItem(
                title: "Transport",
                percentage: 40,
                color: Colors.purple,
                desc: "Shuttle Bus",
                icon: Icons.directions_bus,
              ),
              GridTileItem(
                title: "Dining",
                percentage: 40,
                color: Colors.lightBlue,
                desc: "Fordham Dining",
                icon: Icons.local_dining,
              ),
              GridTileItem(
                title: "Ticket",
                percentage: 40,
                color: Color.fromARGB(255, 229, 152, 44),
                desc: "Get your ticket to Fordham campus events",
                icon: Icons.receipt,
              ),
              GridTileItem(
                title: "Hospital",
                percentage: 40,
                color: Color.fromARGB(255, 229, 44, 44),
                desc: "Fordham Hospital",
                icon: Icons.local_hospital,
              ),
              GridTileItem(
                title: "Sports",
                percentage: 40,
                color: Color.fromARGB(255, 175, 26, 150),
                desc: "Fordham Sports",
                icon: Icons.sports_baseball_outlined,
              ),

              GridTileItem(
                title: "Emerge..",
                percentage: 40,
                color: Color.fromARGB(255, 229, 198, 44),
                desc: "Emergency Services",
                icon: Icons.warning_amber,
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

  const GridTileItem({
    Key? key,
    required this.title,
    required this.percentage,
    required this.color,
    required this.desc,
    required this.icon,
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
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ServicePage(title: title, data: data)
            ),
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
