import 'package:flutter/material.dart';

Widget loader() {
  return Container(
    child: Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: new CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      )
    )
  );
}

void showLoader(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Container(
        child: loader()
      );
    },
  );
}
void removeLoader(context) {
  Navigator.pop(context);
}