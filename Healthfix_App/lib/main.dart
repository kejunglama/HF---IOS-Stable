import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:new_version/new_version.dart';

// import 'package:';
import 'app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );



  // void _checkVersion() async {
  //   final newVersion = NewVersion(
  //     androidId: "com.snapchat.android",
  //   );
  //   final status = await newVersion.getVersionStatus();
  //   newVersion.showUpdateDialog(
  //     context: context,
  //     versionStatus: status,
  //     dialogTitle: "UPDATE!!!",
  //     dismissButtonText: "Skip",
  //     dialogText: "Please update the app from " + "${status.localVersion}" + " to " + "${status.storeVersion}",
  //     dismissAction: () {
  //       SystemNavigator.pop();
  //     },
  //     updateButtonText: "Lets update",
  //   );
  //
  //   print("DEVICE : " + status.localVersion);
  //   print("STORE : " + status.storeVersion);
  // }

  runApp(App());
}

