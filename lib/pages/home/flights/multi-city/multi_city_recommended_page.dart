import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mock_flights.dart';
import 'models.dart';
import 'multi_city_flight_details_page.dart';
import 'multi_city_review_fare_page.dart';
import 'widgets/multi_city_flight_card.dart';

// Sort options for the Sort & Filter sheet
enum _SortOption {
  recommended,
  priceLow,
  priceHigh,
  durationShort,
  departEarly,
  departLate,
}

class MultiCityRecommendedPage extends StatefulWidget {
  final MultiCitySelection selection;
  final int segmentIndex;

  const MultiCityRecommendedPage({
    super.key,
    required this.selection,
    required this.segmentIndex,
  });

  @override
  State<MultiCityRecommendedPage> createState() =>
      _MultiCityRecommendedPageState();
}

class _MultiCityRecommendedPageState extends State<MultiCityRecommendedPage> {
  // Sort & Filter state
  _SortOption _sortOption = _SortOption.recommended;
  String _stopFilter = 'Any';
  Set<String> _airlineFilter = {};

  /// Parse a duration string like "5h 30m" into total minutes.
  int _parseDurationMinutes(String d) {
    final hMatch = RegExp(r'(\d+)h').firstMatch(d);
    final mMatch = RegExp(r'(\d+)m').firstMatch(d);
    return (int.tryParse(hMatch?.group(1) ?? '0') ?? 0) * 60 +
        (int.tryParse(mMatch?.group(1) ?? '0') ?? 0);
  }

