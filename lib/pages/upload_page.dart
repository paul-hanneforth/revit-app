import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:dio/dio.dart';
import 'package:revit/pages/home_page.dart';
import 'package:revit/ui/loader.dart';
import 'package:revit/ui/image.dart' as image;
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart' as server;

class AnimatedButton extends StatelessWidget {

  final bool loading;
  final bool done;
  final bool error;
  final Function onTap;

  AnimatedButton({ this.loading = false, this.done = false, this.error, this.onTap });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      width: loading || done ? 65 : 187,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xD9000000),
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
        child: Container(
          child: InkWell(
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                curve: Curves.fastOutSlowIn,
                opacity: loading ? 0.0 : 1.0,
                child: !done ? Text("Post", style: new TextStyle(color: Colors.white, fontSize: 26.0, fontFamily: "Poppins", fontWeight: FontWeight.w600)) : 
                (error ? Icon(Icons.error, color: Colors.white) : Icon(Icons.check, color: Colors.white,)),
              )
            ),
            onTap: () { onTap(); },
          )
        )
      ),
    );
  }

}

class UploadPage extends StatefulWidget {

  final String idToken;

  UploadPage({ 
    @required this.idToken 
  }) : assert(idToken != null);

  @override
  State createState() => new UploadPageState();

}
class UploadPageState extends State<UploadPage> {

  final picker = ImagePicker();
  bool pickedImage = false;
  String downloadURL;

  Future<String> uploadImage(String path) async {
    FormData formData = new FormData.fromMap({
      "name": "file",
      "file": await MultipartFile.fromFile(path, filename: "jonhdoe.png")
    });
    final response = await server.uploadImage(formData);

    return response.downloadURL;
  }
  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile == null) return;
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)
    );
    if(croppedFile == null) return;

    // upload image to Firebase Storage
    final String downloadURLResult = await uploadImage(croppedFile.path);

    // update state
    setState(() {
      pickedImage = true;
      downloadURL = downloadURLResult;
    });
  }
  
  bool loading = false;
  bool done = false;
  bool error = false;

  void runLoadingAnimation() {
    setState(() {
      loading = true;
    });
  }
  void completeLoadingAnimation(bool errorHappened) {
    setState(() {
      loading = false;
      done = true;
      error = errorHappened;
    });
  }

  Widget buttonAnimated() {
    return AnimatedButton(loading: loading, done: done, error: error, onTap: () {
      if(done) return;

      runLoadingAnimation();

      server.addImage(widget.idToken, downloadURL).then((server.Response response) {
        completeLoadingAnimation(response.error);
        analyticsLogEvent("uploaded-image");
        Future.delayed(Duration(milliseconds: 1000)).then((value) { 
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(idToken: widget.idToken, gotoProfilePage: true )), (route) => false);
        });
      });
    });
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

    analyticsSetCurrentScreen("upload_page");

    pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return pickedImage ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image.Image(imageURL: downloadURL), // "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/landscape-404072.jpgalt=media&token=4f6ce117-43f8-4d6c-b678-5e49298ece2c"),
          SizedBox(height: 80),
          buttonAnimated()
        ],
      )
    ) : loader();
  }

}