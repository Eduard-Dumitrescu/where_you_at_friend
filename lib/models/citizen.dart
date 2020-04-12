class Citizen {
  final String name;
  final int postalCode;
  final String status;

  Citizen(this.name, this.postalCode, this.status);

  Citizen.fromMap(Map<dynamic, dynamic> map)
      : name = map["name"],
        postalCode = map["postalCode"],
        status = map["status"];

  Map<String, dynamic> toMap() => {
        'name': name,
        'postalCode': postalCode,
        'status': status,
      };
}
