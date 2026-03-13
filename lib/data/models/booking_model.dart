import 'passenger_model.dart';

class BookingHoldRequest {
  final String offerId;
  final List<Passenger> passengers;

  BookingHoldRequest({required this.offerId, required this.passengers});

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'passengers': passengers.map((p) => p.toJson()).toList(),
    };
  }
}

class BookingHoldResponse {
  final String bookingLocator;
  final String status;

  BookingHoldResponse({required this.bookingLocator, required this.status});

  factory BookingHoldResponse.fromJson(Map<String, dynamic> json) {
    return BookingHoldResponse(
      bookingLocator: json['bookingLocator'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ConfirmBookingRequest {
  final String bookingLocator;
  final PaymentOption payOption;
  final bool isCardMethod;
  final CardInfo? cardInfo;

  ConfirmBookingRequest({
    required this.bookingLocator,
    required this.payOption,
    this.isCardMethod = true,
    this.cardInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingLocator': bookingLocator,
      'payOption': payOption.toJson(),
      'isCardMethod': isCardMethod,
      'cardInfo': cardInfo?.toJson(),
    };
  }
}

class PaymentOption {
  final String id;
  final String? name;

  PaymentOption({required this.id, this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      id: json['id'] ?? '',
      name: json['name'],
    );
  }
}

class CardInfo {
  final String cardHolder;
  final String cardNumber;
  final String expireMonth;
  final String expireYear;
  final String cvv;

  CardInfo({
    required this.cardHolder,
    required this.cardNumber,
    required this.expireMonth,
    required this.expireYear,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expireMonth': expireMonth,
      'expireYear': expireYear,
      'cvv': cvv,
    };
  }
}
