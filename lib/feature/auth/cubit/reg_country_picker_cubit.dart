import 'package:auto_asig/feature/auth/cubit/reg_country_picker_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

class CountryPickerCubit extends Cubit<CountryPickerState> {
  CountryPickerCubit() : super(CountryPickerState.initial());

  void selectCountry(CountryCode countryCode) {
    emit(state.copyWith(countryCode: countryCode));
  }
}
