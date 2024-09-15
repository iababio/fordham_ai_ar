import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String? imagePath;
  final IconData? icon;
  final Function()? onTap;
  final double size;
  final double padding;


  const SquareTile({
    super.key,
    this.imagePath, required this.size, required this.padding, this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              padding:  EdgeInsets.all(padding),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!, width: 0.3),
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
              ),
              child: Builder(
                builder: (context) {
                  if (imagePath != "") {
                    //
                    return Image.asset(
                      imagePath!,
                      height: size,
                    );
                  }else if(icon != null){
                    return Icon(
                      icon,
                      size: size,
                      color: Colors.white,
                    );
                  }

                  return Icon(
                    Icons.error,
                    size: size,
                    color: Colors.white,
                  );
                },
              ),
            ),
          );
        }
    );
  }
}