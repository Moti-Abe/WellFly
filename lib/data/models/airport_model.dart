class AirportModel {
  final String code;
  final String name;
  final String city;
  final String country;
  final bool isPopular;

  AirportModel({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
    this.isPopular = false,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'city': city,
      'country': country,
      'isPopular': isPopular,
    };
  }

  String get displayName => "$code - $name, $city";
  String get shortName => "$city ($code)";

  // Override equality so we can properly manage Recent Searches and unique sets
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirportModel && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
