import 'package:flutter/material.dart';

class OutlineButtonStyle {

  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;

  const OutlineButtonStyle({ this.width, this.height, this.padding, this.textStyle });

}
class OutlineButton extends StatelessWidget {

  final String text;
  final Function() onTap;
  final OutlineButtonStyle style;

  OutlineButton({ this.text, this.onTap, this.style: const OutlineButtonStyle(
    padding: EdgeInsets.only(top: 13, bottom: 13, left: 25, right: 25),
    textStyle: TextStyle(
      fontFamily: "Poppins",
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black
    ),
  ) });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: style.width,
      height: style.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(width: 1,color: Colors.black.withOpacity(0.16))
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: style.padding,
            child: Text(text, style: style.textStyle),
          )
        )
      )
    );
  }

}