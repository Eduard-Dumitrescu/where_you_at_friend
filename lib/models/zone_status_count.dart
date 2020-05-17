class ZoneStatusCount {
  int isInsideCount;
  int totalCount;

  ZoneStatusCount.fromMap(Map<dynamic, dynamic> map)
      : isInsideCount = map["isInsideCount"],
        totalCount = map["totalCount"];

  Map<String, dynamic> toMap() => {
        'isInsideCount': isInsideCount,
        'totalCount': totalCount,
      };

  Map<String, dynamic> toJson() => toMap();

  factory ZoneStatusCount.fromJson(Map<String, dynamic> map) =>
      ZoneStatusCount.fromMap(map);
}
