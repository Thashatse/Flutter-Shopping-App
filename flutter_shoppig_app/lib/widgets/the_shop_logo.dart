import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TheShopLogoWidget extends StatelessWidget {
  const TheShopLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
        transform: Matrix4.rotationZ(-5 * pi / 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(23, 24, 29, 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: const Color.fromRGBO(23, 24, 29, 1),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Text(
          'The Shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class TheShopLogoBackDropWidget extends StatelessWidget {
  const TheShopLogoBackDropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(252, 217, 184, 1), //1
            const Color.fromRGBO(224, 145, 69, 1), //60%
            const Color.fromRGBO(41, 44, 53, 1), //80%
            const Color.fromRGBO(23, 24, 29, 1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          stops: [0, 1, 2, 3],
        ),
      ),
    );
  }
}
