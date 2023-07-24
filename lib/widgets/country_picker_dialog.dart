import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/helpers/helpers.dart';

import '../models/country.dart';

class PickerDialogStyle {
  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  PickerDialogStyle({
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
  });
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;

  const CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
  }) : super(key: key);

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late Country _selectedCountry;
  late List<Country> _filteredCountries;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries.toList()
      ..sort(
        (a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.style?.padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            cursorColor: widget.style?.searchFieldCursorColor,
            decoration: widget.style?.searchFieldInputDecoration ??
                InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  labelText: widget.searchText,
                ),
            onChanged: (value) {
              _filteredCountries = widget.countryList.stringSearch(value)
                ..sort(
                  (a, b) => a.localizedName(widget.languageCode).compareTo(b.localizedName(widget.languageCode)),
                );
              if (mounted) setState(() {});
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemCount: _filteredCountries.length,
              itemBuilder: (ctx, index) => Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    horizontalTitleGap: 10,
                    contentPadding: widget.style?.listTilePadding,
                    leading: Flag.fromString(_filteredCountries[index].code, height: 20, width: 25, fit: BoxFit.fill),
                    title: Text(
                      _filteredCountries[index].localizedName(widget.languageCode),
                      style: widget.style?.countryNameStyle ?? const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      '+${_filteredCountries[index].dialCode}',
                      style: widget.style?.countryCodeStyle ?? const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      _selectedCountry = _filteredCountries[index];
                      widget.onCountryChanged(_selectedCountry);
                      Navigator.of(context).pop();
                    },
                  ),
                  widget.style?.listTileDivider ?? const Divider(thickness: 0.5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
