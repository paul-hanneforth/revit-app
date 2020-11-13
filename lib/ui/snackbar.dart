import 'package:flutter/material.dart';

void createSnackbar({ @required title, description, @required scaffoldKey }) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    backgroundColor: Color(0xFF1C1C1C), 
    content: Container(
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 19, bottom: description == null ? 19: 0),
          child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 22, color: Colors.white)),
        ),
        description != null ? Container(
          padding: EdgeInsets.only(bottom: 19),
          child: Text(description, textAlign: TextAlign.center, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white.withOpacity(0.6)))
        ) : Material()
      ], mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,),
    )
  ));
}