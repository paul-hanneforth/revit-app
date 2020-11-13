import 'package:flutter/material.dart';
import 'package:revit/pages/image_page.dart';
import 'package:revit/pages/settings/settings_page.dart';
import 'package:revit/ui/hr.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart';

class MiniImage extends StatefulWidget {

  final String idToken;
  final String imageId;
  final bool ownedByUser;

  MiniImage({
    this.idToken, 
    this.imageId,
    this.ownedByUser = false
  });

  @override
  State createState() => new MiniImageState();

}
class MiniImageState extends State<MiniImage> {

  ImageResponse image;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    // fetch image using the provided imageId
    fetchImage(widget.imageId).then((ImageResponse imageResponse) {
      setState(() {
        image = imageResponse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      width: 165,
      height: 165,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        image: image != null ? DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image.downloadURL)
        ) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: () { 
            if(image == null) return;
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ImagePage(
              idToken: widget.idToken,
              imageId: image.id, 
              ownedByUser: widget.ownedByUser,
              image: image
            )));
          }
        )
      ),
    );
  }

}

class ProfilePage extends StatefulWidget {

  final String idToken;
  final String profileId;
  final bool ownedByUser;
  final bool scrollToBottom;

  ProfilePage({ 
    @required this.idToken, 
    this.profileId, 
    this.ownedByUser = true, 
    this.scrollToBottom = false 
  }) : assert(idToken != null);

  @override
  State createState() => new ProfilePageState();

}
class ProfilePageState extends State<ProfilePage> {

  Future loadProfile() async {

    final fetchedProfile = await fetchProfile(widget.idToken, widget.profileId != null ? widget.profileId : null);

    setState(() {
      profile = fetchedProfile;
    });

  }
  void scrollToBottom() async {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  String profileImageURL = "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/profile-image3.png?alt=media&token=36e3e6d5-8d89-4d08-96f5-51fbcaa88723";
  String headerURL = "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/landscape-404072.jpg?alt=media&token=eb039bae-aba4-41a7-87da-dd33c12b39e2";

  ProfileResponse profile;

  ScrollController scrollController = new ScrollController();

  Widget imageContainer(List<dynamic> postsList) {

    final List<List<String>> imageRows = [];

    postsList.forEach((imageId) {
      if(imageRows.length == 0) imageRows.add([]);
      if(imageRows[imageRows.length - 1].length == 0) {
        imageRows[imageRows.length - 1].add(imageId);
      } else if(imageRows[imageRows.length - 1].length == 1) {
        imageRows[imageRows.length - 1].add(imageId);
      } else {
        imageRows.add([]);
        imageRows[imageRows.length - 1].add(imageId);
      }
    });

    final List<Widget> list = new List<Widget>();
    imageRows.forEach((row) => {
      list.add(new Container(
        width: 345,
        child: Row(
          mainAxisAlignment: row.length > 1 ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            row.length > 0 ? Column(
              children: [
                SizedBox(height: 7.5,),
                MiniImage(
                  idToken: widget.idToken, 
                  imageId: row[0],
                  ownedByUser: widget.ownedByUser,
                ),
                SizedBox(height: 7.5,)
              ],
            ) : Container(),
            SizedBox(width: 15.0, ),
            row.length > 1 ? Column(
              children: [
                SizedBox(height: 7.5,),
                MiniImage(
                  idToken: widget.idToken, 
                  imageId: row[1],
                  ownedByUser: widget.ownedByUser,
                ),
                SizedBox(height: 7.5,)
              ],
            ) : Container(),
          ],
        )
      ))
    });
    return new Container(
      child: Column(
        children: list,
      )
    );

  }
  Widget profileImage(String downloadURL) {
    return Container(
      width: 115,
      height: 115,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.white),
        shape: BoxShape.circle,
        color: Colors.grey,
        image: downloadURL != null ? DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(downloadURL)
        ) : null
      ),
    );
  }
  Widget settingsContainer() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Center(
        child: IconButton(
          onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) { return SettingsPage(idToken: widget.idToken, profile: profile ); })); },
          icon: Icon(Icons.settings, color: Colors.black.withOpacity(0.8)),
        ),
      ),
    );
  }

  Widget header() {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 365,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(profile != null ? (profile.headerURL != null ? profile.headerURL : headerURL) : headerURL))),
        child: Column(
          children: [
            SizedBox(height: 85),
            profileImage(profile != null ? (profile.profileImageURL != null ? profile.profileImageURL : profileImageURL) : profileImageURL),
            SizedBox(height: 25),
            Text(profile != null ? profile.name : "",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            SizedBox(height: 2),
            Text(profile != null ? "@" + profile.username : "",
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))
          ],
        ),
      ),
      Column(
        children: [
          SizedBox(height: 340.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 129,
                  height: 46,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("level",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.60))),
                      SizedBox(width: 11.0),
                      Text(profile != null ? profile.score.toInt().toString() : "0",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                    ],
                  )),
              widget.ownedByUser ? SizedBox(width: 30) : Material(),
              widget.ownedByUser ? settingsContainer() : Material()
            ],
          )
        ],
      )
    ]);
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

    analyticsSetCurrentScreen("profile_page");

    loadProfile();

    if(widget.scrollToBottom) scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        controller: scrollController,
        children: [
          header(),
          SizedBox(height: 42),
          Row(children: [
            Text("Posts", style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Colors.black
            )),
          ], mainAxisAlignment: MainAxisAlignment.center,),
          SizedBox(height: 12),
          HR(),
          SizedBox(height: 23),
          profile != null ? imageContainer(profile.images) : Material()
        ],
      ),
    );
  }

}