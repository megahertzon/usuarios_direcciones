import 'package:flutter/material.dart';
import 'package:usuarios_direcciones/features/shared/domain/entities/address.dart';


class AddressRow {
  final int? id;
  final TextEditingController street;
  final TextEditingController city;
  final TextEditingController country;

  AddressRow({this.id, String? street, String? city, String? country})
      : street = TextEditingController(text: street ?? ''),
        city = TextEditingController(text: city ?? ''),
        country = TextEditingController(text: country ?? '');

  factory AddressRow.fromAddress(Address a) => AddressRow(
        id: a.id,
        street: a.street,
        city: a.city,
        country: a.country,
      );

  factory AddressRow.empty() => AddressRow();

  bool get hasAny =>
      street.text.trim().isNotEmpty ||
      city.text.trim().isNotEmpty ||
      country.text.trim().isNotEmpty;

  void dispose() {
    street.dispose();
    city.dispose();
    country.dispose();
  }
}