import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/city_search_screen.dart';
import '../widgets/search_button.dart';
import '../widgets/traveler_modal.dart';
import 'models.dart';
import 'multi_city_recommended_page.dart';

class MultiCitySearchPage extends StatefulWidget {
  const MultiCitySearchPage({super.key});

  @override
  State<MultiCitySearchPage> createState() => _MultiCitySearchPageState();
}

class _MultiCitySearchPageState extends State<MultiCitySearchPage> {
  final _formKey = GlobalKey<FormState>();
  final from1Controller = TextEditingController();
  final to1Controller = TextEditingController();
  final date1Controller = TextEditingController();
  final from2Controller = TextEditingController();
  final to2Controller = TextEditingController();
  final date2Controller = TextEditingController();
  final from3Controller = TextEditingController();
  final to3Controller = TextEditingController();
  final date3Controller = TextEditingController();

  DateTime? depart1Date;
  DateTime? depart2Date;
  DateTime? depart3Date;

  bool addThirdLeg = false;
  int travelers = 1;
  String cabinClass = 'Economy';

  @override
  void dispose() {
    from1Controller.dispose();
    to1Controller.dispose();
    date1Controller.dispose();
    from2Controller.dispose();
    to2Controller.dispose();
    date2Controller.dispose();
    from3Controller.dispose();
    to3Controller.dispose();
    date3Controller.dispose();
    super.dispose();
  }

  void _openCitySearch(String label, TextEditingController controller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySearchScreen(title: 'Select $label'),
      ),
    );

    if (result != null) {
      setState(() {
        controller.text = result;
      });
    }
  }

  Future<void> _pickDate(
    TextEditingController controller,
    ValueChanged<DateTime> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      controller.text = DateFormat('EEE, MMM d').format(picked);
      onPicked(picked);
    }
  }

  void _showTravelerModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          TravelerModal(initialAdults: travelers, initialCabin: cabinClass),
    );

    if (result != null) {
      setState(() {
        travelers = result['adults'];
        cabinClass = result['cabin'];
      });
    }
  }

  void _startSearch() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (depart1Date == null || depart2Date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select departure dates for both flights'),
        ),
      );
      return;
    }
    if (addThirdLeg && depart3Date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a departure date for flight 3')),
      );
      return;
    }

    final criteria = MultiCitySearchCriteria(
      from1: from1Controller.text.trim(),
      to1: to1Controller.text.trim(),
      depart1: depart1Date!,
      from2: from2Controller.text.trim(),
      to2: to2Controller.text.trim(),
      depart2: depart2Date!,
      from3: addThirdLeg ? from3Controller.text.trim() : null,
      to3: addThirdLeg ? to3Controller.text.trim() : null,
      depart3: addThirdLeg ? depart3Date : null,
      travelers: travelers,
      cabinClass: cabinClass,
    );

    final selection = MultiCitySelection(criteria: criteria);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MultiCityRecommendedPage(selection: selection, segmentIndex: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBackground = isDark
        ? const Color(0xFF0B0F1A)
        : Colors.transparent;
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTravelerTile(),
                const SizedBox(height: 18),
                _buildFlightSection(
                  title: 'Flight 1',
                  fromController: from1Controller,
                  toController: to1Controller,
                  dateController: date1Controller,
                  onDateTap: () => _pickDate(
                    date1Controller,
                    (date) => setState(() => depart1Date = date),
                  ),
                ),
                const SizedBox(height: 20),
                _buildFlightSection(
                  title: 'Flight 2',
                  fromController: from2Controller,
                  toController: to2Controller,
                  dateController: date2Controller,
                  onDateTap: () => _pickDate(
                    date2Controller,
                    (date) => setState(() => depart2Date = date),
                  ),
                ),
                const SizedBox(height: 12),
                if (!addThirdLeg)
                  _buildAddAnotherFlightButton()
                else ...[
                  _buildFlightSection(
                    title: 'Flight 3',
                    fromController: from3Controller,
                    toController: to3Controller,
                    dateController: date3Controller,
                    onDateTap: () => _pickDate(
                      date3Controller,
                      (date) => setState(() => depart3Date = date),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRemoveFlightButton(),
                ],
                const SizedBox(height: 28),
                SearchButton(onPressed: _startSearch),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTravelerTile() {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? const Color(0xFF151A24)
        : colors.surface.withValues(alpha: 0.7);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return GestureDetector(
      onTap: _showTravelerModal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            const Icon(Icons.people_outline, color: Color(0xFF7FB5FF)),
            const SizedBox(width: 12),
            Text(
              '$travelers traveler${travelers > 1 ? 's' : ''}, $cabinClass',
              style: TextStyle(color: colors.onSurface, fontSize: 15),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAnotherFlightButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            addThirdLeg = true;
          });
        },
        icon: const Icon(Icons.add, color: Color(0xFF7FB5FF)),
        label: const Text(
          'Add another flight',
          style: TextStyle(color: Color(0xFF7FB5FF)),
        ),
      ),
    );
  }

  Widget _buildRemoveFlightButton() {
    final secondaryColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.6);
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            addThirdLeg = false;
            from3Controller.clear();
            to3Controller.clear();
            date3Controller.clear();
            depart3Date = null;
          });
        },
        icon: Icon(Icons.close, color: secondaryColor),
        label: Text('Remove flight 3', style: TextStyle(color: secondaryColor)),
      ),
    );
  }

  Widget _buildFlightSection({
    required String title,
    required TextEditingController fromController,
    required TextEditingController toController,
    required TextEditingController dateController,
    required VoidCallback onDateTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF111624)
        : colors.surface.withValues(alpha: 0.72);
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  _buildCityField(
                    label: 'Leaving from',
                    controller: fromController,
                    onTap: () => _openCitySearch('From', fromController),
                  ),
                  _buildCityField(
                    label: 'Going to',
                    controller: toController,
                    onTap: () => _openCitySearch('To', toController),
                  ),
                ],
              ),
              // Swap button positioned on the right between the two fields
              Positioned(
                right: 0,
                top: 32,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      final temp = fromController.text;
                      fromController.text = toController.text;
                      toController.text = temp;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2433) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2A3141)
                            : Colors.grey.shade400,
                      ),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                    ),
                    child: Icon(
                      Icons.swap_vert,
                      size: 22,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onDateTap,
            child: AbsorbPointer(
              child: TextFormField(
                controller: dateController,
                readOnly: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select date' : null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                  ),
                  labelText: 'Departure date',
                  labelStyle: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
                style: TextStyle(color: colors.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withValues(alpha: 0.35);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            validator: (value) =>
                value == null || value.isEmpty ? 'Select $label' : null,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
              labelText: label,
              labelStyle: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
            style: TextStyle(color: colors.onSurface),
          ),
        ),
      ),
    );
  }
}
