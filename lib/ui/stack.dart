import 'package:flutter/material.dart';
import 'package:revit/utils/server.dart';
import 'package:revit/ui/image.dart' as image;

class Stack extends StatelessWidget {

  final StackResponse stack;
  final Function(ImageResponse) onTap;
  final List<ImageResponse> images;

  Stack({ this.stack, this.onTap, this.images });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    child: new Column(
      children: [
        // SizedBox(height: 56),
        // SizedBox(height: 36),
        new InkWell(
          onTap: () { onTap(this.images[0]); },
          child: image.Image(imageURL: this.images[0].downloadURL)
        ),
        SizedBox(height: 36),
        new InkWell(
          onTap: () { onTap(this.images[1]); },
          child: image.Image(imageURL: this.images[1].downloadURL)
        )
      ],
    )
    );
  }
}