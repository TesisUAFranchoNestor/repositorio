
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mbarete_padel/presentation/widgets/widgets.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 3.5, 
      child: ClipPath(
      clipper: ClipPainter(),
      child: Container(
        height: MediaQuery.of(context).size.height *.5,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff44d62c),Color(0xff3c802e)]
            )
          ),
      ),
    ),
    );
  }
}