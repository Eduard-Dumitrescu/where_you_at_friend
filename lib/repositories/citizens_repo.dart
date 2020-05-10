import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/repositories/base/base_citizens_repo.dart';
import 'package:whereyouatfriend/services/citizen_service.dart';

class CitizenRepo implements BaseCitizenRepo {
  final CitizenService _citizenService;
  final AuthState _authState;

  CitizenRepo(this._citizenService, this._authState);

  @override
  Future<Iterable<Citizen>> getAllCitizensAsFuture() {
    // TODO: implement getAllCitizensAsFuture
    throw UnimplementedError();
  }

  @override
  Stream<Iterable<Citizen>> getAllCitizensAsStream() {
    // TODO: implement getAllCitizensAsStream
    throw UnimplementedError();
  }

  @override
  Future<String> createCitizen(
      String postalCode, String city, bool isLocationFromAPI) async {
    var citizen = await _citizenService.createCitizen(
        postalCode, city, isLocationFromAPI);

    if (citizen != null) {
      _authState.setCitizen(citizen);
      return "User Created";
    }

    return null;
  }
}
