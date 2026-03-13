// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/airport_model.dart';

class AirportSearchService extends GetxService {
  final List<AirportModel> _allAirports = [];
  final List<AirportModel> _popularAirports = [];
  final RxList<AirportModel> recentSearches = <AirportModel>[].obs;

  static const _recentSearchesKey = 'recent_airport_searches';

  Future<AirportSearchService> init() async {
    await _loadAirports();
    await _loadRecentSearches();
    return this;
  }

  Future<void> _loadAirports() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/airports.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);

      _allAirports.clear();
      _popularAirports.clear();

      for (var json in jsonList) {
        final airport = AirportModel.fromJson(json);
        _allAirports.add(airport);
        if (airport.isPopular) {
          _popularAirports.add(airport);
        }
      }
    } catch (e) {
      print('Failed to load airports: $e');
    }
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedList = prefs.getStringList(_recentSearchesKey);

      if (savedList != null) {
        recentSearches.value = savedList.map((str) {
          final Map<String, dynamic> json = jsonDecode(str);
          return AirportModel.fromJson(json);
        }).toList();
      }
    } catch (e) {
      print('Failed to load recent searches: $e');
    }
  }

  Future<void> addRecentSearch(AirportModel airport) async {
    // Remove if already exists so we can move it to the top
    recentSearches.remove(airport);
    
    // Insert at top
    recentSearches.insert(0, airport);
    
    // Keep only the last 5 searches
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> encodedList = recentSearches.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_recentSearchesKey, encodedList);
    } catch (e) {
      print('Failed to save recent searches: $e');
    }
  }

  Future<void> clearRecentSearches() async {
    recentSearches.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSearchesKey);
    } catch (e) {
      print('Failed to clear recent searches: $e');
    }
  }

  List<AirportModel> searchAirports(String query) {
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase().trim();
    
    // Multi-factor search: matches code, city, name, or country
    return _allAirports.where((airport) {
      return airport.code.toLowerCase().contains(normalizedQuery) ||
             airport.city.toLowerCase().contains(normalizedQuery) ||
             airport.name.toLowerCase().contains(normalizedQuery) ||
             airport.country.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  List<AirportModel> get popularAirports => _popularAirports;
}
