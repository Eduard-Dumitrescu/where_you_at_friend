import 'package:whereyouatfriend/models/citizen.dart';

abstract class BaseCitizenRepo {
  Stream<Iterable<Citizen>> getAllCitizensAsStream();
  Future<Iterable<Citizen>> getAllCitizensAsFuture();
}
