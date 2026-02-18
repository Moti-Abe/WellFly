// Mock car rental data — no API, all hardcoded.

class CarModel {
  final String name;
  final String type;
  final String transmission;
  final int seats;
  final bool hasAC;
  final double pricePerDay;
  final double rating;
  final int reviewCount;
  final String supplier;
  final String imagePath;
  final List<String> features;

  const CarModel({
    required this.name,
    required this.type,
    required this.transmission,
    required this.seats,
    required this.hasAC,
    required this.pricePerDay,
    required this.rating,
    required this.reviewCount,
    required this.supplier,
    required this.imagePath,
    required this.features,
  });

  String get seatsLabel => '$seats seats';
  String get acLabel => hasAC ? 'A/C' : 'No A/C';
  String get shortDescription => '$transmission · $seatsLabel · $acLabel';
}

/// Hardcoded list of rental cars.
final List<CarModel> mockCars = [
  const CarModel(
    name: 'Toyota Corolla',
    type: 'Economy',
    transmission: 'Automatic',
    seats: 5,
    hasAC: true,
    pricePerDay: 42,
    rating: 4.5,
    reviewCount: 328,
    supplier: 'Hertz',
    imagePath: 'assets/images/cars/corolla.png',
    features: ['Free cancellation', 'Unlimited mileage', 'Theft protection'],
  ),
  const CarModel(
    name: 'Honda Civic',
    type: 'Compact',
    transmission: 'Automatic',
    seats: 5,
    hasAC: true,
    pricePerDay: 48,
    rating: 4.3,
    reviewCount: 215,
    supplier: 'Avis',
    imagePath: 'assets/images/cars/civic.png',
    features: ['Free cancellation', 'Unlimited mileage'],
  ),
  const CarModel(
    name: 'Ford Mustang',
    type: 'Convertible',
    transmission: 'Automatic',
    seats: 4,
    hasAC: true,
    pricePerDay: 112,
    rating: 4.8,
    reviewCount: 142,
    supplier: 'Enterprise',
    imagePath: 'assets/images/cars/mustang.png',
    features: ['Free cancellation', 'Premium insurance included'],
  ),
  const CarModel(
    name: 'Chevrolet Tahoe',
    type: 'SUV',
    transmission: 'Automatic',
    seats: 7,
    hasAC: true,
    pricePerDay: 95,
    rating: 4.6,
    reviewCount: 189,
    supplier: 'National',
    imagePath: 'assets/images/cars/tahoe.png',
    features: ['Free cancellation', 'Unlimited mileage', '4WD'],
  ),
  const CarModel(
    name: 'Nissan Altima',
    type: 'Midsize',
    transmission: 'Automatic',
    seats: 5,
    hasAC: true,
    pricePerDay: 55,
    rating: 4.2,
    reviewCount: 276,
    supplier: 'Budget',
    imagePath: 'assets/images/cars/altima.png',
    features: ['Free cancellation', 'Unlimited mileage'],
  ),
  const CarModel(
    name: 'BMW 3 Series',
    type: 'Luxury',
    transmission: 'Automatic',
    seats: 5,
    hasAC: true,
    pricePerDay: 135,
    rating: 4.7,
    reviewCount: 97,
    supplier: 'Sixt',
    imagePath: 'assets/images/cars/bmw3.png',
    features: ['Free cancellation', 'GPS included', 'Leather seats'],
  ),
  const CarModel(
    name: 'Hyundai Accent',
    type: 'Economy',
    transmission: 'Manual',
    seats: 5,
    hasAC: true,
    pricePerDay: 32,
    rating: 4.0,
    reviewCount: 410,
    supplier: 'Dollar',
    imagePath: 'assets/images/cars/accent.png',
    features: ['Free cancellation', 'Unlimited mileage'],
  ),
  const CarModel(
    name: 'Jeep Wrangler',
    type: 'SUV',
    transmission: 'Automatic',
    seats: 5,
    hasAC: true,
    pricePerDay: 105,
    rating: 4.6,
    reviewCount: 164,
    supplier: 'Alamo',
    imagePath: 'assets/images/cars/wrangler.png',
    features: ['Free cancellation', '4WD', 'Off-road capable'],
  ),
];
