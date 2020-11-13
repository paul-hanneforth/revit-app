import 'package:flutter/material.dart';
import 'package:revit/pages/home_page.dart';
import 'package:revit/ui/loader.dart';
import 'package:revit/ui/snackbar.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart';
import 'package:revit/utils/login.dart';

class CreateProfilePage extends StatefulWidget {

  final String idToken;

  CreateProfilePage({
    @required this.idToken
  }) : assert(idToken != null);

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();

}
class _CreateProfilePageState extends State<CreateProfilePage> {

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  var loading = false;

  void cancel() async {
    if(loading) return;
    loading = true;

    await signOutOfGoogle();

    // go back one page
    Navigator.of(context).pop();

    loading = false;
  }
  void signup() async {
    if(loading) return;
    loading = true;

    // get input data
    final String name = nameController.text;
    final String username = usernameController.text;
    final bool result = _formKey.currentState.validate();
    if(result == false) return;

    showLoader(context);

    // create profile
    final Response response = await addProfile(widget.idToken, name, username);

    if(!response.error) {
      analyticsLogSignUp("not-configured");
      // if no error happened, redirect user to HomePage
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(idToken: widget.idToken)), (route) => false);
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) { return HomePage(widget._idToken); }));
    } else {
      removeLoader(context);
      createSnackbar(title: "Failed to create account!", description: response.message, scaffoldKey: scaffoldKey);
    }
    loading = false;
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

    analyticsSetCurrentScreen("create_profile_page");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Widget _button() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.black.withOpacity(0.84),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () { signup(); },
          child: Container(
            width: 191,
            height: 73,
            child: Center(
              child: Text("Signup",  style: new TextStyle(color: Colors.white, fontSize: 23.0, fontFamily: "Poppins", fontWeight: FontWeight.w700))
            ),
          )
        )
      )
    );
  }
  Widget _textField(labelText, controller, validator) {
    return Container(
      width: 288,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontFamily: "Poppins",
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          labelText: labelText,
        ),
        validator: validator,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(children: [
        SizedBox(height: 80),
        Row(children: [
          Text("Create Profile", style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black
          )),
          SizedBox(width: 63),
          InkWell(
            onTap: () { cancel(); },
            child: Text("Cancel", style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.6)
            )),
          )
        ], mainAxisAlignment: MainAxisAlignment.center),
        SizedBox(height: 31.0),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 2,
          color: Color(0xFFF6F6F6)
        ),
        SizedBox(height: 49),
        Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: [
          _textField("Full Name", nameController, (String value) {
            if(value == "" || value == "null") {
              return "You must provide a name!";
            } else if(value.startsWith(" ")) {
              return "Your name can't start with whitespace!";
            } else if(value.endsWith(" ")) {
              return "Your name can't end with whitespace!";
            }
            return null;
          }),
          SizedBox(height: 27),
          _textField("Username", usernameController, (String value) {
              if(value.contains(" ")) {
                return "Your username can't contain spaces!";
              } else if(value == "" || value == null) {
                return "Your must set a username!";
              }
              return null; 
            }
          ),])
        ),
        Expanded(
        child: Column(children: [
          Row(children: [
            _button(),
            SizedBox(width: 40)
          ], mainAxisAlignment: MainAxisAlignment.end),
          SizedBox(height: 40)
        ], mainAxisAlignment: MainAxisAlignment.end,)
        )
      ])
    );
  }

}