import 'package:flag/flag.dart';
import '../models/country.dart';
import '../constants/enums.dart';
import '../helpers/helpers.dart';
import '../phone_field.dart';
import '../constants/patterns.dart';
import 'country_picker_dialog.dart';
import '../constants/countries.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../validation/phone_number.dart';

class PhoneFieldState extends State<PhoneField> {
  late String number;
  String? validatorMessage;
  late Country _selectedCountry;
  late List<Country> _countryList;
  late List<Country> filteredCountries;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries ?? countries;
    filteredCountries = _countryList;
    number = widget.controller.text;
    if (number.startsWith('+')) {
      number = number.substring(1);
      // parse initial value
      _selectedCountry = countries.firstWhere((country) => number.startsWith(country.fullCountryCode),
          orElse: () => _countryList.first);
      // remove country code from the initial number value
      number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
      // set controller value
      widget.controller.text = number;
    } else {
      _selectedCountry = _countryList.firstWhere((item) => item.code == (widget.initialCountryCode ?? 'EG'),
          orElse: () => _countryList.first);

      // remove country code from the initial number value
      if (number.startsWith('+')) {
        number = number.replaceFirst(RegExp("^\\+${_selectedCountry.fullCountryCode}"), "");
        widget.controller.text = number;
      } else {
        number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
        widget.controller.text = number;
      }
    }

    if (widget.autovalidateMode == AutovalidateMode.always) {
      final initialPhoneNumber = PhoneNumber(
        countryISOCode: _selectedCountry.code,
        countryCode: '+${_selectedCountry.dialCode}',
        number: widget.controller.text,
      );

      final value = widget.validator?.call(initialPhoneNumber);

      if (value is String) {
        validatorMessage = value;
      } else {
        (value as Future).then((msg) {
          validatorMessage = msg;
        });
      }
    }
  }

  Future<void> _changeCountry() async {
    filteredCountries = _countryList;
    await showModalBottomSheet(
      context: context,
      enableDrag: true,
      useSafeArea: true,
      showDragHandle: true,
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: widget.backgroundColor,
      clipBehavior: Clip.antiAlias,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => CountryPickerDialog(
          countryList: _countryList,
          noResults: widget.noResults,
          style: widget.pickerDialogStyle,
          selectedCountry: _selectedCountry,
          filteredCountries: filteredCountries,
          languageCode: widget.languageCode.toLowerCase(),
          onCountryChanged: (Country country) {
            _selectedCountry = country;
            widget.onCountryChanged?.call(country);
            setState(() {});
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: widget.style,
      onTap: widget.onTap,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      controller: widget.controller,
      showCursor: widget.showCursor,
      cursorWidth: widget.cursorWidth,
      obscureText: widget.obscureText,
      cursorColor: widget.cursorColor,
      textDirection: TextDirection.ltr,
      onTapOutside: widget.onTapOutside,
      cursorHeight: widget.cursorHeight,
      keyboardType: widget.keyboardType,
      cursorRadius: widget.cursorRadius,
      onFieldSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      autovalidateMode: widget.autovalidateMode,
      textAlignVertical: widget.textAlignVertical,
      keyboardAppearance: widget.keyboardAppearance,
      maxLength: widget.disableLengthCheck ? null : _selectedCountry.maxLength + (number.startsWith('0') ? 1 : 0),
      autofillHints: widget.disableAutoFillHints ? null : [AutofillHints.telephoneNumberNational],
      inputFormatters:
          widget.inputFormatters ?? [FilteringTextInputFormatter.allow(RegExp('[${Patterns.plus}${Patterns.digits}]'))],
      decoration: widget.decoration.copyWith(
        suffixIcon: Directionality.of(context) == TextDirection.rtl ? _buildFlagsButton() : null,
        prefixIcon: Directionality.of(context) == TextDirection.ltr ? _buildFlagsButton() : null,
        counterText: !widget.enabled ? '' : null,
      ),
      onSaved: (value) {
        widget.onSaved?.call(
          PhoneNumber(
            countryISOCode: _selectedCountry.code,
            countryCode: '+${_selectedCountry.dialCode}${_selectedCountry.regionCode}',
            number: value!,
          ),
        );
      },
      onChanged: (value) async {
        number = value;
        if (number.startsWith('+')) {
          number = number.substring(1);
          // parse initial value
          final Country? newCountry = countries.cast<Country?>().firstWhere(
                (country) => number.startsWith(country!.fullCountryCode),
                orElse: () => null,
              );
          if (newCountry != null) {
            _selectedCountry = newCountry;
            // remove country code from the initial number value
            number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
            widget.controller.clear();
          }
        }
        if (number.startsWith('0') && number.length > _selectedCountry.maxLength) {
          number = number.substring(1);
          number = number.replaceFirst(RegExp("^0"), "");
          widget.controller.text = number;
        }
        final phoneNumber = PhoneNumber(
          number: widget.controller.text,
          countryISOCode: _selectedCountry.code,
          countryCode: '+${_selectedCountry.fullCountryCode}',
        );
        setState(() {});
        if (widget.autovalidateMode != AutovalidateMode.disabled) {
          validatorMessage = await widget.validator?.call(phoneNumber);
        }

        widget.onChanged?.call(phoneNumber);
      },
      validator: (value) {
        if (value == null || !isNumeric(value)) return validatorMessage;
        if (!widget.disableLengthCheck) {
          final int minLength = _selectedCountry.minLength + (number.startsWith('0') ? 1 : 0);
          final int maxLength = _selectedCountry.maxLength + (number.startsWith('0') ? 1 : 0);
          return value.length >= minLength && value.length <= maxLength ? null : widget.invalidNumberMessage;
        }
        return validatorMessage;
      },
    );
  }

  Container _buildFlagsButton() {
    return Container(
      margin: widget.flagsButtonMargin,
      child: DecoratedBox(
        decoration: widget.dropdownDecoration,
        child: InkWell(
          borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
          onTap: widget.enabled ? _changeCountry : null,
          child: Padding(
            padding: widget.flagsButtonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: widget.codeSpace ?? 4),
                FittedBox(
                  child: Text(
                    '+${_selectedCountry.dialCode}',
                    style: widget.dropdownTextStyle,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.trailing)
                  widget.dropdownIcon,
                const SizedBox(width: 4),
                if (widget.showCountryFlag) ...[
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: widget.flagRadius != null ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: widget.flagRadius != null ? BorderRadius.circular(widget.flagRadius ?? 0.0) : null,
                    ),
                    child: Flag.fromString(
                      _selectedCountry.code,
                      fit: BoxFit.cover,
                      width: widget.flagWidth ?? 25,
                      height: widget.flagHeight ?? 25,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                if (widget.enabled && widget.showDropdownIcon && widget.dropdownIconPosition == IconPosition.leading)
                  widget.dropdownIcon,
                SizedBox(width: widget.flagSpace ?? 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
