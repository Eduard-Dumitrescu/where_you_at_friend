import 'package:whereyouatfriend/models/citizen.dart';
import 'package:whereyouatfriend/repositories/base_citizens_repo.dart';
import 'package:whereyouatfriend/services/citizen_service.dart';

class CitizenRepo implements BaseCitizenRepo {
  final CitizenService _citizenService;

  CitizenRepo(this._citizenService);

  @override
  Future<Iterable<Citizen>> getAllCitizensAsFuture() =>
      _citizenService.getCitizens().first;

  @override
  Stream<Iterable<Citizen>> getAllCitizensAsStream() =>
      _citizenService.getCitizens();
}
