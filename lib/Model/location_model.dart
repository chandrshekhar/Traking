class LocationModel {
  int? id;
  String? timestamp;
  String? latitude;
  String? longitude;
  String? accuracy;
  double? distance;

  LocationModel(
      {this.timestamp,
      this.latitude,
      this.id,
      this.longitude,
      this.accuracy,
      this.distance});

  LocationModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    accuracy = json['accuracy'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['id'] = id;
    data['accuracy'] = accuracy;
    data['distance'] = distance;
    return data;
  }
}
