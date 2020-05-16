import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';
import 'package:whereyouatfriend/utils/string_utils.dart';

class LoginViewModel {
  final TextEditingController postalCodeController;
  final TextEditingController cityController;

  final ValueNotifier<String> locationErrorMessage;
  final ValueNotifier<bool> isValidLocation;

  bool isFromGeolocator;

  final CitizenRepo _citizenRepo;

  double latitude;
  double longitude;

  LoginViewModel(this._citizenRepo)
      : postalCodeController = TextEditingController(),
        cityController = TextEditingController(),
        locationErrorMessage = ValueNotifier<String>(""),
        isValidLocation = ValueNotifier<bool>(false),
        isFromGeolocator = false;

  Future<void> verifyAddress() async {
    String validatorResult = await _locationValidator(
        postalCodeController.text, cityController.text);
    if (validatorResult == null) {
      locationErrorMessage.value = "";
    } else {
      locationErrorMessage.value = validatorResult;
    }
  }

  // TODO optimize call order more
  Future<String> _locationValidator(String postalCode, String city) async {
    if (StringUtils.isNullOrEmpty(postalCode) &&
        StringUtils.isNullOrEmpty(city))
      return "Please provide postal code and city";

    if (StringUtils.isNullOrEmpty(postalCode))
      return "Please provide postal code";

    if (StringUtils.isNullOrEmpty(city)) return "Please provide city";

    postalCode = postalCode.trim();
    city = city.trim();

    try {
      var address = "PO $postalCode, $city, Romania".trim();

      List<Placemark> placemarks =
          await Geolocator().placemarkFromAddress(address);

      if (placemarks.isEmpty) return "Please enter a valid posta code and city";

      if (placemarks[0].locality != city && placemarks[0].locality.isNotEmpty) {
        city = placemarks[0].locality;
        cityController.text = city;
      }

      if (placemarks[0].postalCode.isEmpty ||
          placemarks[0].postalCode != postalCode) {
        placemarks = await Geolocator()
            .placemarkFromAddress(" PO $postalCode, $city, Romania");
      }

      if (placemarks.isEmpty ||
          placemarks[0].postalCode != postalCode ||
          placemarks[0].locality != city) return "No valid location found";

      postalCodeController.text = postalCode;
      cityController.text = city;
      isValidLocation.value = true;

      latitude = placemarks[0].position.latitude;
      longitude = placemarks[0].position.longitude;
    } catch (error) {
      return "No valid location found";
    }
    return null;
  }

  createAccount() async => _citizenRepo.createCitizen(postalCodeController.text,
      cityController.text, isFromGeolocator, latitude, longitude);

  //TODO treat all request cases
  Future getCurrentLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted &&
        !(await Permission.locationWhenInUse.request().isGranted)) return;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isEmpty ||
        placemarks[0].postalCode.isEmpty ||
        placemarks[0].locality.isEmpty) {
      invalidateLocation();
      locationErrorMessage.value =
          "Location not found try moving somewhere else";
      return;
    }

    postalCodeController.text = placemarks[0].postalCode;
    cityController.text = placemarks[0].locality;
    isValidLocation.value = true;
    isFromGeolocator = true;
    latitude = placemarks[0].position.latitude;
    longitude = placemarks[0].position.longitude;
  }

  void invalidateLocation() => changeIsLocationValid(false);

  void changeIsLocationValid(bool newValue) {
    if (isValidLocation.value != newValue) {
      isValidLocation.value = newValue;
    }
  }

  void pageChanged() {
    isValidLocation.value = false;
    locationErrorMessage.value = "";
    isFromGeolocator = false;
  }

  void cleanup() {
    postalCodeController?.dispose();
    cityController?.dispose();
    locationErrorMessage?.dispose();
    isValidLocation?.dispose();
  }
}
