import 'package:flutter/material.dart';

class Image extends StatelessWidget {

  final String imageURL;

  Image({ this.imageURL });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 350.0,
      height: 350.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xffFFFFFF),
        image: imageURL != null ? DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageURL),
        ) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4)
          )
        ]
      )
    );
  }
}