// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_realtime_detection/pages/user_profile_page.dart';

import 'list_prev_chats.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      shadowColor: isDark ? Colors.black : Colors.white,
      backgroundColor: isDark ? Colors.black : Colors.white,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
          ),
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.90,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  child: Column(
                    children: [
                      // search bar
                      Container(
                        margin: const EdgeInsets.only(
                            top: 70, left: 10, right: 10, bottom: 10),
                        height: 40,
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //   color: isDark ? Colors.grey[900] : Colors.grey[200],
                        //   borderRadius: BorderRadius.circular(15),
                        // ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[900]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'san-serif',
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, top: 14, bottom: 14),
                                  ),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  HapticFeedback.mediumImpact();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor:
                                      isDark ? Colors.white70 : Colors.black,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  padding: const EdgeInsets.all(0),
                                ),
                                icon: Icon(
                                  Icons.cancel,
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //   list scrollable items list
                      const ListPrevChats(),
                    ],
                  )),
              Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountPage(),
                                ),
                              );
                              HapticFeedback.mediumImpact();
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, right: 5, bottom: 5, left: 0),
                                  child: const CircleAvatar(
                                    minRadius: 12,
                                    maxRadius: 18,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage('assets/images/me.JPG'),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 2),
                                  child: Text(
                                    'John Doe',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'san-serif',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _showBottomSheet(context);
                            HapticFeedback.mediumImpact();
                          },
                          icon: Icon(
                            Icons.settings,
                            color: isDark ? Colors.white70 : Colors.black87,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void handleSignOut() async {
      // await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Container(),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.black54 : Colors.white,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Implement your settings logic here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
                HapticFeedback.mediumImpact();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services_rounded),
              title: const Text('Clear Chat History'),
              onTap: () {
                // Implement your settings logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign Out'),
              onTap: () {
                // Implement your signout logic here
                _handleSignOut();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () {
                // Implement your delete account logic here
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

//   sign out
  Future<void> _handleSignOut() async {
    // await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountPage(),
      ),
    );
  }
}
