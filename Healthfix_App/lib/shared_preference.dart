import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  dynamic getUser() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String jsonString = prefs.getString("user");
    var _res = jsonDecode(jsonString);
    return _res;
  }

  dynamic setUser(user) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    var valString = jsonEncode(user);
    var _res = prefs.setString("user", valString);
    return _res;
  }

  Future reset() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
  }

  Future hasUser() async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.containsKey('user');
  }
}
