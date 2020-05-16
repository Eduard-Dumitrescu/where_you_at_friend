class Citizen {
  int id;
  String userGuid;
  String postalCode;
  String city;
  bool isInside;
  String status;
  bool isLocationFromApi;

  double latitude;
  double longitude;

  Citizen.fromMap(Map<dynamic, dynamic> map)
      : id = map["id"],
        userGuid = map["userGuid"],
        postalCode = map["postalCode"],
        city = map["city"],
        isInside = map["isInside"],
        status = map["status"],
        isLocationFromApi = map["isLocationFromApi"],
        latitude = map["latitude"],
        longitude = map["longitude"];

  Map<String, dynamic> toMap() => {
        'id': id,
        'userGuid': userGuid,
        'postalCode': postalCode,
        'city': city,
        'isInside': isInside,
        'status': status,
        'isLocationFromApi': isLocationFromApi,
        'latitude': latitude,
        'longitude': longitude
      };

  Map<String, dynamic> toJson() => toMap();

  factory Citizen.fromJson(Map<String, dynamic> map) => Citizen.fromMap(map);

  Citizen merge(Citizen other) {
    this.id = other.id ?? this.id;
    this.userGuid = other.userGuid ?? this.userGuid;
    this.postalCode = other.postalCode ?? this.postalCode;
    this.city = other.postalCode ?? this.city;
    this.isInside = other.postalCode ?? this.isInside;
    this.status = other.status ?? this.status;
    this.isLocationFromApi = other.isLocationFromApi ?? this.isLocationFromApi;

    this.latitude = other.latitude ?? this.latitude;
    this.longitude = other.longitude ?? this.longitude;

    return this;
  }
}
