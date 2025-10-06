import 'package:fl_country_code_picker/fl_country_code_picker.dart';

class CountryPickerState {
  final CountryCode countryCode;

  CountryPickerState({required this.countryCode});

  // Default to Romania
  factory CountryPickerState.initial() {
    return CountryPickerState(
        countryCode:
            const CountryCode(name: "Romania", code: "RO", dialCode: "+40"));
  }

  // copyWith method to update countryCode selectively
  CountryPickerState copyWith({CountryCode? countryCode}) {
    return CountryPickerState(
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
