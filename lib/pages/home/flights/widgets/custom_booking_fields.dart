// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomBookingFields {
  static const List<String> genderOptions = ['MALE', 'FEMALE'];
  static const List<String> countryCodes = [
    '+1', '+20', '+27', '+31', '+32', '+33', '+34', '+39', '+41', '+44', '+46', '+47', '+49',
    '+52', '+54', '+55', '+61', '+63', '+64', '+65', '+81', '+82', '+84', '+86', '+90', '+91',
    '+92', '+94', '+98', '+212', '+213', '+234', '+251', '+254', '+351', '+353', '+358',
    '+380', '+420', '+48', '+852', '+886', '+966', '+971', '+972', '+974'
  ];

  static Widget buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withOpacity(0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  static Widget buildGenderDropdown({
    required BuildContext context,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withOpacity(0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: onChanged,
        dropdownColor: fillColor,
        validator: (v) => v == null ? 'Required' : null,
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.primary),
          ),
        ),
      ),
    );
  }

  static Widget buildPhoneField({
    required BuildContext context,
    required String selectedCountryCode,
    required TextEditingController phoneController,
    required ValueChanged<String?> onCountryCodeChanged,
    required String? Function(String?) validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withOpacity(0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            child: DropdownButtonFormField<String>(
              value: selectedCountryCode,
              items: countryCodes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: onCountryCodeChanged,
              dropdownColor: fillColor,
              style: TextStyle(color: colors.onSurface),
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              validator: validator,
              style: TextStyle(color: colors.onSurface),
              decoration: InputDecoration(
                labelText: 'Phone number',
                labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: fillColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDatePickerField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required DateTime firstDate,
    required DateTime lastDate,
    required String? Function(String?) validator,
    bool isExpiry = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final fillColor = isDark ? const Color(0xFF151A24) : colors.surface;
    final borderColor = isDark
        ? const Color(0xFF2A3141)
        : Theme.of(context).dividerColor.withOpacity(0.35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: validator,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: isExpiry ? DateTime.now() : DateTime(2000),
            firstDate: firstDate,
            lastDate: lastDate,
            initialDatePickerMode: isExpiry ? DatePickerMode.year : DatePickerMode.day,
          );
          if (date != null) {
            controller.text = isExpiry
                ? DateFormat('MM/yy').format(date)
                : DateFormat('yyyy-MM-dd').format(date);
          }
        },
        style: TextStyle(color: colors.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colors.onSurface.withOpacity(0.6)),
          suffixIcon: const Icon(Icons.calendar_today, size: 20),
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
