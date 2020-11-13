import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void initializeAnalytics() async {
  await Firebase.initializeApp();

  if(kDebugMode) {
    await FirebaseAnalytics().setAnalyticsCollectionEnabled(false);
    print("Firebase Analytics not enabled!");
  } else {
    await FirebaseAnalytics().setAnalyticsCollectionEnabled(true);
    print("Firebase Analytics enabled!");
  }

}
void analyticsSetCurrentScreen(String screenName) async {

  print("Switching to screen: $screenName");
  await FirebaseAnalytics().setCurrentScreen(screenName: screenName, screenClassOverride: screenName);

}
void analyticsLogSignUp(signUpMethod) async {

  await FirebaseAnalytics().logSignUp(signUpMethod: signUpMethod);
  await FirebaseAnalytics().logEvent(name: "sign-up-custom-event");
    
}
void analyticsLogAppStoreRedirect() async {

  await FirebaseAnalytics().logEvent(name: "app-store-redirect");

}
void analyticsLogEvent(eventName) async {

  await FirebaseAnalytics().logEvent(name: eventName);

}