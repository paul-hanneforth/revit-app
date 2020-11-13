import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:revit/ui/outline_button.dart' as button;
import 'package:revit/utils/analytics.dart';

class VersionErrorPage extends StatefulWidget {

  @override
  State createState() => new VersionErrorPageState();

}
class VersionErrorPageState extends State<VersionErrorPage> {

  void launchAppStore() {
    analyticsLogAppStoreRedirect();
    LaunchReview.launch(androidAppId: "com.hanneforth.revit");
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    analyticsSetCurrentScreen("version_error_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Please update the app", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black)),
          SizedBox(height: 37),
          Center(
            child: Container(
              width: 349,
              child: Text("Your version of the app doesn’t match the newest version available!", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black.withOpacity(0.6))),
            )
          ),
          SizedBox(height: 120),
          button.OutlineButton(
            text: "Update",
            onTap: () { launchAppStore(); },
            style: button.OutlineButtonStyle(
              padding: EdgeInsets.only(top: 13, bottom: 13, left: 45, right: 45),
              textStyle: TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

}