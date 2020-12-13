import 'package:dio/dio.dart';
import 'package:revit/config.dart';


/* response */
class Response {
  final bool error;
  final String message;

  Response({ this.error, this.message });
}
class ImageResponse extends Response {
  final String downloadURL;
  final String profile;
  final String id;
  final double value;
  final double score;
  final int upvotes;
  final int downvotes;

  ImageResponse({ error, message, this.downloadURL, this.profile, this.id, this.value, this.upvotes, this.downvotes, this.score }) : super(error: error, message: message);
}
class ProfileResponse extends Response {
  final String name;
  final String username;
  final String profileImageURL;
  final String headerURL;
  final List<String> images;
  final double score;
  final String id;
  final int rank;

  ProfileResponse({ error, message, this.name, this.username, this.profileImageURL, this.headerURL, this.images, this.score, this.id, this.rank }) : super(error: error, message: message);
}
class StackResponse extends Response {
  final String id;
  final List<String> images;

  StackResponse({ error, message, this.id, this.images }) : super(error: error, message: message);
}
class UploadImageResponse extends Response {
  final String downloadURL;

  UploadImageResponse({ error, message, this.downloadURL }) : super(error: error, message: message);
}
class PingResponse extends Response {
  final String version;

  PingResponse({ error, message, this.version }) : super(error: error, message: message);
}
class RanklistResponse extends Response {
  final List<ProfileResponse> profiles;

  RanklistResponse({ error, message, this.profiles }) : super(error: error, message: message);
}


/* functions */
Future<Map<String, dynamic>> fetch(String address, [ Map<String, dynamic> data ]) async {
  final response = await Dio().post(address, data: data);
  return response.data;
}

// ping
Future<PingResponse> ping() async {
  
  final response = await fetch("$serverAddress/ping");
  print("response $response");
  final pingResponse = new PingResponse(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"],
    version: response["version"]
  );

  return pingResponse;

}

// stack
Future<StackResponse> fetchStack(String idToken) async {

  final response = await fetch("$serverAddress/stack/get", {
    "idToken": idToken
  });
  final stackResponse = new StackResponse(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"],
    id: response["stack"]["id"],
    images: List<String>.from(response["stack"]["images"])
  );

  return stackResponse;

}
Future<Response> rateStack(String idToken, String stackId, String likedImage) async {

  final response = await fetch("$serverAddress/stack/rate", {
    "likedImage": likedImage,
    "stack": stackId,
    "idToken": idToken
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );
  return formattedResponse;

}

// image
Future<ImageResponse> fetchImage(String imageId) async {

  final response = await fetch("$serverAddress/image/get", {
    "imageId": imageId
  });
  final imageResponse = new ImageResponse(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"],
    downloadURL: response["downloadURL"],
    profile: response["profile"],
    id: response["id"],
    value: response["value"].toDouble(),
    upvotes: response["upvotes"],
    downvotes: response["downvotes"],
    score: response["score"].toDouble()
  );
  return imageResponse;

}
Future<Response> addImage(String idToken, String downloadURL) async {

  final response = await fetch("$serverAddress/image/add", {
    "idToken": idToken,
    "downloadURL": downloadURL
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );
  return formattedResponse;

}
Future<UploadImageResponse> uploadImage(FormData formData) async {

  final rawResponse = await Dio().post("$serverAddress/image/upload", data: formData);
  final response = rawResponse.data;
  final uploadImageResponse = new UploadImageResponse(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"],
    downloadURL: response["downloadURL"]
  );

  return uploadImageResponse;

}
Future<Response> removeImage(String idToken, String imageId) async {

  final response = await fetch("$serverAddress/image/remove", {
    "idToken": idToken,
    "imageId": imageId
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );

  return formattedResponse;

}

// profile
Future<ProfileResponse> fetchProfile(String idToken, [String profileId]) async {

  final response = await fetch("$serverAddress/profile/get", {
    "idToken": idToken,
    "profileId": profileId 
  });
  final profileResponse = new ProfileResponse(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"],
    name: response["name"],
    username: response["username"],
    profileImageURL: response["profileImageURL"],
    headerURL: response["headerURL"],
    images: List<String>.from(response["images"]),
    score: response["score"].toDouble(),
    rank: response["rank"]
  );

  return profileResponse;

}
Future<Response> updateProfilesLastSeen(String idToken) async {

  final response = await fetch("$serverAddress/profile/lastSeen", {
    "idToken": idToken,
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );

  return formattedResponse;

}
Future<Response> addProfile(String idToken, String name, String username) async {

  final response = await fetch("$serverAddress/profile/add", {
    "idToken": idToken,
    "name": name,
    "username": username
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );

  return formattedResponse;

}
Future<bool> profileExists(String idToken) async {

  final response = await fetch("$serverAddress/profile/exists", {
    "idToken": idToken
  });
  final bool exists = response["profileExists"];

  return exists;

}
Future<Response> updateProfile(String idToken, { String username, String name, String profileImageURL, String headerURL }) async {

  final response = await fetch("$serverAddress/profile/update", {
    "idToken": idToken,
    "username": username,
    "name": name,
    "profileImageURL": profileImageURL,
    "headerURL": headerURL
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );

  return formattedResponse;

}
Future<Response> removeProfile(String idToken) async {

  final response = await fetch("$serverAddress/profile/remove", {
    "idToken": idToken,
  });
  final formattedResponse = new Response(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"]
  );

  return formattedResponse;

}

// ranklist
Future<RanklistResponse> fetchRanklist(String idToken, [String lastProfileId]) async {

  final response = await fetch("$serverAddress/ranklist/get", {
    "idToken": idToken,
    "lastProfileId": lastProfileId
  });
  final ranklistResponse = new RanklistResponse(
    error: response["error"] == false ? false : true,
    message: response["error"] == false ? response["message"] : response["error"]["message"],
    profiles: List<ProfileResponse>.from(response["ranklist"].toList().map((element) => 
      ProfileResponse(
        error: false,
        message: null,
        score: element["score"].toDouble(),
        username: element["username"],
        name: element["name"],
        images: List<String>.from(element["images"]),
        headerURL: element["headerURL"],
        profileImageURL: element["profileImageURL"],
        id: element["id"],
        rank: element["rank"]
      )
    ).toList())
  );

  return ranklistResponse;

}