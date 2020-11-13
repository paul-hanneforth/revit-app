import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

// Google
Future<void> signOutOfGoogle() async {
  await Firebase.initializeApp();
  await googleSignIn.disconnect();
  await googleSignIn.signOut();
  await _auth.signOut();
}
Future<User> signInWithGoogle() async {
  await Firebase.initializeApp();

  print("A");
  // Sign-In
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  print("AB");
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
  print("B");

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  print("C");

  final UserCredential authResult = await _auth.signInWithCredential(credential);
  print("authResult: $authResult");
  final User user = authResult.user;
  print("user: $user");

  return user;

}
Future<String> authenticateWithGoogle() async {
  try {
    await Firebase.initializeApp();

    final user = await signInWithGoogle();
    final idToken = await user.getIdToken();
    return idToken;

  } catch(e) {
    return null;
  }
}

Future<String> isAuthenticated() async {
  await Firebase.initializeApp();

  if(_auth.currentUser != null) {
    print("The user is currently logged in!");
    final idToken = await _auth.currentUser.getIdToken();
    return idToken;
  }

  print("The user is currently not logged in!");
  return null;

}