import 'package:whereyouatfriend/models/auth_state.dart';
import 'package:whereyouatfriend/services/zone_status_service.dart';

class ZoneStatusRepo {
  final AuthState _authState;
  final ZoneStatusService _zoneStatusService;

  ZoneStatusRepo(this._authState, this._zoneStatusService);
}
