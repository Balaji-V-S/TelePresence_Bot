import 'package:flutter/material.dart';

class LottieShadow extends StatelessWidget {
  final Widget child;
  final Color shadowColor;
  final double offsetX;
  final double offsetY;
  final double blurRadius;

  const LottieShadow({
    required this.child,super.key,
    this.shadowColor = Colors.grey,
    this.offsetX = 5.0,
    this.offsetY = 5.0,
    this.blurRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: offsetY,
          left: offsetX,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.5),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: blurRadius,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}