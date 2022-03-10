import 'dart:convert';

Breeds breedsFromJson(String str) => Breeds.fromJson(json.decode(str));

String breedsToJson(Breeds data) => json.encode(data.toJson());

class Breeds {
  Breeds({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Breeds.fromJson(Map<String, dynamic> json) => Breeds(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
