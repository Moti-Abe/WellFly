// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;
import '../models/guest_token_model.dart';
import '../models/flight_shopping_model.dart';
import '../models/booking_model.dart';
import '../flight_data.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://3.11.26.231/fannos';
  

  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'guest_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired or invalid, try to get a new one
          await getGuestToken();
          // Retry the request
          final options = e.requestOptions;
          String? newToken = await _storage.read(key: 'guest_token');
          if (newToken != null) {
            options.headers['Authorization'] = 'Bearer $newToken';
          }
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }
        return handler.next(e);
      },
    ));

    return this;
  }

  Future<String?> getGuestToken() async {
    try {
      final response = await _dio.post('/api/auth/guest-token');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final guestToken = GuestTokenResponse.fromJson(response.data).guestToken;
        await _storage.write(key: 'guest_token', value: guestToken);
        return guestToken;
      }
    } catch (e) {
      print('Error getting guest token: $e');
    }
    return null;
  }

  Future<List<CityModel>> searchCities(String query) async {
    try {
      final response = await _dio.get('/api/flight/search-city', queryParameters: {'keyword': query});
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((i) => CityModel(
          name: i['name'] ?? '',
          code: i['iataCode'] ?? '',
          country: i['address']?['countryName'] ?? '',
        )).toList();
      }
    } catch (e) {
      print('Error searching cities: $e');
    }
    return [];
  }

  Future<FlightShoppingResponse?> searchFlights(FlightShoppingRequest request) async {
    try {
      print('--- API DIO POST /api/flight/shopping ---');
      print(request.toJson());
      final response = await _dio.post('/api/flight/shopping', data: request.toJson());
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      if (response.statusCode == 200) {
        return FlightShoppingResponse.fromJson(response.data);
      }
    } catch (e) {
      print('Error searching flights: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getOfferPrice(String offerId) async {
    try {
      final response = await _dio.post('/api/flight/offer-price', data: {'offerId': offerId});
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error getting offer price: $e');
    }
    return null;
  }

  Future<BookingHoldResponse?> holdBooking(BookingHoldRequest request) async {
    try {
      final response = await _dio.post('/api/flight/hold', data: request.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BookingHoldResponse.fromJson(response.data);
      }
    } catch (e) {
      print('Error holding booking: $e');
    }
    return null;
  }

  Future<List<PaymentOption>> getPaymentOptions(String bookingLocator) async {
    try {
      final response = await _dio.post('/api/flight/hold/get-payment-options', data: {'bookingLocator': bookingLocator});
      if (response.statusCode == 200) {
        return (response.data as List).map((i) => PaymentOption.fromJson(i)).toList();
      }
    } catch (e) {
      print('Error getting payment options: $e');
    }
    return [];
  }

  Future<dynamic> confirmPayment(ConfirmBookingRequest request) async {
    try {
      final response = await _dio.post('/api/flight/hold/confirmpayment', data: request.toJson());
      return response.data;
    } catch (e) {
      print('Error confirming payment: $e');
    }
    return null;
  }
}
