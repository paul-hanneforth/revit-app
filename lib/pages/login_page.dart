import 'package:flutter/material.dart';
import 'package:revit/config.dart';
import 'package:revit/pages/create_profile_page.dart';
import 'package:revit/pages/error/connection_error_page.dart';
import 'package:revit/pages/error/version_error_page.dart';
import 'package:revit/pages/home_page.dart';
import 'package:revit/pages/tutorial/rate_page_tutorial.dart';
import 'package:revit/ui/loader.dart';
import 'package:revit/ui/snackbar.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/crashlytics.dart';
import 'package:revit/utils/info.dart';
import 'package:revit/utils/login.dart';
import 'package:revit/utils/server.dart';

class LoginPage extends StatefulWidget {

  @override
  State createState() => new LoginPageState();

}
class LoginPageState extends State<LoginPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<bool> tutorialAlreadyCompleted() async {
    final Map<String, dynamic> result = await readInfoFile();
    if(result["tutorialCompleted"] == true) {
      return true;
    }
    return false;
  }

  Future<void> loginWithGoogle() async {
    showLoader(context);
    final idToken = await authenticateWithGoogle();
    final profileAlreadyExists = await profileExists(idToken);
    removeLoader(context);
    if(idToken == null) return createSnackbar(title: "Failed to login", description: "Please try again.", scaffoldKey: scaffoldKey);

    if(profileAlreadyExists) {
      // if profile already exists, redirect the user to the HomePage
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) { return HomePage(idToken); }));
      if((await tutorialAlreadyCompleted())) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(idToken: idToken)), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RatePageTutorial(idToken: idToken)), (route) => false);
      }
    } else {
      // if not, redirect the user to the CreateProfilePage
      Navigator.of(context).push(MaterialPageRoute(builder: (context) { return CreateProfilePage(idToken: idToken); }));
    }
  }
  Future<void> tryAutomaticLogin() async {

    final idToken = await isAuthenticated();

    if(idToken == null) return;

    analyticsLogEvent("automatic-login");

    showLoader(context);
    final profileAlreadyExists = await profileExists(idToken);
    removeLoader(context);

    if(profileAlreadyExists) {
      // if profile already exists, redirect the user to the HomePage
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) { return HomePage(idToken); }));
      if((await tutorialAlreadyCompleted())) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(idToken: idToken)), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RatePageTutorial(idToken: idToken)), (route) => false);
      }
    } else {
      // if not, redirect the user to the CreateProfilePage
      Navigator.of(context).push(MaterialPageRoute(builder: (context) { return CreateProfilePage(idToken: idToken); }));
    }

  }

  Future<bool> verifyConnection() async {
    try {
      final PingResponse pingResponse = await ping();
      if(pingResponse.version != version) {
        print("Versions don't match!");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => new VersionErrorPage()), (route) => false);
        return false;
      }
      return true;
    } catch(e) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => new ConnectionErrorPage()), (route) => false);
      return false;
    }
  }

  Widget imageOutlineBox(assetURL, onTap) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.16), width: 1),
            borderRadius: BorderRadius.circular(8)
          ),
          padding: EdgeInsets.all(13),
          child: Image(
            image: AssetImage(assetURL),
            width: 30,
            height: 30.75,
          ),
        ),
      ),
    );
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
    initializeAnalytics();
    initializeCrashlytics();

    analyticsSetCurrentScreen("login_page");

    verifyConnection().then((serverAvailable) {
      if(!serverAvailable) return;

      tryAutomaticLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Stack(
        children: [
          Row(children: [
            Container(
              padding: EdgeInsets.only(top: 168),
              child: Image(
                image: AssetImage("assets/logo.png"),
                width: 76,
                height: 76,
              ),
            )
          ], mainAxisAlignment: MainAxisAlignment.center),
          Center(
            child: Column(
              children: [
                Text("Sign in with", style: TextStyle(fontFamily: "Poppins", fontSize: 20 , fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.25))),
                SizedBox(height: 28),
                Row(children: [
                  imageOutlineBox("assets/google-logo.png", loginWithGoogle)
                ], mainAxisAlignment: MainAxisAlignment.center,)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          )
        ],
      ),
    );
  }

}