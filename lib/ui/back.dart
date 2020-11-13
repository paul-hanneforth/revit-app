import 'package:flutter/material.dart';
import 'package:revit/ui/hr.dart';

class BackHeader extends StatelessWidget {

  final Function onTap;

  BackHeader({ this.onTap });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        SizedBox(width: 61),
        InkWell(
          onTap: onTap,
          child: Text("Back", style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.6)
          ))
        )
      ]),
      SizedBox(height: 24),
      HR(),
    ]);
  }

}