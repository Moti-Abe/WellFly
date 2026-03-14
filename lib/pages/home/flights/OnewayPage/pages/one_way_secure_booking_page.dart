// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../../../data/models/passenger_model.dart';
import '../../../../../data/models/booking_model.dart';
import '../../controllers/flight_controller.dart';
import '../models/one_way_models.dart';
import 'one_way_booking_confirmation_page.dart';
import '../../widgets/custom_booking_fields.dart';

/// Page 7: Secure booking — traveler info + payment form.
class OneWaySecureBookingPage extends StatefulWidget {
  final OneWayBooking booking;

  const OneWaySecureBookingPage({super.key, required this.booking});

  @override
  State<OneWaySecureBookingPage> createState() =>
      _OneWaySecureBookingPageState();
}

class _OneWaySecureBookingPageState extends State<OneWaySecureBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passportController = TextEditingController();
  final _titleController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  
  String _paymentMethod = 'Visa';
  String? _genderValue;
  String _selectedCountryCode = '+1';
  

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passportController.dispose();
    _titleController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  double get _totalPrice => widget.booking.totalPrice;

  Future<void> _completeBooking() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<FlightController>();
    
    // Construct Passenger object
    // Note: OneWaySecureBookingPage currently has a simpler form. 
    // I should ensure it matches API requirements.
    final passenger = Passenger(
      gender: _genderValue ?? 'MALE',
      birthDate: _birthDateController.text,
      phoneNo: '$_selectedCountryCode ${_phoneController.text}',
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      country: 'USA',
      passPort: _passportController.text,
      title: _titleController.text,
      email: _emailController.text,
      paxId: '1',
    );

    final holdRequest = BookingHoldRequest(
      offerId: widget.booking.flight.id,
      passengers: [passenger],
    );

    final success = await controller.startBooking(holdRequest);
    
    if (success) {
      // Create payment request
      final payOption = controller.paymentOptions.firstWhere(
        (o) => o.name == _paymentMethod || o.id == _paymentMethod,
        orElse: () => controller.paymentOptions.isNotEmpty 
            ? controller.paymentOptions.first 
            : PaymentOption(id: '1'),
      );

      final cardInfo = CardInfo(
        cardHolder: '${_firstNameController.text} ${_lastNameController.text}',
        cardNumber: _cardController.text,
        expireMonth: _expiryController.text.split('/').first,
        expireYear: '20' + _expiryController.text.split('/').last,
        cvv: _cvvController.text,
      );

      final confirmRequest = ConfirmBookingRequest(
        bookingLocator: controller.bookingLocator.value,
        payOption: payOption,
        cardInfo: cardInfo,
      );

      final confirmSuccess = await controller.confirmBooking(confirmRequest);

      if (confirmSuccess) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => OneWayBookingConfirmationPage(booking: widget.booking),
          ),
        );
      } else {
        Get.snackbar('Error', 'Payment failed: ${controller.errorMessage.value}', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Error', 'Booking hold failed: ${controller.errorMessage.value}', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final pageBackground = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final formatter = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        foregroundColor: colors.onSurface,
        title: const Text('Secure booking'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              // Flight summary card
              _buildFlightSummary(context),
              const SizedBox(height: 20),

              _buildSectionTitle('Traveler details'),
              CustomBookingFields.buildTextField(
                context: context,
                label: 'First name',
                controller: _firstNameController,
                validator: _requiredValidator,
              ),
              CustomBookingFields.buildTextField(
                context: context,
                label: 'Last name',
                controller: _lastNameController,
                validator: _requiredValidator,
              ),
              Row(
                children: [
                   Expanded(
                    child: CustomBookingFields.buildTextField(
                      context: context,
                      label: 'Title',
                      controller: _titleController,
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomBookingFields.buildGenderDropdown(
                      context: context,
                      value: _genderValue,
                      onChanged: (val) => setState(() => _genderValue = val),
                    ),
                  ),
                ],
              ),
              CustomBookingFields.buildDatePickerField(
                context: context,
                label: 'Birth Date',
                controller: _birthDateController,
                validator: _requiredValidator,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              ),
              CustomBookingFields.buildTextField(
                context: context,
                label: 'Passport Number',
                controller: _passportController,
                validator: _requiredValidator,
              ),
              CustomBookingFields.buildTextField(
                context: context,
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _emailValidator,
              ),
              CustomBookingFields.buildPhoneField(
                context: context,
                selectedCountryCode: _selectedCountryCode,
                phoneController: _phoneController,
                onCountryCodeChanged: (val) => setState(() => _selectedCountryCode = val!),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('Payment method'),
              _buildDropdown(),
              CustomBookingFields.buildTextField(
                context: context,
                label: 'Card number',
                controller: _cardController,
                keyboardType: TextInputType.number,
                validator: _requiredValidator,
                hintText: '0000 0000 0000 0000',
                suffixIcon: const Icon(Icons.lock, size: 20, color: Colors.grey),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomBookingFields.buildDatePickerField(
                      context: context,
                      label: 'Expiry date (MM/YY)',
                      controller: _expiryController,
                      validator: _requiredValidator,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 20),
                      isExpiry: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomBookingFields.buildTextField(
                      context: context,
                      label: 'CVV',
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      validator: _requiredValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() => _buildTotalRow(
                'Total to pay', 
                formatter.format(Get.find<FlightController>().currentGrandTotal > 0 ? Get.find<FlightController>().currentGrandTotal : _totalPrice)
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildFlightSummary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF151A24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A3141) : Colors.grey.shade200;
    final flight = widget.booking.flight;
    final fromName = flight.fromCity.split(' (').first;
    final toName = flight.toCity.split(' (').first;

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
            'Flight summary',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _summaryRow(context, 'Route', '$fromName → $toName'),
          _summaryRow(context, 'Date', flight.dateLabel),
          _summaryRow(
            context,
            'Time',
            '${flight.departTime} - ${flight.arriveTime}',
          ),
          _summaryRow(context, 'Airline', flight.airline),
          _summaryRow(context, 'Fare', widget.booking.fare.name),
          if (widget.booking.selectedSeat != null)
            _summaryRow(context, 'Seat', widget.booking.selectedSeat!),
          if (widget.booking.baggage != null)
            _summaryRow(context, 'Bags', widget.booking.baggage!.label),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        // ignore: deprecated_member_use
        : Theme.of(context).dividerColor.withOpacity(0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: _paymentMethod,
        items: const [
          DropdownMenuItem(value: 'Visa', child: Text('Visa')),
          DropdownMenuItem(value: 'Mastercard', child: Text('Mastercard')),
          DropdownMenuItem(value: 'Amex', child: Text('American Express')),
        ],
        onChanged: (value) => setState(() => _paymentMethod = value ?? 'Visa'),
        dropdownColor: fillColor,
        // ignore: deprecated_member_use
        iconEnabledColor: colors.onSurface.withOpacity(0.75),
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: 'Payment method',
          labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final cardColor = isDark ? const Color(0xFF111624) : Colors.grey.shade50;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withOpacity(0.35);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: colors.onSurface.withOpacity(0.75)),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF0B0F1A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E2433) : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: _completeBooking,
            child: const Text(
              'Complete Booking',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (!v.contains('@')) return 'Enter a valid email';
    return null;
  }
}

