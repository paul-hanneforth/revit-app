import 'package:flutter/material.dart';
import 'package:revit/pages/image_page.dart';
import 'package:revit/pages/profile_page.dart';
import 'package:revit/ui/hr.dart';
import 'package:revit/ui/loader.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/formatter.dart';
import 'package:revit/utils/server.dart';

class MicroImage extends StatefulWidget {

  final String imageId;

  MicroImage({
    this.imageId
  });

  State createState() => new MicroImageState();

}
class MicroImageState extends State<MicroImage> {

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

    fetchImage(widget.imageId).then((ImageResponse response) {
      setState(() {
        image = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        image: image != null ? DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image.downloadURL)
        ) : null
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () { 
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ImagePage(
              imageId: image.id,
              image: image,
            )));
          }
        )
      ),
    );
  }

}

class RanklistPage extends StatefulWidget {

  final String idToken;

  RanklistPage({
    @required this.idToken
  }) : assert(idToken != null);

  @override
  State createState() => new RanklistPageState();

}
class RanklistPageState extends State<RanklistPage> {

  Widget box() {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18, top: 7, bottom: 7),
        child: Row(children: [
          Text("Your Rank", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 22, color: Colors.black.withOpacity(0.6))),
          SizedBox(width: 8),
          Text("#" + format(profileRank, Format.minified), style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 21))
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
    );
  }
  Widget topElement(ProfileResponse profile) {
    List<Widget> row = [];
    for(var i = 0; i < profile.images.length; i++ ) {
      if(i == 0 || i == profile.images.length) {
        row.add(MicroImage(imageId: profile.images[i]));
      } else {
        row.add(new SizedBox(width: 27));
        row.add(MicroImage(imageId: profile.images[i]));
      }
    }
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Scaffold(
              body: ProfilePage(idToken: widget.idToken, profileId: profile.id, ownedByUser: false)
            )));
          },
            child: Row(children: [
              Text("#1", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 40)),
              SizedBox(width: 41),
              Column(children: [
                Text(profile.name, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 26)),
                Text("@" + profile.username, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 20)),
              ], crossAxisAlignment: CrossAxisAlignment.start,)
            ], mainAxisAlignment: MainAxisAlignment.center),
          )
        ),
        SizedBox(height: 28),
        Container(
          height: 90,
          child: Center(
            child: SingleChildScrollView(
              child: Row(children: row),
              scrollDirection: Axis.horizontal, 
            ),
          )
        ),
        SizedBox(height: 18),
        HR()
      ],
    );
  }
  Widget element(ProfileResponse profile, BuildContext context) {
    return Column(
      children: [
        Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: () { 
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new Scaffold(
            body: ProfilePage(idToken: widget.idToken, profileId: profile.id, ownedByUser: false)
          )));
        },
        child: Column(children: [
        SizedBox(height: 6),
        Text("#" + profile.rank.toString(), style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 30)),
        SizedBox(height: 4),
        Text(profile.name, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 19)),
        Text("@" + profile.username, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 16)),
        SizedBox(height: 16),
        HR()
        ])
        )
        ),
      ],
    );
  }
  Widget header() {
    return Column(
      children: [
        SizedBox(height: 42),
        Row(children: [
          SizedBox(width: 44),
          Text("Ranklist", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w800, fontSize: 28))
        ]),
        SizedBox(height: 11),
        Row(children: [
          SizedBox(width: 39),
          box()
        ]),
        SizedBox(height: 35),
        HR(),
      ]
    );
  }

  Future<List<ProfileResponse>> fetchNextElementsInRanklist([ProfileResponse lastProfileFetched]) async {
    final RanklistResponse ranklist = await fetchRanklist(widget.idToken, lastProfileFetched != null ? lastProfileFetched.id : null);
    return ranklist.profiles;
  }
  void loadNewElements() async {
    // get next elements in ranklist
    List<ProfileResponse> list = profiles.length == 0 ? await fetchNextElementsInRanklist() : await fetchNextElementsInRanklist(profiles[profiles.length - 1]);
    setState(() {
      // if the list doesn't return any elements the ranklist doesn't have any new profiles
      if(list.length == 0) {
        done = true;
      }
      list.forEach((element) {
        if(!contains(profiles, element)) profiles.add(element);
      });
    });
  }

  bool contains(List<ProfileResponse> list, ProfileResponse profile) {
    for(var i = 0; i < list.length; i ++ ) {
      if(list[i].id == profile.id) {
        return true;
      }
    }
    return false;
  }

  bool done = false;
  bool loading = false;
  List<ProfileResponse> profiles = [];
  int profileRank = 0;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    analyticsSetCurrentScreen("ranklist_page");
  
    fetchProfile(widget.idToken).then((profile) {
      if(profile.rank == null) return;
      setState(() {
        profileRank = profile.rank;
      });
    });
    loadNewElements();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: profiles.length + 1,
        itemBuilder: (BuildContext context, int index) {
          print('ListView.builder is building index $index');

          // if it's the first index, display the header
          if(index == 0) {
            return header();
          }

          // if it's the second index, this means that this is the element with the first rank
          // and for the profile with the first rank, we display a special widget
          if(index == 1) {
            return Column(children: [
              SizedBox(height: 18),
              topElement(profiles[index - 1]),
            ]);
          }
  
          // execute this, if this is the last element loaded and if they are still profiles to load in the ranklist left
          if(index == profiles.length && !done) {
            loadNewElements();
          }

          // if the new element is currently loading display a loading animation
          // !!! This part doesn't work yet
          if(loading) return Center(child: Column(children: [
            SizedBox(height: 20),
            loader(),
            SizedBox(height: 20)
          ]));

          return element(profiles[index - 1], context);
        },
      ),
    );
  }

}