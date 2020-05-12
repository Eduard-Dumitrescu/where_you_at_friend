import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  final ValueNotifier<String> _locationErrorMessage = ValueNotifier<String>("");

  final ValueNotifier<bool> _isValidLocation = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: TextFormField(
            onChanged: (value) async {
              if (_isValidLocation.value) {
                _isValidLocation.value = false;
              }
            },
            textAlign: TextAlign.center,
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
            onChanged: (value) async {
              if (_isValidLocation.value) {
                _isValidLocation.value = false;
              }
            },
            textAlign: TextAlign.center,
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
          child: ValueListenableBuilder<String>(
              valueListenable: _locationErrorMessage,
              builder: (context, errorString, _) {
                return errorString.isEmpty
                    ? Container()
                    : Center(
                        child: Text(
                          errorString,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
              }),
        ),
        Flexible(
          child: ValueListenableBuilder<bool>(
              valueListenable: _isValidLocation,
              builder: (context, isLocationValid, _) {
                return !isLocationValid
                    ? Container()
                    : Center(
                        child: Text(
                          " Found valid postal code ${_postalCodeController.text} with city ${_cityController.text}, if correct press create account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
              }),
        ),
        Flexible(
          child: Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  String validatorResult = await _locationValidator(
                      _postalCodeController.text, _cityController.text);
                  if (validatorResult == null) {
                    _locationErrorMessage.value = "";
                  } else {
                    _locationErrorMessage.value = validatorResult;
                  }
                },
                child: Text("Verify Address"),
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: _isValidLocation,
                  builder: (context, isValidLocation, _) {
                    return RaisedButton(
                      onPressed: !isValidLocation
                          ? null
                          : () async {
                              Provider.of<CitizenRepo>(context, listen: false)
                                  .createCitizen(_postalCodeController.text,
                                      _cityController.text, false);
                            },
                      child: Text("Create Account"),
                    );
                  }),
            ],
          ),
        )
      ],
    );
  }

  // TODO optimize call order more
  Future<String> _locationValidator(String postalCode, String city) async {
    if (StringUtils.isNullOrEmpty(postalCode) &&
        StringUtils.isNullOrEmpty(city))
      return "Please provide postal code and city";

    if (StringUtils.isNullOrEmpty(postalCode))
      return "Please provide postal code";

    if (StringUtils.isNullOrEmpty(city)) return "Please provide city";

    try {
      List<Placemark> placemarks = await Geolocator()
          .placemarkFromAddress(" PO $postalCode, $city, Romania ");

      if (placemarks.isEmpty) return "Please enter a valid posta code and city";

      if (placemarks[0].locality != city && placemarks[0].locality.isNotEmpty) {
        city = placemarks[0].locality;
        _cityController.text = city;
      }

      if (placemarks[0].postalCode.isEmpty ||
          placemarks[0].postalCode != postalCode) {
        placemarks = await Geolocator()
            .placemarkFromAddress(" PO $postalCode, $city, Romania ");
      }

      if (placemarks.isEmpty ||
          placemarks[0].postalCode != postalCode ||
          placemarks[0].locality != city) return "No valid location found";

      _cityController.text = city;
      _isValidLocation.value = true;
    } catch (error) {
      return "No valid location found";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
  }
}
