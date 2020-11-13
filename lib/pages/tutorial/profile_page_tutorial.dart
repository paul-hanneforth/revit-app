import 'package:flutter/material.dart';
import 'package:revit/pages/home_page.dart';
import 'package:revit/pages/profile_page.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/info.dart';

class ProfilePageTutorial extends StatefulWidget {

  final String idToken;

  ProfilePageTutorial({
    @required this.idToken
  }) : assert(idToken != null);

  @override
  State createState() => new ProfilePageTutorialState(); 

}
class ProfilePageTutorialState extends State<ProfilePageTutorial> {

  Widget button(String text, Function() onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(width: 1,color: Colors.white.withOpacity(0.71))
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 39),
            child: Text(text, style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 20)),
          )
        )
      )
    );
  }

  Widget overlay(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("This is the profile page", style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 24)),
          SizedBox(height: 5),
          Container(
            width: 342,
            child: Text("On this page, you can also edit your profile, delete image etc.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w400, fontSize: 24))
          ),
          SizedBox(height: 25),
          button("Finish Tutorial", () async {
            await setInfoFile("tutorialCompleted", true);
            analyticsLogEvent("tutorialCompleted");
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => HomePage(idToken: widget.idToken)));
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ProfilePage(idToken: widget.idToken),
        overlay(context)
      ]),
    );
  }

}