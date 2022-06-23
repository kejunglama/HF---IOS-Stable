import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthfix/screens/home/home_screen.dart';
import 'package:healthfix/screens/sign_in/sign_in_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/services/database/user_database_helper.dart';

import '../shared_preference.dart';

class AuthenticationWrapper extends StatefulWidget {
  static const String routeName = "/authentication_wrapper";

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = new UserPreferences();
    // prefs.setUser("user");
    // prefs.getUser().then((user) => print("Id that was loaded: $user"));
    // prefs.getUser().then((user) => print("User: $user"));
    // print("prefs");

    return StreamBuilder(
      stream: AuthentificationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          UserDatabaseHelper()
              .getUserDataFromId(user.uid)
              .then((user) => prefs.setUser((user)));
          prefs.getUser().then((user) => print("User: $user"));

          return HomeScreen();
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
