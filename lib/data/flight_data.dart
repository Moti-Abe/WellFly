class CityModel {
  final String name;
  final String code;
  final String country;

  CityModel({required this.name, required this.code, required this.country});

  String get fullName => "$name ($code)";
}
