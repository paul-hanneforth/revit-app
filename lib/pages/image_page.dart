import 'package:flutter/material.dart';
import 'package:revit/ui/back.dart';
import 'package:revit/ui/image.dart' as imageWidget;
import 'package:revit/ui/loader.dart';
import 'package:revit/ui/outline_button.dart' as button;
import 'package:revit/ui/snackbar.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/formatter.dart';
import 'package:revit/utils/server.dart';

class ImagePage extends StatefulWidget {

  final String idToken;
  final String imageId;
  final bool ownedByUser;
  final ImageResponse image;

  ImagePage({
    @required this.imageId,
    this.idToken,
    this.ownedByUser = false,
    this.image
  }) : assert(imageId != null);

  @override
  ImagePageState createState() => ImagePageState();

}
class ImagePageState extends State<ImagePage> {

  Widget verticalHR() {
    return Container(
      width: 1,
      height: 66,
      color: Color(0xFFF6F6F6),
    );
  }
  Widget scoreIndicator(double score) {
    return Container(
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
            offset: Offset(0, 4)
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Score", style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.60)
            )),
            SizedBox(width: 11.0),
            Text(score != null ? score.toInt().toString() : (score != null ? score: "0"), style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.black
            )),
          ],
        )
    );
  }
  Widget deleteButton(Function onTap) {
    return button.OutlineButton(
      text: "Delete",
      onTap: onTap,
    );
  }
  Widget upvotesWidget(String upvotes) {
    return Row(
      children: [
        Text("Upvotes", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 22, color: Colors.black.withOpacity(0.6))),
        SizedBox(width: 13),
        Text(upvotes, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 21, color: Colors.black)),
      ],
    );
  }
  Widget downvotesWidget(String downvotes) {
    return Row(
      children: [
        Text(downvotes, style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: 21, color: Colors.black)),
        SizedBox(width: 13),
        Text("Downvotes", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500, fontSize: 22, color: Colors.black.withOpacity(0.6))),
      ],
    );
  }

  Future<void> deleteImage() async {
    showLoader(context);
    final Response response = await removeImage(widget.idToken, widget.imageId);
    removeLoader(context);
    if(response.error) return createSnackbar(scaffoldKey: scaffoldKey, title: "Failed to delete image!", description: response.message);
    Navigator.of(context).pop();
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
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

    analyticsSetCurrentScreen("image_page");

    image = widget.image;

    fetchImage(widget.imageId).then((ImageResponse imageResponse) {
      setState(() {
        image = imageResponse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: CustomScrollView(
        slivers: [
        SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          children: [
            // SizedBox(height: 80),
            SizedBox(height: 50),
            BackHeader(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 32),
            imageWidget.Image(imageURL: image != null ? image.downloadURL : null),
            SizedBox(height: 31),
            Row(children: [
              upvotesWidget(image != null ? format(image.upvotes, Format.minified) : "1"),
              SizedBox(width: 24),
              verticalHR(),
              SizedBox(width: 24),
              downvotesWidget(image != null ? format(image.downvotes, Format.minified) : "1")
            ], mainAxisAlignment: MainAxisAlignment.center),
            SizedBox(height: 47),
            Row(children: [
              scoreIndicator(image != null ? image.score : 0)
            ], mainAxisAlignment: MainAxisAlignment.center,),
            Spacer(),
            Row(children: [
              widget.ownedByUser ? deleteButton(() { deleteImage(); }) : Material(),
              SizedBox(width: 40)
            ], mainAxisAlignment: MainAxisAlignment.end,),
            SizedBox(height: 40)
          ],
        )
      )
      ]
      )
      )
    );
  }

}