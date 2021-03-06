import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthfix/components/keep_alive_page.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/cart/cart_screen.dart';
import 'package:healthfix/screens/category/category_screen.dart';
import 'package:healthfix/screens/explore_fitness/explore_screen.dart';
import 'package:healthfix/screens/home/components/home_screen_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;
  // num _counter = 0;
  PageController _tabsPageController;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // AndroidNotificationChannel channel = AndroidNotificationChannel(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     description:
  //         'This channel is used for important notifications.', // description
  //     importance: Importance.high,
  //     playSound: true);

  /// Initializes shared_preference
  void sharedPrefInit() async {
    try {
      /// Checks if shared preference exist
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.getString("app-name");
    } catch (err) {
      /// setMockInitialValues initiates shared preference
      /// Adds app-name
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("app-name", "healthfix");
    }
  }

  @override
  void initState() {
    sharedPrefInit();

    super.initState();
    _tabsPageController = PageController();
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     RemoteNotification notification = message.notification;
    //     AndroidNotification android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       flutterLocalNotificationsPlugin.show(
    //           notification.hashCode,
    //           notification.title,
    //           notification.body,
    //           NotificationDetails(
    //             android: AndroidNotificationDetails(
    //               channel.id,
    //               channel.name,
    //               channelDescription: channel.description,
    //               color: Colors.blue,
    //               playSound: true,
    //               icon: '@mipmap/ic_launcher',
    //             ),
    //           ));
    //     }
    //   });

    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     RemoteNotification notification = message.notification;
    //     AndroidNotification android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) => PopUpDialog(),
    //       );
    //       // showDialog(
    //       //     context: context,
    //       //     builder: (_) {
    //       //       return AlertDialog(
    //       //         title: Text(notification.title),
    //       //         content: SingleChildScrollView(
    //       //           child: Column(
    //       //             crossAxisAlignment: CrossAxisAlignment.start,
    //       //             children: [Text(notification.body)],
    //       //           ),
    //       //         ),
    //       //       );
    //       //     });
    //     }
    //   });
  }

  @override
  void dispose() {
    super.dispose();
    _tabsPageController.dispose();
  }

  void _onItemTapped(int index) {
    _tabsPageController.animateToPage(
      index,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  // void showNotification() {
  //   setState(() {
  //     _counter++;
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //     0,
  //     "Testing $_counter",
  //     "How you doing?",
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(channel.id, channel.name,
  //           channelDescription: channel.description,
  //           importance: Importance.high,
  //           color: Colors.blue,
  //           playSound: true,
  //           icon: '@mipmap/ic_launcher'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        statusBarColor: kPrimaryColor,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        drawer: HomeScreenDrawer(),
        appBar: AppBar(
          // foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor.withOpacity(0.9),

          systemOverlayStyle: SystemUiOverlayStyle(
            // For Android.
            // Use [light] for white status bar and [dark] for black status bar.
            statusBarIconBrightness: Brightness.light,
            statusBarColor: kPrimaryColor,
            // For iOS.
            // Use [dark] for white status bar and [light] for black status bar.
            statusBarBrightness: Brightness.dark,
          ),
          toolbarHeight: 0,
        ),
        body: PageView(
            controller: _tabsPageController,
            allowImplicitScrolling: true,
            onPageChanged: (num) {
              setState(() {
                _selectedIndex = num;
              });
            },
            children: [
              KeepAlivePage(child: Body(goToCategory)),
              KeepAlivePage(child: CategoryScreen()),
              KeepAlivePage(child: ExploreScreen()),
              CartScreen(),
            ]),
        // drawer: HomeScreenDrawer(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedLabelStyle: cusBodyStyle(fontSize: getProportionateScreenHeight(12)),
      unselectedLabelStyle: cusBodyStyle(fontSize: getProportionateScreenHeight(12)),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          activeIcon: Icon(Icons.home_filled),
          label: ('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          activeIcon: Icon(Icons.grid_view_rounded),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.verified_rounded),
          activeIcon: Icon(Icons.verified_rounded),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_rounded),
          activeIcon: Icon(Icons.shopping_bag_rounded),
          label: 'Cart',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black.withOpacity(0.6),
      unselectedItemColor: Colors.black.withOpacity(0.6),
      selectedIconTheme: IconThemeData(color: Colors.cyan),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
    );
  }

  void goToCategory() {
    setState(() {
      _selectedIndex = 1;
      _onItemTapped(1);
    });
  }
}
