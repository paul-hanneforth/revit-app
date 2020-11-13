import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void initializeCrashlytics() async {
  await Firebase.initializeApp();
  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);

  if(kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  if(FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    print("Crashlytics enabled!");
  } else {
    print("Crashlytics not enabled!");
  }

  // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FirebaseCrashlytics.instance.crash();
}