import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/size_config.dart';
// import 'package:healthfix/wrappers/authentification_wrapper.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'screens/home/home_screen.dart';
import 'theme.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: AnimatedSplashScreen(
          splash: Container(
              child:
                  Image.asset('assets/logo/hf-logo-cropped.png', width: 200)),
          duration: 1000,
          backgroundColor: Colors.white,
          nextScreen: HomeScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
        ));
  }
}
