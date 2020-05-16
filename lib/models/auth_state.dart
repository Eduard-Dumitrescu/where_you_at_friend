import 'package:flutter/cupertino.dart';
import 'package:whereyouatfriend/DeviceCache/SharedPreferences/shared_preference_repo.dart';
import 'package:whereyouatfriend/models/citizen.dart';

enum ScreenState { Splash, Login, Main }

class AuthState with ChangeNotifier {
  ScreenState state;
  SharedPreferenceRepo _sharedPreferenceRepo;
  Citizen _currentCitizen;

  AuthState() {
    state = ScreenState.Splash;
    _currentCitizen = null;
  }

  void setSharedPreferenceRepo(SharedPreferenceRepo sharedPreferenceRepo) {
    if (_sharedPreferenceRepo == null) {
      _sharedPreferenceRepo = sharedPreferenceRepo;
    }
    verifyStatus();
  }

  Future verifyStatus() async {
    return _sharedPreferenceRepo.getCurrentCitizen().then((citizen) {
      _currentCitizen = citizen;
      if (citizen == null && !isLoginScreen()) {
        setLoginScreen();
      } else if (citizen != null && !isMainScreen()) {
        setMainScreen();
      }
    });
  }

  Future<Citizen> getCurrentCitizen() async {
    await verifyStatus();
    return _currentCitizen;
  }

  void setCitizen(Citizen citizen) {
    _sharedPreferenceRepo
        .setCurrentCitizen(citizen)
        .then((value) => verifyStatus());
  }

  void setSplashScreen() {
    if (state != ScreenState.Splash) {
      state = ScreenState.Splash;
      notifyListeners();
    }
  }

  void setLoginScreen() {
    if (state != ScreenState.Login) {
      state = ScreenState.Login;
      notifyListeners();
    }
  }

  void setMainScreen() {
    if (state != ScreenState.Main) {
      state = ScreenState.Main;
      notifyListeners();
    }
  }

  bool isSplashScreen() => state == ScreenState.Splash;

  bool isLoginScreen() => state == ScreenState.Login;

  bool isMainScreen() => state == ScreenState.Main;
}
