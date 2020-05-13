import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whereyouatfriend/viewmodels/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<LoginViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (index) async => _viewModel.pageChanged(),
      children: <Widget>[
        CreateAccountFromInputWidget(_viewModel),
        CreateAccountFromGeolocatorWidget(_viewModel)
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.cleanup();
  }
}

class CreateAccountFromInputWidget extends StatelessWidget {
  final LoginViewModel _loginViewModel;

  const CreateAccountFromInputWidget(this._loginViewModel, {Key key})
      : super(key: key);

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
            onChanged: (value) async => _loginViewModel.invalidateLocation(),
            textAlign: TextAlign.center,
            controller: _loginViewModel.postalCodeController,
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
            onChanged: (value) async => _loginViewModel.invalidateLocation(),
            textAlign: TextAlign.center,
            controller: _loginViewModel.cityController,
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
          child: LocationSuccessErrorWidget(_loginViewModel),
        ),
        Flexible(
          child: Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () async => _loginViewModel.verifyAddress(),
                child: Text("Verify Address"),
              ),
              CreateAccountButtonWidget(_loginViewModel),
            ],
          ),
        )
      ],
    );
  }
}

class CreateAccountFromGeolocatorWidget extends StatelessWidget {
  final LoginViewModel _loginViewModel;

  const CreateAccountFromGeolocatorWidget(this._loginViewModel, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: RaisedButton(
            onPressed: () async => _loginViewModel.getCurrentLocation(),
            child: Text("Get current location"),
          ),
        ),
        Flexible(
          child: LocationSuccessErrorWidget(_loginViewModel),
        ),
        Flexible(
          child: CreateAccountButtonWidget(_loginViewModel),
        ),
      ],
    );
  }
}

class LocationSuccessErrorWidget extends StatelessWidget {
  final LoginViewModel _loginViewModel;

  const LocationSuccessErrorWidget(this._loginViewModel, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: ValueListenableBuilder<String>(
              valueListenable: _loginViewModel.locationErrorMessage,
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
              valueListenable: _loginViewModel.isValidLocation,
              builder: (context, isLocationValid, _) {
                return !isLocationValid
                    ? Container()
                    : Center(
                        child: Text(
                          " Found valid postal code ${_loginViewModel.postalCodeController.text} with city ${_loginViewModel.cityController.text}, if correct press create account",
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
      ],
    );
  }
}

class CreateAccountButtonWidget extends StatelessWidget {
  final LoginViewModel _loginViewModel;

  const CreateAccountButtonWidget(this._loginViewModel, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _loginViewModel.isValidLocation,
        builder: (context, isValidLocation, _) {
          return RaisedButton(
            onPressed: !isValidLocation
                ? null
                : () async => _loginViewModel.createAccount(),
            child: Text("Create Account"),
          );
        });
  }
}
