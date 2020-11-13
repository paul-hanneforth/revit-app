import 'package:flutter/material.dart';
import 'package:revit/config.dart';
import 'package:revit/pages/error/version_error_page.dart';
import 'package:revit/pages/login_page.dart';
import 'package:revit/ui/outline_button.dart' as button;
import 'package:revit/ui/snackbar.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart';

class ConnectionErrorPage extends StatefulWidget {

  @override
  State createState() => ConnectionErrorPageState();

}
class ConnectionErrorPageState extends State<ConnectionErrorPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> verifyConnection() async {
    try {
      final PingResponse pingResponse = await ping();
      if(pingResponse.version != version) {
        print("Versions don't match!");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => new VersionErrorPage()), (route) => false);
        return;
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => new LoginPage()), (route) => false);
    } catch(e) {
      createSnackbar(title: "Failed to connect", scaffoldKey: scaffoldKey);
    }
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

    analyticsSetCurrentScreen("connection_error_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [
          Text("Connection Error", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black)),
          SizedBox(height: 28),
          Center(
            child: Container(
              width: 374,
              child: Text("Please check your internet connection and try again!", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black.withOpacity(0.6))),
            )
          ),
          SizedBox(height: 120),
          button.OutlineButton(
            text: "Try again",
            onTap: () { verifyConnection(); },
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
      )
    );
  }

}