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

  final ValueNotifier<int> citizensOutside;
  final ValueNotifier<int> citizensInside;
  final ValueNotifier<int> citizensTotal;
  final ValueNotifier<String> currentZoneData;

  Citizen _currentCitizen;
  CameraPosition currentCameraPosition;
  String currentPostalCode;
  String currentCity;

  ValueListenable<bool> lel;

  MainViewModel(this._citizenRepo, this._zoneStatusRepo)
      : mapsController = Completer(),
        shownZone = ValueNotifier(""),
        citizensInside = ValueNotifier(0),
        citizensOutside = ValueNotifier(0),
        citizensTotal = ValueNotifier(0),
        currentZoneData = ValueNotifier("") {
    _citizenRepo.getCurrentCitizen().then((value) {
      _currentCitizen = value;
      currentPostalCode = _currentCitizen.postalCode;
      currentCity = _currentCitizen.city;
      shownZone.value =
          "${_currentCitizen.postalCode}, ${_currentCitizen.city}";
      updateZone();
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

  void updateZoneData() {
    _zoneStatusRepo
        .getZoneStatusCount(currentPostalCode, currentCity)
        .then((value) {
      if (value != null) {
        citizensInside.value = value.isInsideCount;
        citizensTotal.value = value.totalCount;
        citizensOutside.value = value.totalCount - value.isInsideCount;
      }
    });
  }

  void updateZone() {
    if (currentCameraPosition != null) {
      Geolocator()
          .placemarkFromCoordinates(currentCameraPosition.target.latitude,
              currentCameraPosition.target.longitude)
          .then((value) {
        if (value.isNotEmpty) {
          if (value[0].postalCode != currentPostalCode) {
            currentPostalCode = value[0].postalCode;
            currentCity = value[0].locality;
            shownZone.value = "${value[0].postalCode}, ${value[0].locality}";
          }
        }
      });
    }
  }

  void cleanup() {
    shownZone?.dispose();
    citizensOutside?.dispose();
    citizensInside?.dispose();
    currentZoneData?.dispose();
    citizensTotal?.dispose();
  }
}
