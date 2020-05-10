class Citizen {
  int id;
  String userGuid;
  String postalCode;
  String city;
  bool isInside;
  String status;
  bool isLocationFromApi;

  Citizen.fromMap(Map<dynamic, dynamic> map)
      : id = map["id"],
        userGuid = map["userGuid"],
        postalCode = map["postalCode"],
        city = map["city"],
        isInside = map["isInside"],
        status = map["status"],
        isLocationFromApi = map["isLocationFromApi"];

  Map<String, dynamic> toMap() => {
        'id': id,
        'userGuid': userGuid,
        'postalCode': postalCode,
        'city': city,
        'isInside': isInside,
        'status': status,
        'isLocationFromApi': isLocationFromApi
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
    return this;
  }
}
