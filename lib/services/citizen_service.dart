import 'package:dio/dio.dart';
import 'package:whereyouatfriend/models/citizen.dart';

class CitizenService {
  final Dio _dio;

  CitizenService()
      : _dio = Dio(BaseOptions(
          baseUrl: "http://localhost:8080",
          connectTimeout: 5000,
          receiveTimeout: 3000,
        ));

  Future<Citizen> createCitizen(
      String postalCode, String city, bool isLocationFromApi) async {
    try {
      var response = await _dio.post("/createCitizen", data: {
        "postalCode": postalCode,
        "city": city,
        "isLocationFromAPI": isLocationFromApi
      });
      if (response.statusCode == 200) {
        var citizen = Citizen.fromMap(response.data);
        citizen.postalCode = postalCode;
        citizen.city = city;
        citizen.isLocationFromApi = isLocationFromApi;

        //server rules, no reason to waste data
        citizen.isInside = true;
        citizen.status = "Inside";

        return citizen;
      }
      return null;
    } on DioError catch (e) {
      return null;
    }
  }
}
