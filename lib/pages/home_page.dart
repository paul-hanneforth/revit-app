import 'package:flutter/material.dart';
import 'package:revit/pages/profile_page.dart';
import 'package:revit/pages/ranklist_page.dart';
import 'package:revit/pages/rate_page.dart';
import 'package:revit/pages/upload_page.dart';
import 'package:revit/utils/analytics.dart';

class HomePage extends StatefulWidget {

  final String idToken;
  final bool gotoProfilePage;

  HomePage({
    @required this.idToken,
    this.gotoProfilePage = false
  }) : assert(idToken != null);

  @override
  State createState() => new HomePageState(); 

}
class HomePageState extends State<HomePage> {

  int navIndex = 0;
  bool gotoProfilePage = false;

  Widget getBody() {
    if(navIndex == 0) return RatePage(idToken: widget.idToken);
    if(navIndex == 1) return RanklistPage(idToken: widget.idToken);
    if(navIndex == 2) return UploadPage(idToken: widget.idToken);
    if(navIndex == 3) {
      if(gotoProfilePage) {
        gotoProfilePage = false;
        return ProfilePage(idToken: widget.idToken, scrollToBottom: true);
      }
      return ProfilePage(idToken: widget.idToken);
    }

    return Container();
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

    analyticsSetCurrentScreen("home_page");

    gotoProfilePage = widget.gotoProfilePage;

    if(widget.gotoProfilePage) setState(() {
      navIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int index) {
          // update state with new index
          setState(() {
            navIndex = index;
          });
        },
        currentIndex: navIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.star), title: Text("Rate")),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), title: Text("Rank")),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), title: Text("Upload")),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text("Profile")),
        ],
      ),
    );
  }

}