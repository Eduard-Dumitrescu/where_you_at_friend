import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/ui/login_page.dart';
import 'package:whereyouatfriend/ui/main_page.dart';
import 'package:whereyouatfriend/ui/splash_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, child) {
      switch (authState.state) {
        case ScreenState.Splash:
          return SplashScreen();
        case ScreenState.Login:
          return LoginPage();
        case ScreenState.Main:
          return MainPage();
        default:
          return Container();
      }
    });
  }
}
