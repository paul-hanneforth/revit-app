import 'package:flutter/material.dart';
import 'package:revit/ui/hr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:revit/ui/loader.dart';
import 'package:revit/utils/analytics.dart';
import 'package:revit/utils/server.dart';

class EditProfilePage extends StatefulWidget {

  final String idToken;
  final ProfileResponse profile;

  EditProfilePage({
    @required this.idToken, 
    @required this.profile 
  }) : assert(idToken != null && profile != null);

  @override
  EditProfilePageState createState() => EditProfilePageState();

}
class EditProfilePageState extends State<EditProfilePage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final picker = ImagePicker();

  String headerURL = "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/landscape-404072.jpg?alt=media&token=eb039bae-aba4-41a7-87da-dd33c12b39e2";
  String profileImageURL = "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/profile-image3.png?alt=media";

  Future<bool> updateHeaderPicture(String downloadURL) async {

    final response = await updateProfile(widget.idToken, headerURL: downloadURL);
    return response.error;

  }
  Future<void> pickNewHeaderPicture() async {
    final String downloadURL= await _pickImage();
    final bool error = await updateHeaderPicture(downloadURL);
    if(error == false) {
      setState(() {
        headerURL = downloadURL;
      });
    }
  }

  Future<bool> updateProfilePicture(String downloadURL) async {

    final response = await updateProfile(widget.idToken, profileImageURL: downloadURL);
    return response.error;

  }  
  Future<String> _uploadImage(String path) async {
    FormData formData = new FormData.fromMap({
      "name": "file",
      "file": await MultipartFile.fromFile(path, filename: "jonhdoe.png")
    });
    final response = await uploadImage(formData);
    return response.downloadURL;
  }
  Future<dynamic> _cropImage(image) async {
    final croppedImage = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)
    );
    return croppedImage;
  }
  Future<String> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final croppedFile = await _cropImage(pickedFile);
    final path = croppedFile.path;

    // upload image to Firebase Storage
    final downloadURL = await _uploadImage(path);
    return downloadURL;
  }
  Future<void> pickNewProfilePicture() async {
    final String downloadURL= await _pickImage();
    final bool error = await updateProfilePicture(downloadURL);
    if(error == false) {
      setState(() {
        profileImageURL = downloadURL;
      });
    }
  }

  void goBack() async {
    showLoader(context);
    // get input data
    final String name = nameController.text;
    final String username = usernameController.text;
    /* final bool formValid = */ _formKey.currentState.validate();

    if(username != widget.profile.username && username != null) {
      final response = await updateProfile(widget.idToken, name: name, username: username);
      print(response.message);
    }
    if(name != widget.profile.name && name != null) {
      final response = await updateProfile(widget.idToken, name: name);
      print(response.message);
    }

    removeLoader(context);
    Navigator.of(context).pop();
  }

  Widget _profileImage(String downloadURL) {
    return Container(
      width: 115,
      height: 115,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Color(0xFFE9E9E9)),
        shape: BoxShape.circle,
        color: Colors.grey,
        image: downloadURL != null ? DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(downloadURL)
        ) : null
      ),
    );
  }
  Widget _backHeader(Function onTap) {
    return Column(children: [
      SizedBox(height: 50),
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
  Widget _selectNewHeader() {
    return Stack(
      children: [
        Container(
          width: 332,
          height: 151,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(headerURL), // "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/landscape-404072.jpg?alt=media&token=eb039bae-aba4-41a7-87da-dd33c12b39e2"),
              fit: BoxFit.cover
            ),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1)
          ),
        ),
        Container(
          width: 332,
          height: 151,
          child: Center(
            child: Column(children: [
              SizedBox(height: 53),
              Container(
                width: 182,
                height: 43,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE9E9E9), width: 2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () { pickNewHeaderPicture(); },
                    child: Center(
                      child: Text("Select new header", style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white
                      )),
                    )
                  )
                )
              )
            ], mainAxisAlignment: MainAxisAlignment.center,)
          )
        )
      ],
    );
  }
  Widget _selectNewPicture() {
    return Column(
      children: [
        _profileImage(profileImageURL), // "https://firebasestorage.googleapis.com/v0/b/revit-f67b2.appspot.com/o/profile-image3.png?alt=media"),
        SizedBox(height: 19),
        Container(
          width: 179,
          height: 43,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.13), width: 2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () { pickNewProfilePicture(); },
              child: Center(
                child: Text("Select new picture", style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.9)
                )),
              )
            )
          )
        )
      ],
    );
  }
  Widget _textField(labelText, controller, initialValue, validator) {
    return Container(
      width: 288,
      child: TextFormField(
        controller: controller..text = initialValue,
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
 
  bool displayDeleteProfileOverlay = false;

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    analyticsSetCurrentScreen("edit_profile_page");

    setState(() {
      if(widget.profile != null) {
        if(widget.profile.headerURL != null) headerURL = widget.profile.headerURL;
        if(widget.profile.profileImageURL != null) profileImageURL = widget.profile.profileImageURL;
      } 
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.profile != null ? Container(
        color: Colors.white,
        child: ListView(
          children: [
          Column(
            children: [
              _backHeader(() { goBack(); }),
              SizedBox(height: 41),
              _selectNewHeader(),
              SizedBox(height: 50),
              _selectNewPicture(),
              SizedBox(height: 55),
              Form(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  children: [
                    _textField("Full Name", nameController, widget.profile.name, (String value) {
                      if(value == "" || value == "null") {
                        return "You must provide a name!";
                      } else if(value.startsWith(" ")) {
                        return "Your name can't start with whitespace!";
                      } else if(value.endsWith(" ")) {
                        return "Your name can't end with whitespace!";
                      }
                      return null;
                    }),
                    SizedBox(height: 24),
                    _textField("Username", usernameController, widget.profile.username, (String value) {
                      if(value.contains(" ")) {
                        return "Your username can't contain spaces!";
                      } else if(value == "" || value == null) {
                        return "Your must set a username!";
                      }
                      return null; 
                    })
                  ],
                ),
              )
            ],
            ),
        ])
      ) : Container(
        child: Center(
          child: loader(),
        ),
      )
    );
  }

}