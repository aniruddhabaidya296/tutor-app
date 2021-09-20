

import 'package:firebase_analytics/firebase_analytics.dart';

void startFirebaseAnalyticsServices({required FirebaseAnalytics analytics,required String screenName}) async {
  print("startFirebaseAnalyticsServices() hit... ");
  await sendAnalytics(analytics: analytics,screenName: screenName);
  await currentScreen(analytics: analytics,screenName: screenName);
}

Future<Null> sendAnalytics({required FirebaseAnalytics analytics,required String screenName}) async {
  await analytics.logEvent(name: screenName, parameters: {});
  print("sendAnalytics() hit... ");
}

Future<Null> currentScreen({required FirebaseAnalytics analytics,required String screenName}) async {
  await analytics.setCurrentScreen(
      screenName: screenName, screenClassOverride: screenName);
  print("setCurrentScreen() hit... ");
}
