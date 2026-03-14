import 'package:intl/intl.dart';

/// Represents a single one-way flight option.
class OneWayFlight {
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

  const OneWayFlight({
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

/// Search criteria for one-way flights.
class OneWaySearchCriteria {
  final String from;
  final String to;
  final DateTime departDate;
  final int travelers;
  final String cabinClass;

  const OneWaySearchCriteria({
    required this.from,
    required this.to,
    required this.departDate,
    required this.travelers,
    required this.cabinClass,
  });
}

/// Fare option for a flight.
class FareOption {
  final String name;
  final String description;
  final double priceMultiplier;
  final List<FareFeature> features;

  const FareOption({
    required this.name,
    required this.description,
    required this.priceMultiplier,
    required this.features,
  });
}

class FareFeature {
  final String text;
  final FareFeatureType type;

  const FareFeature({required this.text, required this.type});
}

enum FareFeatureType { included, paid, notIncluded }

/// Baggage option.
class BaggageOption {
  final String label;
  final String description;
  final double price;
  final int bags;

  const BaggageOption({
    required this.label,
    required this.description,
    required this.price,
    required this.bags,
  });
}

/// Booking state that accumulates through the flow.
class OneWayBooking {
  final OneWaySearchCriteria criteria;
  final OneWayFlight flight;
  final FareOption fare;
  final String? selectedSeat;
  final double seatPrice;
  final BaggageOption? baggage;

  const OneWayBooking({
    required this.criteria,
    required this.flight,
    required this.fare,
    this.selectedSeat,
    this.seatPrice = 0,
    this.baggage,
  });

  OneWayBooking copyWith({
    String? selectedSeat,
    double? seatPrice,
    BaggageOption? baggage,
  }) {
    return OneWayBooking(
      criteria: criteria,
      flight: flight,
      fare: fare,
      selectedSeat: selectedSeat ?? this.selectedSeat,
      seatPrice: seatPrice ?? this.seatPrice,
      baggage: baggage ?? this.baggage,
    );
  }

  double get totalPrice {
    final farePrice = flight.price * fare.priceMultiplier;
    final bagPrice = baggage?.price ?? 0;
    return farePrice + seatPrice + bagPrice;
  }
}
