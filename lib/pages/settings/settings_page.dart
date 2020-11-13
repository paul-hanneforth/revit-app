import 'package:flutter/material.dart';
import 'package:revit/pages/login_page.dart';
import 'package:revit/pages/settings/edit_profile_page.dart';
import 'package:revit/ui/hr.dart';
import 'package:revit/ui/loader.dart';
import 'package:revit/ui/outline_button.dart' as button;
import 'package:revit/ui/snackbar.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart';
import 'package:revit/utils/login.dart';

class SettingsPage extends StatefulWidget {

  final String idToken;
  final ProfileResponse profile;

  SettingsPage({
    @required this.idToken, 
    this.profile
  }) : assert(idToken != null);

  @override 
  _SettingsPageState createState() => _SettingsPageState();

}
class _SettingsPageState extends State<SettingsPage> {

  void logout() async {
    showLoader(context);
    await signOutOfGoogle();
    removeLoader(context);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }

  Widget _navButton(String label, Function onTap, {Color color = Colors.black}) {
    return button.OutlineButton(text: label, onTap: () { onTap(); }, style: button.OutlineButtonStyle(
      padding: EdgeInsets.only(left: 24, top: 13, bottom: 13),
      width: 318,
      textStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color
      )
    ));
  }
  Widget _signoutButton() {
    return button.OutlineButton(text: "Signout", onTap: () { logout(); });
  }
  Widget _backHeader(Function onTap) {
    return Column(children: [
      SizedBox(height: 80),
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
 
  bool displayDeleteProfileOverlay = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> deleteProfile() async {
    showLoader(context);
    final Response response = await removeProfile(widget.idToken);
    if(response.error == false) {
      await signOutOfGoogle();
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    } else {
      removeLoader(context);
      setState(() { displayDeleteProfileOverlay = false; });
      createSnackbar(title: "Failed to delete profile!", description: response.message, scaffoldKey: scaffoldKey);
    }
  }

  Widget outlineButton(String text, Function() onTap) {
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
            padding: EdgeInsets.symmetric(vertical: 11, horizontal: 37),
            child: Text(text, style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 17)),
          )
        )
      )
    );
  }
  Widget filledButton(String text, Function() onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white.withOpacity(0.25)
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
            child: Text(text, style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 20)),
          )
        )
      )
    );
  }
  Widget deleteProfileOverlay() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Are you sure?", style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: 24)),
          SizedBox(height: 5),
          Container(
            width: 342,
            child: Text("Are you sure you want to delete your profile? All your data will be lost!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: "Poppins", fontWeight: FontWeight.w400, fontSize: 24))
          ),
          SizedBox(height: 25),
          Row(children: [
            filledButton("Cancel", () {
              setState(() { displayDeleteProfileOverlay = false; });
            }),
            SizedBox(width: 48),
            outlineButton("Yes", () {
              deleteProfile();
            })
          ], mainAxisAlignment: MainAxisAlignment.center)
        ],
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

    analyticsSetCurrentScreen("settings_page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _backHeader(() { Navigator.of(context).pop(); }),
                SizedBox(height: 48),
                Row(children: [
                  Column(children: [
                    _navButton("Edit Profile", () { Navigator.of(context).push(MaterialPageRoute(builder: (context) { return EditProfilePage(idToken: widget.idToken, profile: widget.profile); })); }),
                    SizedBox(height: 25),
                    _navButton("Delete Profile", () { setState(() { displayDeleteProfileOverlay = true; } ); }, color: Colors.black.withOpacity(0.7)),
                  ])
                ], mainAxisAlignment: MainAxisAlignment.center),
                Spacer(),
                Row(
                  children: [
                    _signoutButton(),
                    SizedBox(width: 188)
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                SizedBox(height: 40)
              ],
            )
          ),
          displayDeleteProfileOverlay ? deleteProfileOverlay() : Material()
        ],
      )
    );
  }

}