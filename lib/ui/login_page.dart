import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';
import 'package:whereyouatfriend/utils/string_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _postalCodeController =
      new TextEditingController();

  final TextEditingController _cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _mainBody(),
    );
  }

  _appBar() {
    return AppBar(
      title: Text("Hi"),
    );
  }

  _mainBody() {
    return Column(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: _postalCodeController,
            style: TextStyle(color: Colors.yellow, fontSize: 16),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(24.0),
                ),
              ),
              hintText: "Postal Code",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.deepPurple,
            ),
          ),
        ),
        Flexible(
          child: TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: _cityController,
            style: TextStyle(color: Colors.yellow, fontSize: 16),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(24.0),
                ),
              ),
              hintText: "City",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.deepPurple,
            ),
          ),
        ),
        Flexible(
          child: RaisedButton(
            onPressed: () {
              if (!StringUtils.isNullOrEmpty(_postalCodeController.text) &&
                  !StringUtils.isNullOrEmpty(_cityController.text)) {
                Provider.of<CitizenRepo>(context, listen: false).createCitizen(
                    _postalCodeController.text, _cityController.text, false);
              }
            },
            child: Text("Create Account"),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
  }
}
