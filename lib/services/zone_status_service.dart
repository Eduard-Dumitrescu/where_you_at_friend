import 'package:dio/dio.dart';
import 'package:whereyouatfriend/models/zone_status_count.dart';

class ZoneStatusService {
  final Dio _dio;

  ZoneStatusService()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://localhost:8080/general",
          connectTimeout: 5000,
          receiveTimeout: 3000,
        ));

  Future<ZoneStatusCount> getZoneStatusCount(
      String citizenGuid, String postalCode, String city) async {
    try {
      _dio.options.headers["Userguid"] = citizenGuid;
      var response = await _dio.get("/zoneStatus", queryParameters: {
        "PostalCode": postalCode,
        "City": city,
      });
      if (response.statusCode == 200) {
        var zoneStatusCount = ZoneStatusCount.fromMap(response.data);

        _dio.options.headers.clear();
        return zoneStatusCount;
      }
      _dio.options.headers.clear();
      return null;
    } on DioError catch (e) {
      _dio.options.headers.clear();
      return null;
    }
  }
}
