import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FlightSortOption {
  recommended,
  priceLow,
  priceHigh,
  durationShort,
  departEarly,
  departLate,
}

/// A reusable search pill bar similar to Expedia/travel apps.
class FlightSearchPill extends StatelessWidget {
  final String routeTitle;
  final String dateAndTravelerInfo;
  final VoidCallback? onBack;
  final VoidCallback? onShare;

  const FlightSearchPill({
    super.key,
    required this.routeTitle,
    required this.dateAndTravelerInfo,
    this.onBack,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final bgColor = isDark ? const Color(0xFF0B0F1A) : colors.surface;
    final pillBg = isDark ? const Color(0xFF151A24) : Colors.white;
    final pillBorder = isDark ? const Color(0xFF2A3141) : Colors.grey.shade300;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: Icon(Icons.arrow_back, color: colors.onSurface),
              onPressed: onBack,
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
                          routeTitle,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateAndTravelerInfo,
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
          if (onShare != null)
            IconButton(
              icon: Icon(Icons.share_outlined, color: colors.onSurface),
              onPressed: onShare,
            ),
        ],
      ),
    );
  }
}

/// A horizontal scroller for date-price pairs.
class DatePriceScroller extends StatelessWidget {
  final Map<DateTime, double> datePrices;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DatePriceScroller({
    super.key,
    required this.datePrices,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (datePrices.isEmpty) return const SizedBox.shrink();
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final sortedDates = datePrices.keys.toList()..sort();
    final formatter = NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0);

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
          final price = datePrices[date]!;
          final isSelected =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF1A2340) : const Color(0xFFE3F2FD))
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
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
}

/// "Watch prices" card with a toggle placeholder.
class FlightWatchPricesCard extends StatelessWidget {
  const FlightWatchPricesCard({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Small disclaimer text.
class FlightDisclaimer extends StatelessWidget {
  const FlightDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Section header with an info icon.
class FlightSectionHeader extends StatelessWidget {
  final String title;
  const FlightSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
}

/// Centralized Sort & Filter FAB logic.
class FlightSortFilterFab extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onTap;

  const FlightSortFilterFab({
    super.key,
    required this.hasActiveFilters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  size: 18,
                  color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sort & Filter',
                  style: TextStyle(
                    color: isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0),
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
}

/// Generic empty state for when no flights are found for a route.
class FlightEmptyState extends StatelessWidget {
  const FlightEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Generic empty state for when filters return no results.
class FlightNoFilterResults extends StatelessWidget {
  final VoidCallback onClearFilters;

  const FlightNoFilterResults({super.key, required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
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
              onPressed: onClearFilters,
              child: const Text('Clear all filters'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A centralized function to show the Sort & Filter bottom sheet.
void showFlightSortFilterSheet({
  required BuildContext context,
  required FlightSortOption currentSort,
  required String currentStopFilter,
  required Set<String> currentAirlineFilter,
  required List<String> availableAirlines,
  required Function(FlightSortOption, String, Set<String>) onApply,
}) {
  var tempSort = currentSort;
  var tempStop = currentStopFilter;
  var tempAirlines = Set<String>.from(currentAirlineFilter);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
      final colors = Theme.of(sheetContext).colorScheme;
      final bgColor = isDark ? const Color(0xFF151A24) : Colors.white;
      final accentColor = isDark ? const Color(0xFF7FB5FF) : const Color(0xFF1565C0);

      return StatefulBuilder(
        builder: (ctx, setSheetState) {
          Widget sortTile(String label, FlightSortOption value) {
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
              trailing: selected ? Icon(Icons.check, color: accentColor, size: 20) : null,
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
                  color: selected ? accentColor : colors.onSurface.withValues(alpha: 0.3),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          tempSort = FlightSortOption.recommended;
                          tempStop = 'Any';
                          tempAirlines = {};
                        }),
                        child: Text('Reset', style: TextStyle(color: accentColor)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        sortTile('Recommended', FlightSortOption.recommended),
                        sortTile('Price (low to high)', FlightSortOption.priceLow),
                        sortTile('Price (high to low)', FlightSortOption.priceHigh),
                        sortTile('Duration (shortest)', FlightSortOption.durationShort),
                        sortTile('Departure (earliest)', FlightSortOption.departEarly),
                        sortTile('Departure (latest)', FlightSortOption.departLate),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
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
                          final selected = tempAirlines.isEmpty || tempAirlines.contains(airline);
                          return CheckboxListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                            title: Text(airline, style: TextStyle(color: colors.onSurface)),
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
                                  if (tempAirlines.length == availableAirlines.length) {
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
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          onApply(tempSort, tempStop, tempAirlines);
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
