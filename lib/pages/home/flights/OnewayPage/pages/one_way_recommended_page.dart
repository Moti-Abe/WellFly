import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/one_way_models.dart';
import '../models/one_way_mock_data.dart';
import '../widgets/one_way_flight_card.dart';
import 'one_way_select_fare_page.dart';

/// Page 2: Recommended departing flights with horizontal date-price scroller.
class OneWayRecommendedPage extends StatefulWidget {
  final OneWaySearchCriteria criteria;

  const OneWayRecommendedPage({super.key, required this.criteria});

  @override
  State<OneWayRecommendedPage> createState() => _OneWayRecommendedPageState();
}

// Sort options for the Sort & Filter sheet
enum _SortOption {
  recommended,
  priceLow,
  priceHigh,
  durationShort,
  departEarly,
  departLate,
}

class _OneWayRecommendedPageState extends State<OneWayRecommendedPage> {
  late DateTime _selectedDate;
  late List<OneWayFlight> _flights;
  late Map<DateTime, double> _datePrices;

  // Sort & Filter state
  _SortOption _sortOption = _SortOption.recommended;
  String _stopFilter = 'Any'; // 'Any', 'Nonstop', '1 stop or fewer'
  Set<String> _airlineFilter = {}; // empty = all

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.criteria.departDate;
    _datePrices = generateDatePrices(
      widget.criteria.from,
      widget.criteria.to,
      _selectedDate,
      cabin: widget.criteria.cabinClass,
    );
    _loadFlights();
  }

  void _loadFlights() {
    _flights = generateOneWayFlights(
      widget.criteria.from,
      widget.criteria.to,
      _selectedDate,
      cabin: widget.criteria.cabinClass,
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _loadFlights();
    });
  }

  String get _fromCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.from);
    return match?.group(1) ?? widget.criteria.from.split(' ').first;
  }

  String get _toCode {
    final match = RegExp(r'\((\w+)').firstMatch(widget.criteria.to);
    return match?.group(1) ?? widget.criteria.to.split(' ').first;
  }

  /// Returns a duration in minutes parsed from a string like "5h 30m".
  int _parseDurationMinutes(String d) {
    final hMatch = RegExp(r'(\d+)h').firstMatch(d);
    final mMatch = RegExp(r'(\d+)m').firstMatch(d);
    return (int.tryParse(hMatch?.group(1) ?? '0') ?? 0) * 60 +
        (int.tryParse(mMatch?.group(1) ?? '0') ?? 0);
  }

  /// Returns the list of flights after applying current sort & filter settings.
  List<OneWayFlight> get _displayFlights {
    // Filter
    var list = _flights.where((f) {
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

    // Sort
    switch (_sortOption) {
      case _SortOption.recommended:
        break; // keep original order
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

    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchPillBar(context),
            _buildDatePriceScroller(context),
            Expanded(
              child: _flights.isEmpty
                  ? _buildEmptyState(context)
                  : Builder(
                      builder: (context) {
                        final visible = _displayFlights;
                        if (visible.isEmpty) {
                          return _buildNoFilterResults(context);
                        }
                        return ListView(
                          padding: const EdgeInsets.only(bottom: 80),
                          children: [
                            _buildWatchPrices(context),
                            _buildDisclaimer(context),
                            _buildSectionHeader(context),
                            ...visible.map(
                              (flight) => OneWayFlightCard(
                                flight: flight,
                                onSelect: () =>
                                    _openSelectFare(context, flight),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSortFilterFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ─── Search Pill App Bar (Expedia style) ───
  Widget _buildSearchPillBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final pillBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final pillBorder = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;

    final dateText =
        '${DateFormat('MMM d').format(_selectedDate)}  ·  ${widget.criteria.travelers} traveler${widget.criteria.travelers > 1 ? 's' : ''}';

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
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
                          '$_fromCode → $_toCode',
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
          IconButton(
            icon: Icon(Icons.share_outlined, color: colors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ─── Horizontal date-price scroller ───
  Widget _buildDatePriceScroller(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final sortedDates = _datePrices.keys.toList()..sort();
    final formatter = NumberFormat.simpleCurrency(
      name: 'USD',
      decimalDigits: 0,
    );

    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF2A3141) : Colors.grey.shade200,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          final date = sortedDates[index];
          final price = _datePrices[date]!;
          final isSelected =
              date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          return GestureDetector(
            onTap: () => _selectDate(date),
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                          ? const Color(0xFF1A2340)
                          : const Color(0xFFE3F2FD))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: const Color(0xFF1565C0), width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E, MMM d').format(date),
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF1565C0))
                          : colors.onSurface,
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatter.format(price),
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.white : const Color(0xFF1565C0))
                          : colors.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Watch prices card ───
  Widget _buildWatchPrices(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Watch prices',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Get push notifications if prices go up or down',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close,
                size: 18,
                color: colors.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Container(
                width: 40,
                height: 22,
                decoration: BoxDecoration(
                  color: colors.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Disclaimer ───
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

  // ─── Section header ───
  Widget _buildSectionHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended departing flights',
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

  // ─── Empty state ───
  Widget _buildEmptyState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 64,
            color: colors.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No flights found for this route',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ─── No filter results ───
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

  // ─── Sort & Filter FAB ───
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
      child: Material(
        color: isDark ? const Color(0xFF151A24) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _showSortFilterSheet(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  size: 18,
                  color: isDark
                      ? const Color(0xFF7FB5FF)
                      : const Color(0xFF1565C0),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sort & Filter',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF7FB5FF)
                        : const Color(0xFF1565C0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hasActiveFilters) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1565C0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Sort & Filter Bottom Sheet ───
  void _showSortFilterSheet() {
    // Capture current values so the user can cancel
    var tempSort = _sortOption;
    var tempStop = _stopFilter;
    var tempAirlines = Set<String>.from(_airlineFilter);

    // Collect available airlines from current flights
    final availableAirlines = _flights.map((f) => f.airline).toSet().toList()
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
                                      // First selection: add all then toggle
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

  // ─── Navigation ───
  void _openSelectFare(BuildContext context, OneWayFlight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OneWaySelectFarePage(flight: flight, criteria: widget.criteria),
      ),
    );
  }
}
