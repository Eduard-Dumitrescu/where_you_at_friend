import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/utils/string_utils.dart';

class SharedPreferenceRepo {
  String _CURRENT_CITIZEN = "CurrentCitizen";

  Future<Citizen> getCurrentCitizen() async {
    String citizenString = await _getString(_CURRENT_CITIZEN) ?? "";
    if (citizenString.isEmpty) return null;

    Citizen currentCitizen = Citizen.fromJson(jsonDecode(citizenString));
    if (StringUtils.isNullOrEmpty(currentCitizen.userGuid)) return null;

    return currentCitizen;
  }

  Future setCurrentCitizen(Citizen citizen) =>
      _setString(_CURRENT_CITIZEN, jsonEncode(citizen));

  Future _setString(String key, String value) => SharedPreferences.getInstance()
      .then((prefs) => prefs.setString(key, value));

  Future _getString(String key) =>
      SharedPreferences.getInstance().then((prefs) => prefs.getString(key));
}
