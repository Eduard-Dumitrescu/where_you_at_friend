import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/models/zone_status_count.dart';
import 'package:whereyouatfriend/services/zone_status_service.dart';

class ZoneStatusRepo {
  final AuthState _authState;
  final ZoneStatusService _zoneStatusService;

  ZoneStatusRepo(this._authState, this._zoneStatusService);

  Future<ZoneStatusCount> getZoneStatusCount(
      String postalCode, String city) async {
    var userGuid = (await _authState.getCurrentCitizen()).userGuid;

    return _zoneStatusService.getZoneStatusCount(userGuid, postalCode, city);
  }
}
