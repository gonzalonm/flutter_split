class Split {
  late String id;
  late String name;
  String? description;
  late TrafficType trafficType;
  late int creationTime;

  Split.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    trafficType = TrafficType.fromJson(data['trafficType']);
    creationTime = data['creationTime'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'trafficType': trafficType.toJson(),
        'creationTime': creationTime
      };

  @override
  String toString() => toJson().toString();
}

class TrafficType {
  late String id;
  late String name;

  TrafficType.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
