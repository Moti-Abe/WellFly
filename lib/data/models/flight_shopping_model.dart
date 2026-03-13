class FlightShoppingRequest {
  final List<OriginDestination> originDestinations;
  final Travellers travellers;
  final Preference preference;
  final String? promoCode;
  final CorporateCode? corporateCode;

  FlightShoppingRequest({
    required this.originDestinations,
    required this.travellers,
    required this.preference,
    this.promoCode,
    this.corporateCode,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'originDestinations': originDestinations.map((v) => v.toJson()).toList(),
      'travellers': travellers.toJson(),
      'preference': preference.toJson(),
    };
    if (promoCode != null) {
      data['promoCode'] = promoCode;
    }
    if (corporateCode != null) {
      data['corporateCode'] = corporateCode!.toJson();
    }
    return data;
  }
}

class OriginDestination {
  final Departure departure;
  final Arrival arrival;

  OriginDestination({required this.departure, required this.arrival});

  Map<String, dynamic> toJson() {
    return {
      'departure': departure.toJson(),
      'arrival': arrival.toJson(),
    };
  }
}

class Departure {
  final String airportCode;
  final String date;

  Departure({required this.airportCode, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'airportCode': airportCode,
      'date': date,
    };
  }
}

class Arrival {
  final String airportCode;

  Arrival({required this.airportCode});

  Map<String, dynamic> toJson() {
    return {
      'airportCode': airportCode,
    };
  }
}

class Travellers {
  final int adt;
  final int chd;
  final int inf;

  Travellers({required this.adt, this.chd = 0, this.inf = 0});

  Map<String, dynamic> toJson() {
    return {
      'adt': adt,
      'chd': chd,
      'inf': inf,
    };
  }
}

class Preference {
  final CabinPreferences cabinPreferences;

  Preference({required this.cabinPreferences});

  Map<String, dynamic> toJson() {
    return {
      'cabinPreferences': cabinPreferences.toJson(),
    };
  }
}

class CabinPreferences {
  final CabinType cabinType;

  CabinPreferences({required this.cabinType});

  Map<String, dynamic> toJson() {
    return {
      'cabinType': cabinType.toJson(),
    };
  }
}

class CabinType {
  final String code;

  CabinType({required this.code});

  Map<String, dynamic> toJson() {
    return {
      'code': code.toLowerCase(),
    };
  }
}

class CorporateCode {
  final List<String> accountNumber;
  final String airlineCode;

  CorporateCode({required this.accountNumber, required this.airlineCode});

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'airlineCode': airlineCode,
    };
  }
}

// Basic Response Model (to be refined as actual response structure is seen)
class FlightShoppingResponse {
  final List<FlightOffer> offers;

  FlightShoppingResponse({required this.offers});

  factory FlightShoppingResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> offersList = [];
    
    // Check Fannos format (qrFlights)
    if (json['data'] != null && json['data']['qrFlights'] != null && json['data']['qrFlights']['offers'] != null) {
      offersList = json['data']['qrFlights']['offers'];
    } 
    // Fallback formats
    else if (json['data'] != null && json['data']['flightOffers'] != null) {
      offersList = json['data']['flightOffers'];
    } else if (json['offers'] != null) {
      offersList = json['offers'];
    }

    return FlightShoppingResponse(
      offers: offersList.map((i) => FlightOffer.fromJson(i)).toList(),
    );
  }
}

class FlightOffer {
  final String id;
  final FlightPrice price;
  final String airline;
  final List<FlightItinerary> itineraries;

  FlightOffer({
    required this.id,
    required this.price,
    required this.airline,
    required this.itineraries,
  });

  factory FlightOffer.fromJson(Map<String, dynamic> json) {
    return FlightOffer(
      id: json['offerId'] ?? json['id'] ?? '',
      price: FlightPrice.fromJson(json['pricing'] ?? json['price'] ?? {}),
      airline: _extractAirline(json),
      itineraries: _extractItineraries(json),
    );
  }

  static String _extractAirline(Map<String, dynamic> json) {
    if (json['airline'] != null) return json['airline'];
    
    // Try Fannos format: flights[0].segments[0].airlineName
    try {
      final flights = json['flights'] as List?;
      if (flights != null && flights.isNotEmpty) {
        final segments = flights[0]['segments'] as List?;
        if (segments != null && segments.isNotEmpty) {
           return segments[0]['airlineName'] ?? segments[0]['airlineCode'] ?? '';
        }
      }
    } catch (_) {}
    return '';
  }

  static List<FlightItinerary> _extractItineraries(Map<String, dynamic> json) {
    if (json['itineraries'] != null) {
       return (json['itineraries'] as List).map((i) => FlightItinerary.fromJson(i)).toList();
    }
    
    // Fannos format
    if (json['flights'] != null) {
      return (json['flights'] as List).map((f) {
         return FlightItinerary(
           duration: f['duration'] ?? '',
           segments: (f['segments'] as List? ?? []).map((s) {
              return FlightSegment(
                 number: s['flightNumber'] ?? '',
                 carrierCode: s['airlineCode'] ?? '',
                 departure: FlightEndpoint(
                    iataCode: s['departureAirport'] ?? '',
                    at: s['departureDateTime'] ?? ''
                 ),
                 arrival: FlightEndpoint(
                    iataCode: s['arrivalAirport'] ?? '',
                    at: s['arrivalDateTime'] ?? ''
                 )
              );
           }).toList()
         );
      }).toList();
    }
    return [];
  }
}

class FlightPrice {
  final String total;
  final String currency;

  FlightPrice({required this.total, required this.currency});

  factory FlightPrice.fromJson(Map<String, dynamic> json) {
    return FlightPrice(
      total: json['total']?.toString() ?? '0',
      currency: json['currency'] ?? 'USD',
    );
  }
}

class FlightItinerary {
  final String duration;
  final List<FlightSegment> segments;

  FlightItinerary({required this.duration, required this.segments});

  factory FlightItinerary.fromJson(Map<String, dynamic> json) {
    return FlightItinerary(
      duration: json['duration'] ?? '',
      segments: (json['segments'] as List? ?? [])
          .map((i) => FlightSegment.fromJson(i))
          .toList(),
    );
  }
}

class FlightSegment {
  final String number;
  final String carrierCode;
  final FlightEndpoint departure;
  final FlightEndpoint arrival;

  FlightSegment({
    required this.number,
    required this.carrierCode,
    required this.departure,
    required this.arrival,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      number: json['number'] ?? '',
      carrierCode: json['carrierCode'] ?? '',
      departure: FlightEndpoint.fromJson(json['departure'] ?? {}),
      arrival: FlightEndpoint.fromJson(json['arrival'] ?? {}),
    );
  }
}

class FlightEndpoint {
  final String iataCode;
  final String at;

  FlightEndpoint({required this.iataCode, required this.at});

  factory FlightEndpoint.fromJson(Map<String, dynamic> json) {
    return FlightEndpoint(
      iataCode: json['iataCode'] ?? '',
      at: json['at'] ?? '',
    );
  }
}
