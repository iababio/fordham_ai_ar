import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
        color: Colors.black,
        child: SizedBox(
            height: 50,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.home, color: Colors.white, size: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30)),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/user');
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.person, color: Colors.white, size: 30)),
              ],
            )
        )
    );
  }
}
