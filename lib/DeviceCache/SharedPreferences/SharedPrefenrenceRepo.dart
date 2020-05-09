import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/utils/StringUtils.dart';

class SharedPreferenceRepo {
  Future<Citizen> getCurrentCitizen() async {
    String citizenString = await _getString(CURRENT_CITIZEN) ?? "";
    if (citizenString.isEmpty) return null;

    Citizen currentCitizen = jsonDecode(await _getString(CURRENT_CITIZEN));
    if (StringUtils.isNullOrEmpty(currentCitizen.userGuid)) return null;

    return currentCitizen;
  }

  Future setCurrentCitizen(Citizen citizen) =>
      _setString(CURRENT_CITIZEN, jsonEncode(citizen));

  Future _setString(String key, String value) => SharedPreferences.getInstance()
      .then((prefs) => prefs.setString(key, value));

  Future _getString(String key) =>
      SharedPreferences.getInstance().then((prefs) => prefs.getString(key));

  static const String CURRENT_CITIZEN = "CurrentCitizen";
}
