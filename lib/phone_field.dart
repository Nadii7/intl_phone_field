library intl_phone_field;

import 'dart:async';
import 'constants/enums.dart';
import 'models/country.dart';
import 'widgets/phone_field_state.dart';
import 'validation/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/country_picker_dialog.dart';

class PhoneField extends StatefulWidget {
  final bool obscureText;

  final TextAlign textAlign;

  final TextAlignVertical? textAlignVertical;

  final VoidCallback? onTap;

  final Function(PointerDownEvent)? onTapOutside;

  final bool readOnly;
  
  final FormFieldSetter<PhoneNumber>? onSaved;

  final ValueChanged<PhoneNumber>? onChanged;

  final ValueChanged<Country>? onCountryChanged;

  final FutureOr<String?> Function(PhoneNumber?)? validator;

  final TextInputType keyboardType;

  final TextEditingController controller;

  final FocusNode? focusNode;

  final void Function(String)? onSubmitted;

  final bool enabled;

  final Brightness? keyboardAppearance;

  final String languageCode;

  final String? initialCountryCode;

  final List<Country>? countries;

  final InputDecoration decoration;

  final TextStyle? style;

  final bool disableLengthCheck;

  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;

  final TextStyle? dropdownTextStyle;

  final List<TextInputFormatter>? inputFormatters;

  final String searchText;

  final IconPosition dropdownIconPosition;

  final Icon dropdownIcon;

  final bool autofocus;

  final AutovalidateMode? autovalidateMode;

  final bool showCountryFlag;

  final String? invalidNumberMessage;

  final Color? cursorColor;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final double cursorWidth;

  final double? flagRadius;
  final double? flagHeight;
  final double? flagWidth;
  final double? flagSpace;
  final double? codeSpace;

  final bool? showCursor;

  final EdgeInsetsGeometry flagsButtonPadding;

  final TextInputAction? textInputAction;

  final PickerDialogStyle? pickerDialogStyle;

  final EdgeInsets flagsButtonMargin;

  final bool disableAutoFillHints;

  final Color? backgroundColor;

  const PhoneField({
    Key? key,
    this.flagSpace,
    this.codeSpace,
    this.backgroundColor,
    this.initialCountryCode,
    this.languageCode = 'en',
    this.disableAutoFillHints = false,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.flagRadius,
    this.flagHeight,
    this.flagWidth,
    this.onTapOutside,
    this.readOnly = false,
    this.keyboardType = TextInputType.phone,
    required this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.onCountryChanged,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.inputFormatters,
    this.enabled = true,
    this.keyboardAppearance,
    @Deprecated('Use searchFieldInputDecoration of PickerDialogStyle instead') this.searchText = 'Search country',
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.cursorColor,
    this.disableLengthCheck = false,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.pickerDialogStyle,
    this.flagsButtonMargin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  State<PhoneField> createState() => PhoneFieldState();
}
