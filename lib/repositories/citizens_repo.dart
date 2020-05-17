import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/repositories/base/base_citizens_repo.dart';
import 'package:whereyouatfriend/services/citizen_service.dart';

class CitizenRepo implements BaseCitizenRepo {
  final CitizenService _citizenService;
  final AuthState _authState;

  CitizenRepo(this._citizenService, this._authState);

  Future<String> createCitizen(String postalCode, String city,
      bool isLocationFromAPI, double latitude, double longitude) async {
    var citizen = await _citizenService.createCitizen(
        postalCode, city, isLocationFromAPI);

    if (citizen != null) {
      citizen.latitude = latitude;
      citizen.longitude = longitude;

      _authState.setCitizen(citizen);
      return "User Created";
    }

    return null;
  }

  Future<String> updateIsInsideStatus(bool isInside) async {
    String citizenGuid = (await getCurrentCitizen()).userGuid;
    bool hasUpdated =
        await _citizenService.updateIsInsideStatus(citizenGuid, isInside);

    return hasUpdated ? "Status update complete" : "Error";
  }

  Future<Citizen> getCurrentCitizen() => _authState.getCurrentCitizen();
}