  /// Apply current sort & filter to a raw flight list.
  List<MultiCityFlight> _applyFilters(List<MultiCityFlight> raw) {
    var list = raw.where((f) {
      if (_stopFilter == 'Nonstop' && f.stops != 'Nonstop') return false;
      if (_stopFilter == '1 stop or fewer' &&
          f.stops != 'Nonstop' &&
          f.stops != '1 stop') {
        return false;
      }
      if (_airlineFilter.isNotEmpty && !_airlineFilter.contains(f.airline)) {
        return false;
      }
      return true;
    }).toList();

    switch (_sortOption) {
      case _SortOption.recommended:
        break;
      case _SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.durationShort:
        list.sort(
          (a, b) => _parseDurationMinutes(
            a.duration,
          ).compareTo(_parseDurationMinutes(b.duration)),
        );
      case _SortOption.departEarly:
        list.sort((a, b) => a.departTime.compareTo(b.departTime));
      case _SortOption.departLate:
        list.sort((a, b) => b.departTime.compareTo(a.departTime));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final criteria = widget.selection.criteria;
    final segmentFrom = _segmentFrom(criteria, widget.segmentIndex);
    final segmentTo = _segmentTo(criteria, widget.segmentIndex);
    final segmentDate = _segmentDate(criteria, widget.segmentIndex);

    final rawFlights =
        (segmentFrom == null || segmentTo == null || segmentDate == null)
        ? <MultiCityFlight>[]
        : generateFlightsForRoute(segmentFrom, segmentTo, segmentDate);
    final filteredFlights = _applyFilters(rawFlights);

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchPillBar(context, criteria),
            Expanded(
              child: rawFlights.isEmpty
                  ? _buildEmptyState(context)
                  : filteredFlights.isEmpty
                  ? _buildNoFilterResults(context)
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        _buildPromoBanner(context),
                        _buildDisclaimer(context),
                        _buildSectionHeader(context),
                        ...filteredFlights.map(
                          (flight) => MultiCityFlightCard(
                            flight: flight,
                            onSelect: () => _openReviewFare(context, flight),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSortFilterFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ──────────── Search Pill App Bar ────────────
  Widget _buildSearchPillBar(
    BuildContext context,
    MultiCitySearchCriteria criteria,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final pillBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final pillBorder = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;

    final routeText = _buildRouteLine(criteria);
    final dateText =
        '${DateFormat('MMM d').format(criteria.depart1)}-${DateFormat('MMM d').format(criteria.depart2)}'
        '${criteria.hasThirdLeg ? '-${DateFormat('MMM d').format(criteria.depart3!)}' : ''}'
        '  ·  ${criteria.travelers} traveler${criteria.travelers > 1 ? 's' : ''}';

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back arrow
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          // Search pill
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: pillBorder),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  // Yellow search circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDD835),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          routeText,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateText,
                          style: TextStyle(
                            color: colors.onSurface.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Share icon
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ──────────── Promo Banner ────────────
  Widget _buildPromoBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diamond icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2340) : const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.diamond_outlined,
              color: Color(0xFF1565C0),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book a flight and get \$20 in OneKeyCash to use toward your next trip',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Receive within 48 hours, use within 30 days. See terms',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────── Disclaimer ────────────
  Widget _buildDisclaimer(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text(
        'Prices may change based on availability and are not final until you '
        'complete your purchase. You can review any additional fees before checkout.',
        style: TextStyle(
          color: colors.onSurface.withValues(alpha: 0.55),
          fontSize: 12,
        ),
      ),
    );
  }

  // ──────────── Section Header ────────────
  Widget _buildSectionHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended flights',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'How our sort order works and personalized pricing',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.55),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                size: 14,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────── No filter results ────────────
  Widget _buildNoFilterResults(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_off,
              size: 48,
              color: colors.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'No flights match your filters',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() {
                _sortOption = _SortOption.recommended;
                _stopFilter = 'Any';
                _airlineFilter = {};
              }),
              child: const Text('Clear all filters'),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── Sort & Filter FAB ────────────
  Widget _buildSortFilterFab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasActiveFilters =
        _sortOption != _SortOption.recommended ||
        _stopFilter != 'Any' ||
        _airlineFilter.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showSortFilterSheet(),
        icon: const Icon(Icons.tune, size: 18),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sort & Filter'),
            if (hasActiveFilters) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF7FB5FF)
                      : const Color(0xFF1565C0),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? const Color(0xFF1E2433) : Colors.white,
          foregroundColor: isDark
              ? const Color(0xFF7FB5FF)
              : const Color(0xFF1565C0),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: isDark ? const Color(0xFF2A3141) : Colors.grey.shade300,
            ),
          ),
        ),
      ),
    );
  }

  // ──────────── Sort & Filter Bottom Sheet ────────────
  void _showSortFilterSheet() {
    var tempSort = _sortOption;
    var tempStop = _stopFilter;
    var tempAirlines = Set<String>.from(_airlineFilter);

    // Collect available airlines from current route flights
    final criteria = widget.selection.criteria;
    final segmentFrom = _segmentFrom(criteria, widget.segmentIndex);
    final segmentTo = _segmentTo(criteria, widget.segmentIndex);
    final segmentDate = _segmentDate(criteria, widget.segmentIndex);
    final rawFlights =
        (segmentFrom == null || segmentTo == null || segmentDate == null)
        ? <MultiCityFlight>[]
        : generateFlightsForRoute(segmentFrom, segmentTo, segmentDate);
    final availableAirlines = rawFlights.map((f) => f.airline).toSet().toList()
      ..sort();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        final colors = Theme.of(sheetContext).colorScheme;
        final bgColor = isDark ? const Color(0xFF151A24) : Colors.white;
        final accentColor = isDark
            ? const Color(0xFF7FB5FF)
            : const Color(0xFF1565C0);

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget sortTile(String label, _SortOption value) {
              final selected = tempSort == value;
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: Text(
                  label,
                  style: TextStyle(
                    color: selected ? accentColor : colors.onSurface,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: selected
                    ? Icon(Icons.check, color: accentColor, size: 20)
                    : null,
                onTap: () => setSheetState(() => tempSort = value),
              );
            }

            Widget stopChip(String label) {
              final selected = tempStop == label;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setSheetState(() => tempStop = label),
                  selectedColor: accentColor.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: selected ? accentColor : colors.onSurface,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: selected
                        ? accentColor
                        : colors.onSurface.withValues(alpha: 0.3),
                  ),
                  showCheckmark: false,
                ),
              );
            }

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sort & Filter',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => setSheetState(() {
                            tempSort = _SortOption.recommended;
                            tempStop = 'Any';
                            tempAirlines = {};
                          }),
                          child: Text(
                            'Reset',
                            style: TextStyle(color: accentColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Scrollable content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Sort By ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                            child: Text(
                              'Sort by',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          sortTile('Recommended', _SortOption.recommended),
                          sortTile('Price (low to high)', _SortOption.priceLow),
                          sortTile(
                            'Price (high to low)',
                            _SortOption.priceHigh,
                          ),
                          sortTile(
                            'Duration (shortest)',
                            _SortOption.durationShort,
                          ),
                          sortTile(
                            'Departure (earliest)',
                            _SortOption.departEarly,
                          ),
                          sortTile(
                            'Departure (latest)',
                            _SortOption.departLate,
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          // ── Stops ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: Text(
                              'Stops',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Wrap(
                              children: [
                                stopChip('Any'),
                                stopChip('Nonstop'),
                                stopChip('1 stop or fewer'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1),
                          // ── Airlines ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                            child: Text(
                              'Airlines',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...availableAirlines.map((airline) {
                            final selected =
                                tempAirlines.isEmpty ||
                                tempAirlines.contains(airline);
                            return CheckboxListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              title: Text(
                                airline,
                                style: TextStyle(color: colors.onSurface),
                              ),
                              value: selected,
                              activeColor: accentColor,
                              onChanged: (val) {
                                setSheetState(() {
                                  if (val == true) {
                                    if (tempAirlines.isEmpty) {
                                      tempAirlines = availableAirlines.toSet();
                                    }
                                    tempAirlines.add(airline);
                                  } else {
                                    if (tempAirlines.isEmpty) {
                                      tempAirlines = availableAirlines.toSet();
                                    }
                                    tempAirlines.remove(airline);
                                    if (tempAirlines.length ==
                                        availableAirlines.length) {
                                      tempAirlines = {};
                                    }
                                  }
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Apply button
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _sortOption = tempSort;
                              _stopFilter = tempStop;
                              _airlineFilter = tempAirlines;
                            });
                            Navigator.pop(sheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ──────────── Empty State ────────────
  Widget _buildEmptyState(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: textColor.withValues(alpha: 0.6),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'No flights match your selections.',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try another date or city pair.',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── Open Review Fare Page ────────────
  void _openReviewFare(BuildContext context, MultiCityFlight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiCityReviewFarePage(
          flight: flight,
          onSelect: () => _handleSelect(context, flight),
        ),
      ),
    );
  }

  // ──────────── Flight Selection Logic ────────────
  void _handleSelect(BuildContext context, MultiCityFlight flight) {
    if (widget.segmentIndex == 1) {
      final nextSelection = widget.selection.copyWith(flight1: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiCityRecommendedPage(
            selection: nextSelection,
            segmentIndex: 2,
          ),
        ),
      );
    } else if (widget.segmentIndex == 2 &&
        widget.selection.criteria.hasThirdLeg) {
      final nextSelection = widget.selection.copyWith(flight2: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiCityRecommendedPage(
            selection: nextSelection,
            segmentIndex: 3,
          ),
        ),
      );
    } else if (widget.segmentIndex == 2) {
      final nextSelection = widget.selection.copyWith(flight2: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiCityFlightDetailsPage(selection: nextSelection),
        ),
      );
    } else {
      final nextSelection = widget.selection.copyWith(flight3: flight);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MultiCityFlightDetailsPage(selection: nextSelection),
        ),
      );
    }
  }

  // ──────────── Helpers ────────────
  String _buildRouteLine(MultiCitySearchCriteria criteria) {
    String shorten(String city) {
      final match = RegExp(r'\((\w+)\)').firstMatch(city);
      return match != null ? match.group(1)! : city.split(' ').first;
    }

    final segments = [
      shorten(criteria.from1),
      shorten(criteria.to1),
      shorten(criteria.to2),
    ];
    if (criteria.hasThirdLeg) {
      segments.add(shorten(criteria.to3!));
    }
    return segments.join(' → ');
  }

  String? _segmentFrom(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.from1;
      case 2:
        return criteria.from2;
      case 3:
        return criteria.from3;
      default:
        return null;
    }
  }

  String? _segmentTo(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.to1;
      case 2:
        return criteria.to2;
      case 3:
        return criteria.to3;
      default:
        return null;
    }
  }

  DateTime? _segmentDate(MultiCitySearchCriteria criteria, int segment) {
    switch (segment) {
      case 1:
        return criteria.depart1;
      case 2:
        return criteria.depart2;
      case 3:
        return criteria.depart3;
      default:
        return null;
    }
  }
}
