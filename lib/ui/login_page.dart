import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.indigo,
        child: Center(
          child: RaisedButton(
            child: Text("Create User"),
          ),
        ));
  }
}
