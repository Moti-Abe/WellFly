import 'package:intl/intl.dart';
import 'package:expedia/pages/home/flights/OnewayPage/models/seat_model.dart';

/// Represents a single flight option (used for both departure and return).
class RoundTripFlight {
  final String id;
  final String airline;
  final String flightNumber;
  final String fromCity;
  final String toCity;
  final DateTime date;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String stops;
  final double price;
  final String cabin;
  final String? layoverInfo;
  final int? seatsLeft;
  final String? operatedBy;

  const RoundTripFlight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.stops,
    required this.price,
    required this.cabin,
    this.layoverInfo,
    this.seatsLeft,
    this.operatedBy,
  });

  String get dateLabel => DateFormat('EEE, MMM d').format(date);

  String get fromCode {
    final match = RegExp(r'\((\w+)').firstMatch(fromCity);
    return match?.group(1) ?? fromCity.split(' ').first;
  }

  String get toCode {
    final match = RegExp(r'\((\w+)').firstMatch(toCity);
    return match?.group(1) ?? toCity.split(' ').first;
  }
}

/// Search criteria for round-trip flights.
class RoundTripSearchCriteria {
  final String from;
  final String to;
  final DateTime departDate;
  final DateTime returnDate;
  final int travelers;
  final String cabinClass;

  const RoundTripSearchCriteria({
    required this.from,
    required this.to,
    required this.departDate,
    required this.returnDate,
    required this.travelers,
    required this.cabinClass,
  });
}

/// Fare option for a flight.
class RtFareOption {
  final String name;
  final String description;
  final double priceMultiplier;
  final List<RtFareFeature> features;

  const RtFareOption({
    required this.name,
    required this.description,
    required this.priceMultiplier,
    required this.features,
  });
}

class RtFareFeature {
  final String text;
  final RtFareFeatureType type;

  const RtFareFeature({required this.text, required this.type});
}

enum RtFareFeatureType { included, paid, notIncluded }



/// Baggage option.
class RtBaggageOption {
  final String label;
  final String description;
  final double price;
  final int bags;

  const RtBaggageOption({
    required this.label,
    required this.description,
    required this.price,
    required this.bags,
  });
}

/// Booking state that accumulates through the round-trip flow.
class RoundTripBooking {
  final RoundTripSearchCriteria criteria;
  final RoundTripFlight departureFlight;
  final RoundTripFlight returnFlight;
  final RtFareOption fare;
  final String? departureSeat;
  final double departureSeatPrice;
  final String? returnSeat;
  final double returnSeatPrice;
  final RtBaggageOption? baggage;

  const RoundTripBooking({
    required this.criteria,
    required this.departureFlight,
    required this.returnFlight,
    required this.fare,
    this.departureSeat,
    this.departureSeatPrice = 0,
    this.returnSeat,
    this.returnSeatPrice = 0,
    this.baggage,
  });

  RoundTripBooking copyWith({
    String? departureSeat,
    double? departureSeatPrice,
    String? returnSeat,
    double? returnSeatPrice,
    RtBaggageOption? baggage,
  }) {
    return RoundTripBooking(
      criteria: criteria,
      departureFlight: departureFlight,
      returnFlight: returnFlight,
      fare: fare,
      departureSeat: departureSeat ?? this.departureSeat,
      departureSeatPrice: departureSeatPrice ?? this.departureSeatPrice,
      returnSeat: returnSeat ?? this.returnSeat,
      returnSeatPrice: returnSeatPrice ?? this.returnSeatPrice,
      baggage: baggage ?? this.baggage,
    );
  }

  double get totalSeatPrice => departureSeatPrice + returnSeatPrice;

  double get totalPrice {
    final departFare = departureFlight.price * fare.priceMultiplier;
    final returnFare = returnFlight.price * fare.priceMultiplier;
    final bagPrice = baggage?.price ?? 0;
    return departFare + returnFare + totalSeatPrice + bagPrice;
  }
}

// ─── UI Helper Functions (Default Options) ───

List<RtFareOption> getRtFareOptions() => const [
  RtFareOption(
    name: 'Basic Economy',
    description: 'No changes or cancellations',
    priceMultiplier: 1.0,
    features: [
      RtFareFeature(text: 'Personal item included', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Carry-on bag not included', type: RtFareFeatureType.notIncluded),
      RtFareFeature(text: 'Seat assigned at check-in', type: RtFareFeatureType.notIncluded),
      RtFareFeature(text: 'Non-refundable', type: RtFareFeatureType.notIncluded),
      RtFareFeature(text: 'No changes allowed', type: RtFareFeatureType.notIncluded),
    ],
  ),
  RtFareOption(
    name: 'Economy',
    description: 'Changes for a fee',
    priceMultiplier: 1.15,
    features: [
      RtFareFeature(text: 'Personal item included', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Carry-on bag included', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Seat choice for a fee', type: RtFareFeatureType.paid),
      RtFareFeature(text: 'Non-refundable', type: RtFareFeatureType.notIncluded),
      RtFareFeature(text: 'Change fee: \$100', type: RtFareFeatureType.paid),
    ],
  ),
  RtFareOption(
    name: 'Economy Flex',
    description: 'Free changes & cancellation',
    priceMultiplier: 1.40,
    features: [
      RtFareFeature(text: 'Personal item included', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Carry-on bag included', type: RtFareFeatureType.included),
      RtFareFeature(text: '1 checked bag included', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Seat choice included', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Free cancellation', type: RtFareFeatureType.included),
      RtFareFeature(text: 'Free changes', type: RtFareFeatureType.included),
    ],
  ),
];

List<List<SeatInfo>> generateRtSeatMap() {
  final rows = <List<SeatInfo>>[];
  final cols = ['A', 'B', 'C', '', 'D', 'E', 'F'];
  for (int row = 1; row <= 25; row++) {
    final seats = <SeatInfo>[];
    for (final col in cols) {
      if (col.isEmpty) {
        seats.add(const SeatInfo(label: '', type: SeatType.available));
        continue;
      }
      final label = '$row$col';
      final isExit = row == 12 || row == 13;
      if (row % 5 == 0 && col == 'B') {
        seats.add(SeatInfo(label: label, type: SeatType.occupied));
      } else if (isExit) {
        seats.add(SeatInfo(label: label, type: SeatType.exit, extraPrice: 35));
      } else if (row <= 4) {
        seats.add(SeatInfo(label: label, type: SeatType.premium, extraPrice: 55));
      } else {
        seats.add(SeatInfo(label: label, type: SeatType.available));
      }
    }
    rows.add(seats);
  }
  return rows;
}

List<RtBaggageOption> getRtBaggageOptions() => const [
  RtBaggageOption(label: 'No checked bags', description: 'Carry-on only', price: 0, bags: 0),
  RtBaggageOption(label: '1 checked bag', description: 'Up to 50 lbs (23 kg)', price: 40, bags: 1),
  RtBaggageOption(label: '2 checked bags', description: 'Up to 50 lbs (23 kg) each', price: 75, bags: 2),
];
