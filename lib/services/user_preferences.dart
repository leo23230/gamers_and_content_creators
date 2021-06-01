import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences _preferences;
  //keys//
  static const maxRadiusKey = 'maxRadius';
  static const ageMinKey = 'ageMin';
  static const ageMaxKey = 'ageMax';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Radius//
  static Future setMaxRadius(double radius) async {
    await _preferences.setDouble(maxRadiusKey, radius);
  }
  static double getMaxRadius() => _preferences.getDouble(maxRadiusKey);
  ////

  //Age//
  static Future setAgeMin(double ageMin) async{
    await _preferences.setDouble(ageMinKey, ageMin);
  }
  static double getAgeMin() => _preferences.getDouble(ageMinKey);
  static Future setAgeMax(double ageMax) async{
    await _preferences.setDouble(ageMaxKey, ageMax);
  }
  static double getAgeMax() => _preferences.getDouble(ageMaxKey);

}