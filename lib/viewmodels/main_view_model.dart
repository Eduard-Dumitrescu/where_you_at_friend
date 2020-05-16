import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/repositories/citizens_repo.dart';
import 'package:whereyouatfriend/repositories/zone_status_repo.dart';

class MainViewModel {
  final CitizenRepo _citizenRepo;
  final ZoneStatusRepo _zoneStatusRepo;

  final Completer<GoogleMapController> mapsController;
  final ValueNotifier<String> shownZone;

  Citizen _currentCitizen;
  CameraPosition currentCameraPosition;
  String shownPostalCode;

  ValueListenable<bool> lel;

  MainViewModel(this._citizenRepo, this._zoneStatusRepo)
      : mapsController = Completer(),
        shownZone = ValueNotifier("") {
    _citizenRepo.getCurrentCitizen().then((value) {
      _currentCitizen = value;
      shownPostalCode = _currentCitizen.postalCode;
      shownZone.value =
          "${_currentCitizen.postalCode}, ${_currentCitizen.city}";
    });
  }

  Future<CameraPosition> getCitizenPosition() async {
    if (_currentCitizen != null)
      return CameraPosition(
          target: LatLng(_currentCitizen.latitude, _currentCitizen.longitude),
          zoom: 15.0);

    _currentCitizen = await _citizenRepo.getCurrentCitizen();
    return CameraPosition(
        target: LatLng(_currentCitizen.latitude, _currentCitizen.longitude),
        zoom: 15.0);
  }

  void changeZone(CameraPosition cameraPosition) {
    currentCameraPosition = cameraPosition;
  }

  void updateZone() {
    Geolocator()
        .placemarkFromCoordinates(currentCameraPosition.target.latitude,
            currentCameraPosition.target.longitude)
        .then((value) {
      if (value.isNotEmpty) {
        if (value[0].postalCode != shownPostalCode) {
          shownPostalCode = value[0].postalCode;
          shownZone.value = "${value[0].postalCode}, ${value[0].locality}";
        }
      }
    });
  }

  void cleanup() {}
}
